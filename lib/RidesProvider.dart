import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AuthProvider.dart';
import 'Ride.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

class RidesProvider with ChangeNotifier {
  List<Ride> remainingRides;
  List<Ride> currentRides;
  final retryDelay = Duration(seconds: 30);

  void _setCurrentRides(List<Ride> rides) {
    this.currentRides = rides;
    notifyListeners();
  }

  void _setRemainingRides(List<Ride> rides) {
    this.remainingRides = rides;
    notifyListeners();
  }

  Future<List<Ride>> fetchRides(AppConfig config, AuthProvider authProvider) async {
    final dateFormat = DateFormat("yyyy-MM-dd");
    DateTime now = DateTime.now();
    final response = await http.get(config.baseUrl + '/rides?type=active&date=${dateFormat.format(now)}&driver=${authProvider.id}');
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<Ride> rides = ridesFromJson(responseBody);
      return rides;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  Future<void> requestActiveRides(AppConfig config, AuthProvider authProvider) async {
    final dateFormat = DateFormat("yyyy-MM-dd");
    DateTime now = DateTime.now();
    final response = await http.get(config.baseUrl + '/rides?type=active&date=${dateFormat.format(now)}&driver=${authProvider.id}');
    if (response.statusCode == 200) {
      List<Ride> rides = ridesFromJson(response.body);
      List<Ride> current = [];
      List<Ride> remaining = [];
      for (Ride r in rides) {
        if (r.status == RideStatus.NOT_STARTED) {
          remaining.add(r);
        }
        else {
          current.add(r);
        }
      }
      _setCurrentRides(current);
      _setRemainingRides(remaining);
    } else {
      // TODO: retry only in certain circumstances
      await Future.delayed(retryDelay);
      requestActiveRides(config, authProvider);
    }
  }
}
