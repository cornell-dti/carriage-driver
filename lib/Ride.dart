import 'dart:convert';
import 'dart:core';
import 'package:carriage/MeasureSize.dart';
import 'package:carriage/pages/BeginRidePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Rider.dart';
import 'app_config.dart';

///A ride's status.
enum RideStatus { NOT_STARTED, ON_THE_WAY, ARRIVED, PICKED_UP, COMPLETED }

///Converts [status] to a string.
String toString(RideStatus status) {
  const mapping = <RideStatus, String>{
    RideStatus.NOT_STARTED: "not_started",
    RideStatus.ON_THE_WAY: "on_the_way",
    RideStatus.ARRIVED: "arrived",
    RideStatus.PICKED_UP: "picked_up",
    RideStatus.COMPLETED: "completed",
  };
  return mapping[status];
}

///Model for a ride. Matches the schema in the backend.
class Ride {
  ///The ride's id in the backend.
  final String id;

  ///The ride type. Can only be 'active', 'past', or 'unscheduled'.
  String type;

  ///The ride status.
  RideStatus status;

  ///The starting location of the ride.
  final String startLocation;

  ///The ending location of the ride.
  final String endLocation;

  ///The starting address of the ride.
  final String startAddress;

  ///The ending address of the ride.
  final String endAddress;

  ///The start time of the ride.
  final DateTime startTime;

  ///The end time of the ride.
  final DateTime endTime;

  ///The rider associated with this ride.
  final Rider rider;

  Ride(
      {this.id,
        this.type,
        this.status,
        this.startLocation,
        this.endLocation,
        this.startAddress,
        this.endAddress,
        this.rider,
        this.endTime,
        this.startTime});

  ///Creates a ride from JSON representation.
  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      type: json['type'],
      status: getStatusEnum(json['status']),
      startLocation: json['startLocation']['name'],
      endLocation: json['endLocation']['name'],
      startAddress: json['startLocation']['address'],
      endAddress: json['endLocation']['address'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      rider: Rider.fromJson(json['rider']),
    );
  }
}

RideStatus getStatusEnum(String status) {
  switch (status) {
    case ('not_started'):
      return RideStatus.NOT_STARTED;
    case ('on_the_way'):
      return RideStatus.ON_THE_WAY;
    case ('arrived'):
      return RideStatus.ARRIVED;
    case ('picked_up'):
      return RideStatus.PICKED_UP;
    case ('completed'):
      return RideStatus.COMPLETED;
    default:
      throw Exception('Ride status is invalid');
  }
}

///Modifies the ride with [id] to have status [status].
Future<http.Response> updateRideStatus(
    BuildContext context, String id, RideStatus status) async {
  final body = jsonEncode(<String, String>{"status": toString(status)});
  return http.put(AppConfig.of(context).baseUrl + '/rides/$id',
      body: body,
      headers: <String, String>{"Content-Type": "application/json"});
}

Future<http.Response> setRideToPast(
    BuildContext context, String id) async {
  final body = jsonEncode(<String, String>{"type": "past"});
  return http.put(AppConfig.of(context).baseUrl + '/rides/$id',
      body: body,
      headers: <String, String>{"Content-Type": "application/json"});
}

T getOrNull<T>(Map<String, dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if (x == null) return null;
  if (parse == null) return x;
  return parse(x);
}


BoxShadow dropShadow = BoxShadow(
    blurRadius: 2,
    spreadRadius: 0,
    color: Colors.black.withOpacity(0.25)
);

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

  Widget actionButton(IconData icon, Function action) {
    return GestureDetector(
      onTap: action,
      child: Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                dropShadow
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(icon, size: 20, color: Colors.black),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>
                  BeginRidePage(widget.ride))
          );
        },
        child: Card(
            elevation: 3.0,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                dropShadow
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              //TODO: replace with rider's image
                              backgroundImage: AssetImage(
                                  'assets/images/terry.jpg'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.ride.rider.firstName + ' ' +
                                    widget.ride.rider.lastName.substring(
                                        0, 1) + '.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                SizedBox(height: 4),
                                Text(
                                    widget.ride.rider.accessibilityNeeds.join(
                                        ', '),
                                    style: TextStyle(
                                        color: Color(0xFF848484),
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15)
                                )
                              ]
                          ),
                          Spacer(),
                          actionButton(Icons.phone, () {}),
                          SizedBox(width: 8),
                          actionButton(Icons.notifications, () {})
                        ]
                    ),
                    SizedBox(height: 32),
                    TimeLine(widget.ride)
                  ]
              ),
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
    Color grey = Color(0xFF9B9B9B);
    return Container(
      width: size,
      height: size,
      child: Icon(Icons.circle, size: 9.75, color: grey),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            dropShadow
          ]
      ),
    );
  }


  Widget locationInfo(bool isPickup, DateTime time, String location) {

    TextStyle directionStyle = TextStyle(
        color: Color(0xFFA7A7A7),
        fontSize: 11,
        fontWeight: FontWeight.bold
    );

    TextStyle locationStyle = TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.normal
    );

    TextStyle timeStyle = locationStyle.copyWith(fontWeight: FontWeight.bold);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isPickup ? 'Pickup' : 'Dropoff', style: directionStyle),
          SizedBox(height: 2),
          RichText(
            text: TextSpan(
                text: DateFormat('jm').format(time),
                style: timeStyle,
                children: [
                  TextSpan(
                      text: ' @ $location',
                      style: locationStyle)
                ]
            ),
          )
        ]
    );
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
      return timelineHeight != null && firstRowKey.currentContext != null &&
          lastRowKey.currentContext != null ? Container(
        margin: EdgeInsets.only(left: size / 2 - (lineWidth / 2)),
        width: 4,
        height: getLastRowPos() - getFirstRowPos(),
        color: Color(0xFFECEBED),
      ) : CircularProgressIndicator();
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
          child: Column(
              children: [
                Container(
                    key: firstRowKey,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          locationCircle(),
                          SizedBox(width: 16),
                          locationInfo(true, widget.ride.startTime, widget.ride.startLocation)
                        ]
                    )
                ),
                SizedBox(height: 24),
                Container(
                    key: lastRowKey,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          locationCircle(),
                          SizedBox(width: 16),
                          locationInfo(false, widget.ride.endTime, widget.ride.endLocation)
                        ]
                    )
                ),
              ]
          ),
        ),
      ],
    );
  }
}