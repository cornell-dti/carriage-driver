import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import '../models/Ride.dart';
import '../utils/app_config.dart';
import 'package:http/http.dart' as http;

class RidesProvider with ChangeNotifier {
  List<Ride> remainingRides;
  List<Ride> currentRides;
  List<Ride> pastRides;

  RidesProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () async {
      if (authProvider.isAuthenticated) {
        await requestActiveRides(config, authProvider);
        await requestPastRides(config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  final retryDelay = Duration(seconds: 30);

  bool hasActiveRides() {
    return remainingRides != null && currentRides != null;
  }

  bool hasPastRides() {
    return pastRides != null;
  }

  void changeRideToCurrent(Ride ride) {
    remainingRides.remove(ride);
    currentRides.add(ride);
    notifyListeners();
  }

  void finishCurrentRide(Ride ride) {
    currentRides.remove(ride);
    notifyListeners();
  }

  List<Ride> ridesFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Ride> res = data
        .map<Ride>((e) => Ride.fromJson(e))
        .toList();
    res.sort((a, b) => a.startTime.compareTo(b.startTime));
    return res;
  }

  Future<void> requestActiveRides(AppConfig config, AuthProvider authProvider) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime now = DateTime.now();
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        config.baseUrl + '/rides?type=active&date=${dateFormat.format(now)}&driver=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
    );
    if (response.statusCode == 200) {
      List<Ride> rides = ridesFromJson(response.body);
      currentRides = [];
      remainingRides = [];
      for (Ride r in rides) {
        if (r.status == RideStatus.NOT_STARTED || r.status == RideStatus.ON_THE_WAY) {
          remainingRides.add(r);
        }
        else {
          currentRides.add(r);
        }
      }
      notifyListeners();
    } else {
      // TODO: retry only in certain circumstances
      await Future.delayed(retryDelay);
      requestActiveRides(config, authProvider);
    }
  }

  Future<void> requestPastRides(AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        config.baseUrl + '/rides?type=past&driver=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
    );
    if (response.statusCode == 200) {
      pastRides = ridesFromJson(response.body);
      notifyListeners();
    } else {
      // TODO: retry only in certain circumstances
      await Future.delayed(retryDelay);
      requestPastRides(config, authProvider);
    }
  }
}
