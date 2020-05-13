import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'AuthProvider.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

class Break {
  String day;
  String startTime;
  String endTime;
  Break(this.day, this.startTime, this.endTime);

  factory Break.fromJson(String day, Map<String, dynamic> json) {
    return Break(day, json['breakStart'], json['breakEnd']);
  }

  String toString() {
    return "$day: $startTime to $endTime";
  }
}

class Breaks {
  List<Break> breaks;
  Breaks(this.breaks);

  factory Breaks.fromJson(Map<String, dynamic> json) {
    List<Break> breaks = [];
    json.forEach((k, v) {
      breaks.add(Break.fromJson((abbrevToDay(k)), json[k]));
    });
    return Breaks(breaks);
  }

  static String abbrevToDay(String abbrev) {
    switch (abbrev) {
      case ("Mon"):
        return "Monday";
      case ("Tue"):
        return "Tuesday";
      case ("Wed"):
        return "Wednesday";
      case ("Thu"):
        return "Thursday";
      case ("Fri"):
        return "Friday";
      default:
        return "INVALID DAY";
    }
  }

  String toString() {
    if (breaks.isEmpty) return "None";
    else {
      String str = "";
      for (Break b in breaks) {
        str += b.toString();
        if (b != breaks.last) {
          str += "\n";
        }
      }
      return str;
    }
  }
}

class UserInfo {
  final String firstName;
  final String lastName;
  final String startTime;
  final String endTime;
  final Breaks breaks;
  final String vehicle;
  final String phoneNumber;
  final String email;
  final String photoUrl;
  String fullName() => firstName + " " + lastName;

  UserInfo(
      {this.firstName,
      this.lastName,
      this.startTime,
      this.endTime,
      this.breaks,
      this.vehicle,
      this.phoneNumber,
      this.email,
      this.photoUrl});

  factory UserInfo.fromJson(Map<String, dynamic> json, String photoUrl) {
    return UserInfo(
        firstName: json['firstName'],
        lastName: json['lastName'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        breaks: Breaks.fromJson(json['breaks']),
        vehicle: json['vehicle'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        photoUrl: photoUrl);
  }
}

class UserInfoProvider with ChangeNotifier {
  UserInfo info;
  bool hasInfo() => info != null;

  final retryDelay = Duration(seconds: 30);

  UserInfoProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) requestInfo(config, authProvider);
    };
    callback();
    authProvider.addListener(callback);
  }

  void _setInfo(UserInfo info) {
    this.info = info;
    notifyListeners();
  }

  Future<void> requestInfo(AppConfig config, AuthProvider authProvider) async {
    await http
        .get("${config.baseUrl}/drivers/${authProvider.id}")
        .then((response) async {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        _setInfo(UserInfo.fromJson(
            json, authProvider.googleSignIn.currentUser.photoUrl));
      } else {
        // TODO: retry only in certain circumstances
        await Future.delayed(retryDelay);
        requestInfo(config,authProvider);
      }
    });
  }

  Future<void> updateDriver(AppConfig config, AuthProvider authProvider,
          String firstName, String lastName, String phoneNumber) async {
    final response = await http.put(
      "${config.baseUrl}/drivers/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      }),
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      _setInfo(UserInfo.fromJson(
          json, authProvider.googleSignIn.currentUser.photoUrl));
    } else {
      throw Exception('Failed to update driver.');
    }
  }
}
