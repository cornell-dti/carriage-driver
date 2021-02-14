import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/MeasureSize.dart';
import '../models/Ride.dart';
import 'RideDestPickupCard.dart';

class RideStops extends StatefulWidget {
  final Ride ride;
  final bool carIcon;
  final bool largeSpacing;
  RideStops({Key key, @required this.ride, @required this.carIcon, @required this.largeSpacing}) : super(key: key);

  @override
  RideStopsState createState() => RideStopsState();
}

class RideStopsState extends State<RideStops> {
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    double circleRadius = 13;

    Widget stopCircle = Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
              width: circleRadius * 2,
              height: 26,
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              )),
          Container(
              width: 8,
              height: 8,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ))
        ]);

    return Stack(children: [
      Container(
        width: circleRadius * 2,
        height: _height,
        alignment: Alignment.topCenter,
        child: Container(
          width: 4,
          decoration: new BoxDecoration(
              color: const Color.fromRGBO(236, 235, 237, 1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
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
                      Container(width: 26, child: widget.carIcon ? SvgPicture.asset('assets/images/carIcon.svg') : stopCircle),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RideDestPickupCard(false, widget.ride.startTime,
                              widget.ride.startLocation, widget.ride.startAddress),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: widget.largeSpacing ? 80 : 32),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Container(width: 26, child: stopCircle),
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
              ]
          )
      ),
    ]);
  }
}

