import 'dart:core';

class Ride {
  final String id;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime endTime;
  final bool isScheduled;
  final List<String> riderId;
  // can be null
  final List<String> driverId;
  // can be null
  final List<String> repeatsOn;

  Ride({
    this.id,
    this.startLocation,
    this.endLocation,
    this.isScheduled,
    this.riderId,
    this.driverId,
    this.endTime,
    this.repeatsOn,
    this.startTime});

  factory Ride.fromJson(Map<String,dynamic> json) {
    return Ride(
      id: json['id'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      isScheduled: json['isScheduled'],
      riderId: json['riderId'],
      driverId: getOrNull(json,'driverId'),
      repeatsOn: getOrNull(json,'repeatsOn')
    );
  }

  // TODO: hi chris where do i move this to
  static dynamic getOrNull(Map<String,dynamic> map, String key) {
    return map.containsKey(key) ? map[key] : null;
  }

}