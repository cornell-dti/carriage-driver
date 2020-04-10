import 'package:flutter/material.dart';
import 'Ride.dart';
import 'Upcoming.dart';
import 'Home.dart';
import 'package:intl/intl.dart';

class StatText extends StatelessWidget {
  final String text;
  StatText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Opacity(
            opacity: 0.6,
            child: Text('$text', style: Theme.of(context).textTheme.caption)));
  }
}

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
  void initState() {
    super.initState();
    // TODO: fetch real data, this is placeholder
    _rides = 420;
    _students = 692;
    _daysSinceJoin = 60;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StatText(text: "$_rides rides..."),
        StatText(text: "$_students students..."),
        StatText(text: "$_daysSinceJoin days since you join Carriage app..."),
        StatText(text: "Thank you for making Cornell a better place!")
      ],
    );
  }
}

// TODO: actually show map preview, this is placeholder
class MapPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 400.0,
      height: 164.0,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}

class FinishedRide extends StatefulWidget {
  FinishedRide({Key key, DateTime startTime}) : super(key: key);

  @override
  _FinishedRideState createState() => _FinishedRideState();
}

class _FinishedRideState extends State<FinishedRide> {
  List<String> _riders;
  String _startDest;
  String _endDest;
  DateTime _startTime;
  DateTime _endTime;
  double _distance;

  @override
  void initState() {
    super.initState();
    // TODO: fetch real data, this is placeholder
    _riders = [
      'assets/images/terry.jpg',
      'assets/images/terry.jpg',
      'assets/images/terry.jpg'
    ];
    _startDest = "414 Stewart Ave";
    _endDest = "Kennedy Hall";
    var now = DateTime.now();
    _startTime = DateTime(now.year, now.month, now.day, 13);
    _endTime = DateTime(now.year, now.month, now.day, 13, 10);
    _distance = 0.9;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width - 48;
    return Container(
      constraints: BoxConstraints(
          minWidth: _width, maxWidth: _width, minHeight: _width / 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Summary();
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  offset: Offset(0, 4.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
            child: Column(children: <Widget>[
              Text("$_startDest - $_endDest",
                  style: Theme.of(context).textTheme.subhead),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${DateFormat.jm().format(_startTime)} - ${DateFormat.jm().format(_endTime)}",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontSize: 12)),
                        Divider(
                          height: 8.0,
                          thickness: 0.0,
                          color: Color(0),
                        ),
                        Text(
                            "$_distance mile${_distance != 1 ? "s" : ""}, ${_riders.length} rider${_riders.length > 0 ? "s" : ""}",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontSize: 12))
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(_riders.length, (int index) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(_riders[index]),
                          );
                        }),
                      ))
                ],
              ),
              MapPreview()
            ]),
          ),
        ),
      ),
    );
  }
}

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

class _RideSummaryState extends State<RideSummary> {
  String _name;
  Ride _currentRide;

  @override
  void initState() {
    super.initState();
    // TODO: placeholder
    _name = "Chris";
    _currentRide = new Ride(
        id: "1",
        startLocation: "Teagle Hall",
        endLocation: "RPCC",
        startTime: new DateTime(2020,11,14),
        endTime: new DateTime(2020,11,14),
        riderId: [ "Terry Cruz", "Chris Hansen" ],
      );
  }

// TODO: ignore recent finished ride if it was too long ago
  bool _showRecentRide() {
    return true;
  }

  Widget _recentRide() {
    if (_showRecentRide()) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LeftSubheading(heading: 'You just finished...'),
          Center(
            child: Column(
              children: <Widget>[
                FinishedRide(),
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
          Greeting(_name),
          Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
            _recentRide(),
            LeftSubheading(heading: 'Upcoming Ride'),
            Center(child: CurrentRide(_currentRide)),
            Padding(
                padding: EdgeInsets.only(top: 36.0, bottom: 24.0),
                child: DriverStats())
          ]))
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
