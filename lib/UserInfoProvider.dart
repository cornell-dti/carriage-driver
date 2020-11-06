import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'AuthProvider.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

///Type for a break in a driver's schedule.
class Break {
  ///Full name of the day of the week the break occurs again.
  String day;

  ///The start time of the break.
  String startTime;

  ///The end time of the break.
  String endTime;
  Break(this.day, this.startTime, this.endTime);

  ///Creates a break from JSON representation.
  factory Break.fromJson(String day, Map<String, dynamic> json) {
    return Break(day, json['breakStart'], json['breakEnd']);
  }

  String toString() {
    return "$day: $startTime to $endTime";
  }
}

///Collection of times when the driver goes on break.
class Breaks {
  List<Break> breaks;
  Breaks(this.breaks);

  ///Creates breaks from JSON representation.
  factory Breaks.fromJson(Map<String, dynamic> json) {
    List<Break> breaks = [];
    json.forEach((k, v) {
      breaks.add(Break.fromJson((abbrevToDay(k)), json[k]));
    });
    return Breaks(breaks);
  }

  ///Converts a 3-character abbreviation for a day of the week [abbrev]
  ///to its full name.
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
    if (breaks.isEmpty)
      return "None";
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

///Model for a driver's info. Matches the schema in the backend.
class UserInfo {
  ///The first name of the driver.
  final String firstName;

  ///The last name of the driver.
  final String lastName;

  ///Time that the driver starts working.
  final String startTime;

  ///Time that the driver stops working.
  final String endTime;

  ///The driver's breaks.
  final Breaks breaks;

  ///Name of the vehicle the driver uses.
  final String vehicle;

  ///The rider's phone number in format ##########.
  final String phoneNumber;

  ///The driver's email.
  final String email;

  ///The url of the driver's profile picture.
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

  ///Creates driver info from JSON representation.
  factory UserInfo.fromJson(Map<String, dynamic> json, String photoUrl) {
    return UserInfo(
        firstName: json['firstName'],
        lastName: json['lastName'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        breaks: Breaks.fromJson(json['breaks']),
        vehicle: json['vehicle']['name'],
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

  /// Fetches the logged in driver's data and updates [info] with the
  /// retrieved data. Retries continuously if the request fails.
  Future<void> requestInfo(AppConfig config, AuthProvider authProvider) async {
    await http
        .get("${config.baseUrl}/drivers/${authProvider.id}")
        .then((response) async {
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        _setInfo(UserInfo.fromJson(
            json, authProvider.googleSignIn.currentUser.photoUrl));
      } else {
        // TODO: retry only in certain circumstances
        await Future.delayed(retryDelay);
        requestInfo(config, authProvider);
      }
    });
  }

  /// Updates the logged in driver's name and phone number.
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
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(UserInfo.fromJson(
          json, authProvider.googleSignIn.currentUser.photoUrl));
    } else {
      throw Exception('Failed to update driver.');
    }
  }
}
