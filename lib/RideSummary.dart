import 'package:flutter/material.dart';
import 'Upcoming.dart';
import 'Home.dart';

class DriverStats extends StatefulWidget {
  DriverStats({Key key}) : super(key: key);

  @override
  _DriverStatsState createState() => _DriverStatsState();
}

class _DriverStatsState extends State<DriverStats> {
  int _rides;
  int _students;
  int _daysSinceJoin;
  @override
  // TODO: use proper style
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_rides rides..."),
        Text("$_students students..."),
        Text("$_daysSinceJoin days since you join Carriage app..."),
        Text("Thank you for making Cornell a better place!")
      ],
    );
  }
}

//TODO :
// class FinishedRide extends StatefulWidget {

// }

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

class RideSummary extends StatefulWidget {
  RideSummary({Key key}) : super(key: key);

  @override
  _RideSummaryState createState() => _RideSummaryState();
}

// data for a finished ride
class FinishedRide {
  String pickupName;
  String dropoffName;
  DateTime startTime;
  DateTime endTime;
  int riders;
  double miles;
}

class _RideSummaryState extends State<RideSummary> {
  String _name;
  FinishedRide _recentFinishedRide;

  @override
  void initState() {
    super.initState();
    // Fetch name of user
    _name = "Chris";
  }

// TODO: ignore recent finished ride if it was too long ago
  bool _showRecentRide() {
    return true;
  }

  Widget _recentRide() {
    if (_showRecentRide()) {
      return Column(
        children: <Widget>[
          // TODO: fix this centering for some reason
          LeftSubheading(heading: 'You just finished...'),
          // TODO switch with FinishedRide
          Center(
            child: Column(
              children: <Widget>[
                CurrentRide(),
              ],
            ),
          ),
          SizedBox(height: 16.0)
        ],
      );
    } else {
      return Empty();
    }
  }

  Widget _page(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Greeting(name: _name),
          _recentRide(),
          // TODO: maybe abstract out this upcoming ride bit since it is copypaste from Home._ridesPage
          LeftSubheading(heading: 'Upcoming Ride'),
          Center(
              child: Column(
            children: <Widget>[
              CurrentRide(),
            ],
          )),
          DriverStats()
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(body: _page(context)),
    );
  }
}
