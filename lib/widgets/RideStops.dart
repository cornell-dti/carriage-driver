import 'dart:math';

import 'package:flutter/material.dart';
import '../utils/MeasureSize.dart';
import '../models/Ride.dart';
import 'RideDestPickupCard.dart';

class RideStops extends StatefulWidget {
  final Ride ride;
  final bool carIcon;
  RideStops({Key key, @required this.ride, @required this.carIcon})
      : super(key: key);

  @override
  RideStopsState createState() => RideStopsState();
}

class RideStopsState extends State<RideStops> {
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    double carWidth = 34;
    double circleRadius = 12;

    Widget stopCircle =
        Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
      Container(
          width: circleRadius * 2,
          height: circleRadius * 2,
          decoration: new BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          )),
      Container(
          width: 7.5,
          height: 7.5,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ))
    ]);

    return Stack(children: [
      Container(
        width: max(carWidth, circleRadius * 2),
        height: _height,
        alignment: Alignment.topCenter,
        child: Container(
          width: 4,
          decoration: new BoxDecoration(
              color: const Color.fromRGBO(236, 235, 237, 1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
        ),
      ),
      MeasureSize(
          onChange: (size) {
            setState(() {
              _height = size.height;
            });
          },
          child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Container(
                        width: max(carWidth, circleRadius * 2),
                        child: widget.carIcon
                            ? Image.asset('assets/images/carIcon.png',
                                width: carWidth)
                            : stopCircle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RideDestPickupCard(
                              false,
                              widget.ride.startTime,
                              widget.ride.startLocation,
                              widget.ride.startAddress),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Container(
                          width: max(carWidth, circleRadius * 2),
                          child: stopCircle),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RideDestPickupCard(true, widget.ride.endTime,
                              widget.ride.endLocation, widget.ride.endAddress),
                        ),
                      ),
                    ],
                  ),
                )
              ])),
    ]);
  }
}
