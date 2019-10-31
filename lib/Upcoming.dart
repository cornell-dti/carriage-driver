import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _size = 50.0;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/images/terry.jpg'))),
    );
  }
}

class Rider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          CircleImage(),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Terry Cruz', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Big Arms', style: TextStyle(color: Colors.grey))
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
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('$destination',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
      padding: EdgeInsets.only(left: 20.0, top: 20.0),
      child: Text('$date', style: TextStyle(fontSize: 20, color: Colors.grey)),
    );
  }
}

class Time extends StatelessWidget {
  String time;

  Time({@required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 5.0),
      child: Text('$time',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}

class NextRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      height: 170.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(5.0, 10.0),
                blurRadius: 5.0,
                spreadRadius: 0.0)
          ],
        ),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Date(date: 'Oct 30'),
                    Time(time: '10:12 PM'),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Rider())
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          Location(heading: 'From', destination: 'PSB'),
                          SizedBox(height: 16.0),
                          Location(heading: 'To', destination: 'Cascadilla')
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
