import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Upcoming.dart';
import 'Map.dart';

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
            Text('$heading', style: TextStyle(
              fontSize: 20,
              color: Colors.grey
            )),
            Text('$destination', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ))
          ],
        ),
      ],
    );
  }
}

class Home extends StatelessWidget {
  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SlidingUpPanel(
            minHeight: 62.0,
            panelSnapping: false,
            panel: Upcoming(),
            body: Scaffold(
                body: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    child: Text('Hi Nick', style: TextStyle(fontSize: 40)),
                    padding:
                        EdgeInsets.only(left: 30.0, top: 50.0, bottom: 10.0),
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0, bottom: 10.0),
                      child: Text('Upcoming Rides',
                          style: TextStyle(fontSize: 20.0)),
                    )),
                Center(
                  child: Container(
                    width: 350.0,
                    height: 200.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
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
                              flex: 2,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.0, top: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Oct 13',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.0, top: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('1:00 PM',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
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
                  ),
                ),
              ],
            )),
            borderRadius: radius),
      ),
    );
  }
}
