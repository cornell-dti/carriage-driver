import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 24.0,
                top: 18.0 + MediaQuery.of(context).padding.top,
                bottom: 16.0
            ),
            child: Text(
                'Your Profile',
                style: Theme.of(context).textTheme.headline
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(15, 0, 0, 0),
                      offset: Offset(0, 4.0),
                      blurRadius: 10.0,
                      spreadRadius: 1.0
                  )
                ],
              ),
              child: Row(
                  children: [
                    Padding (
                        padding: EdgeInsets.only(left: _picMarginLR, right: _picMarginLR, top: _picMarginTB, bottom: _picMarginTB),
                        child: Stack (
                          children: [
                            Padding (
                                padding: EdgeInsets.only(bottom: _picDiameter * 0.05),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/terry.jpg'),
                                  radius: _picRadius,
                                )
                            ),

                            Positioned(
                              child: Container (
                                height: _picBtnDiameter,
                                width: _picBtnDiameter,
                                child: FittedBox (
                                  child: FloatingActionButton (
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                        Icons.add,
                                        size: _picBtnDiameter
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              left: _picDiameter * 0.61,
                              top: _picDiameter * 0.66
                            )
                          ],
                        )
                    ),
                    Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              children: [
                                Text("Terry Cruz", style: Theme.of(context).textTheme.subhead),
                                Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                    )
                                )
                              ]
                          ),
                          SizedBox(height: 4),
                          Text("Joined 03/2020", style: Theme.of(context).textTheme.display2)
                        ]
                    )
                  ]
              )
          )
        ]
    );
  }
}