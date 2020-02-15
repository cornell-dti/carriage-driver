import 'dart:core';
import 'package:flutter/material.dart';
import 'Map.dart';

class Rider extends StatefulWidget {
  Rider({Key key, @required this.name}) : super(key: key);

  final String name;

  @override
  _RiderState createState() => _RiderState();
}

class _RiderState extends State<Rider> {
  String _riderName;
  String _injury;

  @override
  void initState() {
    super.initState();
    // Fetch the Rider and their Injury from API
    _riderName = widget.name;
    _injury = "Wheelchair";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/terry.jpg'),
            radius: 25,
          ),
          SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$_riderName',
                  style: TextStyle(fontSize: 12, letterSpacing: 0.23)),
              Text('Needs: $_injury',
                  style: TextStyle(
                      color: Color.fromRGBO(142, 142, 147, 1),
                      fontSize: 10,
                      letterSpacing: 0.19))
            ],
          )
        ],
      ),
    );
  }
}

class Location extends StatefulWidget {
  Location({Key key, @required this.heading, @required this.location})
      : super(key: key);

  final String heading;
  final String location;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String _location;

  @override
  void initState() {
    super.initState();
    // Fetch Pickup or Drop off Location
    _location = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${widget.heading}',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).accentColor,
                    letterSpacing: 0)),
            SizedBox(height: 4),
            Text('$_location',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.41))
          ],
        ),
      ],
    );
  }
}

class Date extends StatefulWidget {
  Date({Key key}) : super(key: key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  String _date;

  @override
  void initState() {
    super.initState();
    // Fetch date
    _date = "Nov 12";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: 12.0),
      child: Text('$_date',
          style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).accentColor,
              letterSpacing: -0.41)),
    );
  }
}

class Time extends StatefulWidget {
  Time({Key key}) : super(key: key);

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  String _time;

  @override
  void initState() {
    super.initState();
    // Fetch start time
    _time = "10:12";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: 12.0),
      child: Text('$_time',
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 0.37)),
    );
  }
}

class Summary extends StatefulWidget {
  Summary({Key key}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 50.0, bottom: 10.0),
            child: Text('Ride Summary',
                style: Theme.of(context).textTheme.headline),
          )
        ],
      ),
    );
  }
}

class CurrentRide extends StatefulWidget {
  CurrentRide({Key key, DateTime startTime}) : super(key: key);

  @override
  _CurrentRideState createState() => _CurrentRideState();
}

class _CurrentRideState extends State<CurrentRide> {
  bool _starting = false;
  List<List<String>> _riders = [
    ['Terry Cruz', 'Pick up', 'Cascadilla'],
    ['Chris Hansen', 'Drop off', 'Rhodes']
  ];

  @override
  void initState() {
    super.initState();
    // Will need to fetch data here
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width - 48;

    double btnWidth = 0.48 * MediaQuery.of(context).size.width;
    double btnHeight = 0.059 * MediaQuery.of(context).size.height;
    double btnPadding = 24;

    return Container(
      constraints: BoxConstraints(maxWidth: _width, minHeight: _width / 2),
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Date(),
                Time(),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _riders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Rider(name: _riders[index][0]),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Location(
                                      heading: _riders[index][1],
                                      location: _riders[index][2]),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                Visibility(
                  visible: _starting,
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: btnPadding, bottom: btnPadding),
                      child: ButtonTheme(
                        minWidth: btnWidth,
                        height: btnHeight,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return Map();
                            }));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          color: Theme.of(context).accentColor,
                          child: Text('START',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class UpcomingRide extends StatefulWidget {
  UpcomingRide({Key key, DateTime startTime}) : super(key: key);

  @override
  _UpcomingRideState createState() => _UpcomingRideState();
}

class _UpcomingRideState extends State<UpcomingRide> {
  List<String> _riders;
  List<String> _destinations;

  @override
  void initState() {
    super.initState();
    // Fetch Upcoming Information
    _riders = [
      'assets/images/terry.jpg',
      'assets/images/terry.jpg',
      'assets/images/terry.jpg'
    ];
    _destinations = [
      "Fgafd",
      "Morrison",
      "PSB",
      "Gates",
      "Cascadilla",
      "Rockefeller",
      "gfa",
      "hfa"
    ];
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
          child: Column(children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 181,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Date(),
                      Time(),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 24.0, top: 12.0, right: 24.0, bottom: 12.0),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                List.generate(_riders.length, (int index) {
                              return CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(_riders[index]),
                              );
                            }),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 146,
                  child: Column(
                    children: <Widget>[
                      Route(destinations: _destinations),
                      SizedBox(height: 24)
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class Route extends StatefulWidget {
  const Route({Key key, @required this.destinations})
      : assert(destinations != null),
        super(key: key);

  final List<String> destinations;

  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<Route> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return index == widget.destinations.length - 1;
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 10.0,
      color: Colors.black,
    );
  }

  Widget _buildVerticalHeader(BuildContext context, int index) {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildLine(!_isFirst(index)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: Colors.black),
              ),
              _buildLine(!_isLast(index)),
            ],
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 10.0),
            child: Text(widget.destinations[index],
                style: Theme.of(context).textTheme.display1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.destinations.length,
      itemBuilder: _buildVerticalHeader,
    );
  }
}
