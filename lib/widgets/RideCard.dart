import 'dart:core';
import '../utils/MeasureSize.dart';
import '../pages/ride-flow/BeginRidePage.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../utils/CarriageTheme.dart';
import '../models/Ride.dart';

class RideCard extends StatefulWidget {
  RideCard(this.ride);
  final Ride ride;

  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  final imageRadius = 24;
  GlobalKey stackKey = GlobalKey();
  GlobalKey dropoffKey = GlobalKey();
  double textWidth = 0;
  double buttonsWidth;

  @override
  Widget build(BuildContext context) {
    double padding = 24;
    double margin = 16;
    double profilePictureSize = 48;
    double picNameSpacing = 16;
    double nameButtonSpacing = 16;

    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  BeginRidePage(ride: widget.ride)));
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [CarriageTheme.shadow],
                borderRadius: BorderRadius.circular(12)),
            child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BeginRidePage(ride: widget.ride)));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  widget.ride.rider.profilePicture(profilePictureSize),
                                  SizedBox(width: picNameSpacing),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: textWidth,
                                          child: FittedBox(
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.scaleDown,
                                            child: Text(widget.ride.rider.firstName,
                                                style: CarriageTheme.title3),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        widget.ride.rider.accessibilityNeeds.length > 0 && textWidth > 0 ?
                                        Container(
                                          width: textWidth,
                                          child: Text(
                                              widget.ride.rider.accessibilityNeeds
                                                  .join(', '),
                                              style: TextStyle(
                                                  color: CarriageTheme.gray2,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 15)
                                          ),
                                        ) : Container()
                                      ]
                                  ),
                                  SizedBox(width: nameButtonSpacing),
                                  textWidth == 0 || widget.ride.rider.accessibilityNeeds.length == 0 ? Spacer() : Container(),
                                  MeasureSize(
                                    onChange: (size) {
                                      setState(() {
                                        buttonsWidth = size.width;
                                        textWidth = MediaQuery.of(context).size.width - (2*margin) - (2*padding) - buttonsWidth - profilePictureSize - picNameSpacing - nameButtonSpacing;
                                      });
                                    },
                                    child: Row(
                                        children: [
                                          CallButton(widget.ride.rider.phoneNumber, 48),
                                          SizedBox(width: 8),
                                          NotifyButton(widget.ride, 48)
                                        ]
                                    ),
                                  )
                                ]
                            ),
                            SizedBox(height: 32),
                            TimeLine(widget.ride)
                          ]
                      ),
                    )
                )
            )
        )
    );

  }
}

class TimeLine extends StatefulWidget {
  TimeLine(this.ride);
  final Ride ride;

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  double size = 26;
  double timelineHeight;
  Widget line;

  Widget locationCircle() {
    Color grey = Color.fromRGBO(155, 155, 155, 1);
    return Container(
      width: size,
      height: size,
      child: Icon(Icons.circle, size: 9.75, color: grey),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [CarriageTheme.shadow]),
    );
  }

  Widget locationInfo(bool isPickup, DateTime time, String location) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isPickup ? 'Pickup' : 'Dropoff',
          style: CarriageTheme.caption1.copyWith(color: CarriageTheme.gray3)),
      SizedBox(height: 2),
      Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                  text: DateFormat('jm').format(time),
                  style: CarriageTheme.body.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(text: ' @ $location', style: CarriageTheme.body)
                  ]),
            ),
          ),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double lineWidth = 4;
    GlobalKey firstRowKey = GlobalKey();
    GlobalKey lastRowKey = GlobalKey();

    double getFirstRowPos() {
      RenderBox firstRowBox = firstRowKey.currentContext.findRenderObject();
      return firstRowBox.localToGlobal(Offset.zero).dy;
    }

    double getLastRowPos() {
      RenderBox lastRowBox = lastRowKey.currentContext.findRenderObject();
      return lastRowBox.localToGlobal(Offset.zero).dy + lastRowBox.size.height;
    }

    Widget buildLine() {
      return timelineHeight != null &&
          firstRowKey.currentContext != null &&
          lastRowKey.currentContext != null
          ? Container(
        margin: EdgeInsets.only(left: size / 2 - (lineWidth / 2)),
        width: 4,
        height: getLastRowPos() - getFirstRowPos(),
        color: Color(0xFFECEBED),
      )
          : CircularProgressIndicator();
    }

    return Stack(
      children: <Widget>[
        line == null ? CircularProgressIndicator() : line,
        MeasureSize(
          onChange: (size) {
            setState(() {
              timelineHeight = size.height;
              line = buildLine();
            });
          },
          child: Column(children: [
            Container(
                key: firstRowKey,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      locationCircle(),
                      SizedBox(width: 16),
                      Expanded(
                          child: locationInfo(true, widget.ride.startTime,
                              widget.ride.startLocation))
                    ])),
            SizedBox(height: 24),
            Container(
                key: lastRowKey,
                child:
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  locationCircle(),
                  SizedBox(width: 16),
                  Expanded(
                      child: locationInfo(
                          false, widget.ride.endTime, widget.ride.endLocation))
                ])),
          ]),
        ),
      ],
    );
  }
}
