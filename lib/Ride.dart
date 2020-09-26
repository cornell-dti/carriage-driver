import 'dart:core';
import 'package:carriage/MeasureSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'Rider.dart';

class Ride {
  final String id;
  final String type;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime endTime;
  final String riderId;
  // can be null
  final String driverId;

  Ride({
    this.id,
    this.type,
    this.startLocation,
    this.endLocation,
    this.riderId,
    this.driverId,
    this.endTime,
    this.startTime});

  factory Ride.fromJson(Map<String,dynamic> json) {
    return Ride(
      id: json['id'],
      type: json['type'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      riderId: json['riderId'],
      driverId: json['driverId'],
    );
  }
}
T getOrNull<T>(Map<String,dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if(x == null) return null;
  if(parse == null) return x;
  return parse(x);
}

class ArrowPainter extends CustomPainter {
  ArrowPainter(this.length);
  double length;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.black;
    canvas.drawLine(Offset(0, 0), Offset(length-5, 0), paint);
    paint.style = PaintingStyle.fill;
    Path trianglePath = Path();
    trianglePath.moveTo(length-5, 5);
    trianglePath.lineTo(length-5, -5);
    trianglePath.lineTo(length, 0);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RideCard extends StatefulWidget {
  RideCard(this.ride, this.pagePadding);
  final Ride ride;
  final double pagePadding;

  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  final imageRadius = 24;
  Size spacerSize;
  GlobalKey stackKey = GlobalKey();
  GlobalKey dropoffKey = GlobalKey();
  Size pickupTextSize;

  @override
  Widget build(BuildContext context) {
    Widget pickup = Expanded(
      flex: 4,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'From',
                  style: TextStyle(fontSize: 11, color: Color.fromRGBO(132, 132, 132, 0.5))
              ),
              Container(
                child: MeasureSize(
                  child: Text(
                    widget.ride.startLocation,
                    style: TextStyle(fontSize: 17),
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  onChange: (size) {
                    pickupTextSize = size;
                  },
                ),
              )
            ]
        )
    );

    Widget dropOff = Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'To',
              style: TextStyle(fontSize: 11, color: Color.fromRGBO(132, 132, 132, 0.5))
          ),
          Text(
              widget.ride.endLocation,
              key: dropoffKey,
              style: TextStyle(fontSize: 17)
          )
        ],
      ),
    );

    double getDropoffX() {
      RenderBox box = dropoffKey.currentContext.findRenderObject();
      double x = box.localToGlobal(Offset.zero).dx;
      return x;
    }

    double getDropoffY() {
      RenderBox child = dropoffKey.currentContext.findRenderObject();
      Offset childOffset = child.localToGlobal(Offset.zero);
      //convert
      RenderBox parent = stackKey.currentContext.findRenderObject();
      Offset childRelativeToParent = parent.globalToLocal(childOffset);
      return childRelativeToParent.dy;
    }

    double cardPadding = 16;
    double arrowPadding = 24;

    double calculateArrowStart() {
      return pickupTextSize.width + arrowPadding;
    }
    double calculateArrowLength() {
      double idealLength = getDropoffX() - cardPadding - widget.pagePadding - pickupTextSize.width - (arrowPadding * 2);
      return idealLength;
    }

    Widget arrow = pickupTextSize != null && spacerSize != null ?
    Positioned(
        left: calculateArrowStart(),
        top: getDropoffY(),
        child: CustomPaint(
            painter: ArrowPainter(calculateArrowLength())
        )
    ) : Container();

    Widget card = Card(
        elevation: 3.0,
        child: Padding(
          padding: EdgeInsets.only(top: 24, bottom: 24, left: cardPadding, right: cardPadding),
          child: Column(
              children: [
                Row(
                    children: [
                      Text('Pickup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      Text(DateFormat.jm().format(widget.ride.startTime), style: TextStyle(fontSize: 20))
                    ]
                ),
                SizedBox(height: 9),
                Stack(
                  key: stackKey,
                  children: [
                    arrow,
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          pickup,
                          MeasureSize(
                            child: Expanded(flex: 2, child: SizedBox()),
                            onChange: (size) {
                              setState(() {
                                spacerSize = size;
                              });
                            },
                          ),
                          dropOff
                        ]
                    ),
                  ],
                ),
                SizedBox(height: 16),
                FutureBuilder(
                    future: Rider.retrieveRider(context, widget.ride.riderId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('error when retrieving a rider for RideCard: ' + snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      Rider rider = snapshot.data;
                      return Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              //TODO: replace with rider's image
                              backgroundImage: AssetImage('assets/images/terry.jpg'),
                            ),
                            SizedBox(width: 16),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rider.firstName,
                                      style: TextStyle(
                                        fontSize: 15,
                                      )
                                  ),
                                  SizedBox(height: 4),
                                  Text(rider.accessibilityString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Color.fromRGBO(132, 132, 132, 1.0)
                                    ),
                                  )
                                ]
                            )
                          ]
                      );
                    }
                )
              ]
          ),
        )
    );

    return card;
  }
}
