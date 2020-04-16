import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Home.dart';
import 'Ride.dart';
import 'Upcoming.dart';
import 'package:http/http.dart' as http;

// Data for Rides page
class _RideData {
  List<Ride> rides;
  Ride currentRide;
  _RideData(this.rides, this.currentRide);
}

class Rides extends StatefulWidget {
  // TODO: placeholder
  final String driverId = "test";

  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  Future<_RideData> rideData;

  @override
  void initState() {
    super.initState();
    rideData = _fetchRides();
  }

  Future<_RideData> _fetchRides() async {
    var now = DateTime.now();
    final dateFormat = DateFormat("yyyy-MM-dd");
    // TODO: use real endpoint
    final response = await http
        .get('localhost:3000/active-rides?date=${dateFormat.format(now)}');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["data"];
      List<Ride> activeRides = data.map((e) => Ride.fromJson(e));
      List<Ride> rides = activeRides
          .where((e) => e.driverId.contains(widget.driverId))
          .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
      rides.removeAt(0);
      Ride currentRide = rides[0];
      var d = _RideData(rides,currentRide);
      return d;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  // TODO: replace this when name is stored somewhere
  String getNameFromSharedStateSomewhere() {
    return "Chris";
  }

  Widget _futureRide(BuildContext context, _RideData d, int index) {
    return FutureRide(d.rides[index]);
  }

  Widget _emptyPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 195),
        Center(
            child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/steeringWheel@3x.png'),
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            SizedBox(height: 22),
            Text(
              'Congratulations! You are done for the day. \n'
              'Come back tomorrow!',
              textAlign: TextAlign.center,
            )
          ],
        )),
      ],
    );
  }

  Widget _mainPage(BuildContext context, _RideData data) {
    return Column(children: <Widget>[
      LeftSubheading(heading: 'Upcoming Ride'),
      Center(
        child: CurrentRide(data.currentRide),
      ),
      SizedBox(height: 16.0),
      LeftSubheading(heading: 'Today\'s Schedule'),
      Flexible(
        child: ListView.separated(
          itemCount: data.rides.length,
          itemBuilder: (BuildContext c, int index) =>
              _futureRide(c, data, index),
          separatorBuilder: (BuildContext context, int index) => Divider(),
          padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 5.0),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Greeting(getNameFromSharedStateSomewhere()),
          FutureBuilder<_RideData>(
              future: rideData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.rides.length == 0) {
                    return _emptyPage(context);
                  } else {
                    return _mainPage(context, snapshot.data);
                  }
                } else if (snapshot.hasError) {
                  // TODO: placeholder error response
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              })
        ]);
  }
}
