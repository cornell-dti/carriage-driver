import 'package:flutter/material.dart';

class Rider extends StatefulWidget {
  Rider({Key key}) : super(key: key);

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
    _riderName = "Terry Crews";
    _injury = "Big Arms";
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
              Text('$_injury',
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
  Location({this.heading, this.destination});

  final String heading;
  final String destination;

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
            Text('$destination',
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
  String date;

  Date({@required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: 12.0),
      child: Text('$date',
          style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).accentColor,
              letterSpacing: -0.41)),
    );
  }
}

class Time extends StatelessWidget {
  String time;

  Time({@required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: 12.0),
      child: Text('$time',
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 0.37)),
    );
  }
}

class Summary extends StatelessWidget {
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

class UpcomingRide extends StatefulWidget {
  UpcomingRide({Key key, DateTime startTime}) : super(key: key);

  @override
  _UpcomingRideState createState() => _UpcomingRideState();
}

class _UpcomingRideState extends State<UpcomingRide> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 48;
    return Container(
      width: width,
      height: width / 2,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Summary();
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  offset: Offset(0, 4.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0)
            ],
          ),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 181,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Date(date: 'Oct 30'),
                      Time(time: '10:12'),
                      Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 10.0),
                          child: Rider())
                    ],
                  ),
                ),
                Expanded(
                  flex: 146,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Location(heading: 'Pick up', destination: 'PSB'),
                          SizedBox(height: 12.0),
                          Location(
                              heading: 'Drop off', destination: 'Cascadilla')
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
