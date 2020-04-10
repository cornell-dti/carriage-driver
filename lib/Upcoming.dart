import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Map.dart';
import 'Ride.dart';

class Rider extends StatelessWidget {
  Rider(this.riderName, {Key key, this.injury}) : super(key: key);

  final String riderName;
  final String injury;

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
              Text('$riderName',
                  style: TextStyle(fontSize: 12, letterSpacing: 0.23)),
              // TODO: check if we can update sdk version for this
              if (injury != null)
                Text('Needs: $injury',
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

class Location extends StatelessWidget {
  final String heading;
  final String location;

  Location(this.heading, this.location, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$heading',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).accentColor,
                    letterSpacing: 0)),
            SizedBox(height: 4),
            Text('$location',
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

class Date extends StatelessWidget {
  Date(this.date, {Key key}) : super(key: key);

  final DateTime date;

  final DateFormat format = new DateFormat('MMM d');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: 12.0),
      child: Text(format.format(date),
          style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).accentColor,
              letterSpacing: -0.41)),
    );
  }
}

class Time extends StatelessWidget {
  Time(this.time, {Key key}) : super(key: key);

  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: 12.0),
      child: Text(localizations.formatTimeOfDay(time),
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 0.37)),
    );
  }
}

// TODO make stateful again
class Summary extends StatelessWidget {
  Summary({Key key}) : super(key: key);

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
  CurrentRide(Ride ride, {Key key})
      : date = ride.startTime,
        super(key: key);

  final DateTime date;
  // TODO: placeholder values
  final List<List<String>> riders = [
    ['Terry Cruz', 'Pick up', 'Cascadilla'],
    ['Chris Hansen', 'Drop off', 'Rhodes']
  ];

  @override
  _CurrentRideState createState() => _CurrentRideState();
}

class _CurrentRideState extends State<CurrentRide> {
  bool _starting = false;
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
                Date(widget.date),
                Time(TimeOfDay.fromDateTime(widget.date)),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.riders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Rider(widget.riders[index][0]),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Location(widget.riders[index][1],
                                      widget.riders[index][2]),
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

class FutureRide extends StatelessWidget {
  FutureRide(Ride ride, {Key key})
      : date = ride.startTime,
        time = TimeOfDay.fromDateTime(ride.startTime),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;

  // TODO: placeholder
  List<String> somehowGetRiderImages() {
    return ['assets/images/terry.jpg', 'assets/images/terry.jpg'];
  }

  // TODO: placeholder
  List<String> somehowGetDestinations() {
    return ["Fgafd", "Morrison", "PSB", "Gates"];
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width - 48;

    var _riderImgs = somehowGetRiderImages();
    var _destinations = somehowGetDestinations();

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
                      Date(date),
                      Time(time),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 24.0, top: 12.0, right: 24.0, bottom: 12.0),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                List.generate(_riderImgs.length, (int index) {
                              return CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(_riderImgs[index]),
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

class Route extends StatelessWidget {
  const Route({Key key, @required this.destinations})
      : assert(destinations != null),
        super(key: key);

  final List<String> destinations;

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return index == destinations.length - 1;
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
            child: Text(destinations[index],
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
      itemCount: destinations.length,
      itemBuilder: _buildVerticalHeader,
    );
  }
}
