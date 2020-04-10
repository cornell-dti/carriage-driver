import 'package:flutter/material.dart';
import 'Home.dart';
import 'Ride.dart';
import 'Upcoming.dart';

class Rides extends StatefulWidget {
  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {

  List<Ride> _rides;
  Ride _currentRide = 
    new Ride(
      startTime: new DateTime(2020,11,14)
    );

  @override
  void initState() {
    super.initState();
    // TODO: placeholder data
    _rides = [
      new Ride(
        id: "1",
        startLocation: "Teagle Hall",
        endLocation: "RPCC",
        startTime: new DateTime(2020,11,14),
        endTime: new DateTime(2020,11,14),
        riderId: [ "Terry Cruz", "Chris Hansen" ],
      ),
      new Ride(
        id: "2",
        startLocation: "Balch South",
        endLocation: "Gates Hall",
        startTime: new DateTime(2020,11,14),
        endTime: new DateTime(2020,11,14),
        riderId: [ "Terry Cruz", "Chris Hansen" ],)
    ];
  }

  // TODO: replace this when name is stored somewhere
  String getNameFromSharedStateSomewhere() {
    return "Chris";
  }

  Widget _rideBuild(BuildContext context, int index) {
    return FutureRide(_rides[index]);
  }

  Widget _emptyPage(BuildContext context) {
   return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Greeting(getNameFromSharedStateSomewhere()),
        SizedBox(height: 195),
        Center (
            child: Column (
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
            )
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    
      if (_rides.length == 0) {
        return _emptyPage(context);
      }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Greeting(getNameFromSharedStateSomewhere()),
          LeftSubheading(heading: 'Upcoming Ride'),
          // TODO: remove this john
          Center(
              child: Column(
                children: <Widget>[
                  CurrentRide(_currentRide),
                ],
              )),
          SizedBox(height: 16.0),
          LeftSubheading(heading: 'Today\'s Schedule'),
          Flexible(
            child: ListView.separated(
              itemCount: _rides.length,
              itemBuilder: _rideBuild,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 5.0),
            ),
          ),
        ]);
  }
}

