import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> upcoming = [
  "Chris @ 12pm",
  "Laura @ 3pm",
  "Sam @ 4:30pm",
  "David @ 5pm",
  "Swasti @ 7am tomorrow",
  "Paulie @ 8am tomorrow",
  "Lisa @ 9am tomorrow"
];
int eta = 13;

class _CurrentRideState extends State<CurrentRide> {
  List<String> cur = [
    "Sabriyah",
    "11am",
    "Cascadilla",
    "PSB",
    "+1 123 456 7890"
  ];
  bool _inProgress = false;
  bool _messaging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _messaging ? 200.0 : 150.0,
        child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('${cur[0]} ${_inProgress ? '' : '@ ${cur[1]}'}',
                      style: Theme.of(context).textTheme.headline),
                  Text(_inProgress ? 'ETA $eta minutes' : 'From ${cur[2]}',
                      style: Theme.of(context).textTheme.headline),
                  Text('To ${cur[3]}',
                      style: Theme.of(context).textTheme.headline),
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Text(_inProgress ? 'Here' : 'Arrived'),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _inProgress = true;
                          });
                        },
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        child: Icon(Icons.call, color: Colors.green),
                        color: Colors.white,
                        onPressed: () {
                          launch("tel:${cur[4]}");
                        },
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        child: Icon(Icons.message, color: Colors.black),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _messaging = !_messaging;
                          });
                        },
                      )
                    ],
                  ),
                  Visibility(
                    visible: _messaging,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          ActionChip(
                            label: Text('Where are you?'),
                            onPressed: () {
                              launch('sms:${cur[4]}?body=Where are you%3F');
                            },
                          ),
                          SizedBox(width: 5.0),
                          ActionChip(
                            label: Text('Let me pull around.'),
                            onPressed: () {
                              launch('sms:${cur[4]}?body=Let me pull around.');
                            },
                          ),
                          SizedBox(width: 5.0),
                          ActionChip(
                            label: Text('Be there soon!'),
                            onPressed: (){
                              launch('sms:${cur[4]}?body=Be there soon%21');
                            },
                          ),
                          SizedBox(width: 10.0)
                        ],
                      ),
                    ),
                  )
                ])));
  }
}

class CurrentRide extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrentRideState();
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
