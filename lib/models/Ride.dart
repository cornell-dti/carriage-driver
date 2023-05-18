import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import 'Rider.dart';
import '../utils/app_config.dart';

///A ride's status.
enum RideStatus {
  NOT_STARTED,
  ON_THE_WAY,
  ARRIVED,
  PICKED_UP,
  COMPLETED,
  NO_SHOW
}

///Converts [status] to a string.
String toString(RideStatus status) {
  const mapping = <RideStatus, String>{
    RideStatus.NOT_STARTED: "not_started",
    RideStatus.ON_THE_WAY: "on_the_way",
    RideStatus.ARRIVED: "arrived",
    RideStatus.PICKED_UP: "picked_up",
    RideStatus.COMPLETED: "completed",
    RideStatus.NO_SHOW: "no_show",
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
    final data = json['data'] ?? json;
    print("................ride....................");
    print(data);
    return Ride(
      id: data['id'],
      type: data['type'],
      status: getStatusEnum(data['status']),
      startLocation: data['startLocation']['name'],
      endLocation: data['endLocation']['name'],
      startAddress: data['startLocation']['address'],
      endAddress: data['endLocation']['address'],
      startTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(data['startTime'], true)
          .toLocal(),
      endTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(data['endTime'], true)
          .toLocal(),
      rider: Rider.fromJson(data['rider']),
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
    case ('no_show'):
      return RideStatus.NO_SHOW;
    default:
      throw Exception('Ride status is invalid');
  }
}

///Modifies the ride with [id] to have status [status].
Future<http.Response> notifyDelay(BuildContext context, String id) async {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  String token = await authProvider.secureStorage.read(key: 'token');
  final body = jsonEncode(<String, bool>{'late': true});
  return http.put(Uri.parse(AppConfig.of(context).baseUrl + '/rides/$id'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      });
}

///Modifies the ride with [id] to have status [status].
Future<http.Response> updateRideStatus(
    BuildContext context, String id, RideStatus status) async {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  String token = await authProvider.secureStorage.read(key: 'token');
  final body = jsonEncode(<String, String>{"status": toString(status)});
  return http.put(Uri.parse(AppConfig.of(context).baseUrl + '/rides/$id'),
      body: body,
      headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
}

Future<http.Response> setRideToPast(BuildContext context, String id) async {
  final body = jsonEncode(<String, String>{"type": "past"});
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  String token = await authProvider.secureStorage.read(key: 'token');
  return http.put(Uri.parse(AppConfig.of(context).baseUrl + '/rides/$id'),
      body: body,
      headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
}

T getOrNull<T>(Map<String, dynamic> map, String key,
    {T Function(dynamic s) parse}) {
  var x = map.containsKey(key) ? map[key] : null;
  if (x == null) return null;
  if (parse == null) return x;
  return parse(x);
}
