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
      riderId: (json['riderID'] as List<dynamic>).cast<String>().toList(),
      driverId: (json['driverID'] as List<dynamic>)?.cast<String>()?.toList() ?? [],
      repeatsOn: getOrNull(json,'repeatsOn', parse: (e) => (e as List<dynamic>).cast<String>().toList())
    );
  }
}
T getOrNull<T>(Map<String,dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if(x == null) return null;
  if(parse == null) return x;
  return parse(x);
}