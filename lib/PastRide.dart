import 'dart:core';

class Ride {
  final String id;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime endTime;
  final String riderId;
  // can be null
  final String driverId;

  Ride({
    this.id,
    this.startLocation,
    this.endLocation,
    this.riderId,
    this.driverId,
    this.endTime,
    this.startTime});

  factory Ride.fromJson(Map<String,dynamic> json) {
    return Ride(
      id: json['id'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      riderId: json['riderID'],
      driverId: json['driverID']
    );
  }

  factory Ride.fromActive(Ride ride) {
    return Ride(
      id: ride.id,
      startLocation: ride.startLocation,
      endLocation: ride.endLocation,
      startTime: ride.startTime,
      endTime: ride.endTime,
      riderId: ride.riderId
    );
  }
}