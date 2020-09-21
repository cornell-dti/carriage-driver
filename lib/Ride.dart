import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widget_arrows/widget_arrows.dart';

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
      riderId: json['riderID'],
      driverId: json['driverID'],
    );
  }
}
T getOrNull<T>(Map<String,dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if(x == null) return null;
  if(parse == null) return x;
  return parse(x);
}

class RideCard extends StatefulWidget {
  RideCard(this.ride);
  final Ride ride;
  static const double imageRadius = 24;
  @override
  RideCardState createState() => RideCardState();
}

class RideCardState extends State<RideCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        child: Padding(
          padding: EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16),
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
                ArrowContainer(
                  child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ArrowElement(
                            show: false,
                            color: Colors.black,
                            id: 'pickup',
                            targetId: 'dropoff',
                            sourceAnchor: Alignment.centerRight,
                            targetAnchor: Alignment.centerLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'From',
                                      style: TextStyle(fontSize: 11, color: Color.fromRGBO(132, 132, 132, 0.5))
                                  ),
                                  Text(
                                      widget.ride.startLocation,
                                      style: TextStyle(fontSize: 17)
                                  )
                                ]
                            ),
                          ),
                        ),
                        ArrowElement(
                          id: 'dropoff',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'To',
                                  style: TextStyle(fontSize: 11, color: Color.fromRGBO(132, 132, 132, 0.5))
                              ),
                              Text(
                                  widget.ride.endLocation,
                                  style: TextStyle(fontSize: 17)
                              )
                            ],
                          ),
                        )
                      ]
                  ),
                ),
                SizedBox(height: 16),
                Row(
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
                            //TODO: replace with rider's name
                            Text('Terry Cruz',
                                style: TextStyle(
                                  fontSize: 15,
                                )
                            ),
                            SizedBox(height: 4),
                            //TODO: replace with rider's accessibility needs
                            Text('Wheelchair',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromRGBO(132, 132, 132, 1.0)
                              ),
                            )
                          ]
                      )
                    ]
                )
              ]
          ),
        )
    );
  }
}