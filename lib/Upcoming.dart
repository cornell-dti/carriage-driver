import 'package:flutter/material.dart';

List<String> cur = ["Sabriyah", "11am", "Cascadilla", "PSB"];
List<String> upcoming = [
  "Chris @ 12pm",
  "Laura @ 3pm",
  "Sam @ 4:30pm",
  "David @ 5pm",
  "Swasti @ 7am tomorrow",
  "Paulie @ 8am tomorrow",
  "Lisa @ 9am tomorrow"
];

class CurrentRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150.0,
        child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('${cur[0]} @ ${cur[1]}',
                      style: Theme.of(context).textTheme.headline),
                  Text('From ${cur[2]}',
                      style: Theme.of(context).textTheme.headline),
                  Text('To ${cur[3]}',
                      style: Theme.of(context).textTheme.headline),
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Arrived'),
                        color: Colors.white,
                        onPressed: () {

                        },
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        child: Icon(Icons.call, color: Colors.green),
                        color: Colors.white,
                        onPressed: () {

                        },
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        child: Icon(Icons.message, color: Colors.black),
                        color: Colors.white,
                        onPressed: () {

                        },
                      )
                    ],
                  ),

                ])));
  }
}

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: upcoming.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${upcoming[index]}'),
          );
        });
  }
}

class Upcoming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
                height: 5.0, width: 70.0, child: Container(color: Colors.grey)),
          ),
          SizedBox(height: 10.0),
          Text('Your Rides', style: Theme.of(context).textTheme.headline),
          CurrentRide(),
          Flexible(child: Schedule())
        ],
      ),
    );
  }
}
