import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Ride.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

class RidesProvider with ChangeNotifier {
  List<Ride> remainingRides;
  List<Ride> currentRides;
  final retryDelay = Duration(seconds: 30);

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

  Future<void> requestActiveRides(BuildContext context) async {
    final dateFormat = DateFormat("yyyy-MM-dd");
    DateTime now = DateTime.now();
    final response = await http.get(AppConfig.of(context).baseUrl + '/rides?type=active&date=${dateFormat.format(now)}&driver=${Provider.of<AuthProvider>(context, listen: false).id}');
    if (response.statusCode == 200) {
      List<Ride> rides = ridesFromJson(response.body);
      currentRides = [];
      remainingRides = [];
      for (Ride r in rides) {
        if (r.status == RideStatus.NOT_STARTED) {
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
      requestActiveRides(context);
    }
  }
}
