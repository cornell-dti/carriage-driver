import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Home.dart';
import 'Ride.dart';
import 'Upcoming.dart';
import 'package:http/http.dart' as http;
import 'app_config.dart';

// Data for Rides page
class _RideData {
  List<Ride> rides;
  Ride currentRide;
  _RideData(this.rides, this.currentRide);
}

class Rides extends StatefulWidget {
  // TODO: placeholder
  final String driverId = "test";

  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  Future<_RideData> rideData;

  @override
  void initState() {
    super.initState();
    rideData = _fetchRides();
  }

  Future<_RideData> _fetchRides() async {
    // TODO: temporary placeholder response for testing
    // replace when backend sends all fields
    String responseBody = '''
{
  "data": [
    {
        "id": "6c5e8b60-819f-11ea-8b9d-c3580ef31720",
        "isScheduled": false,
        "startLocation": "Cascadilla",
        "endLocation": "Rhodes",
        "startTime": "2020-01-02T14:00:00.000Z",
        "endTime": "2020-01-02T16:00:00.000Z",
        "riderID": "61274c50-819f-11ea-8b9d-c3580ef31720",
        "riderID": null,
        "repeatsOn": null,
        "driverID": ["test"]
    },
    {
        "id": "95eda1a0-788a-11ea-951d-ebcedc63b5e1",
        "startLocation": "Baker",
        "endLocation": "Risley",
        "startTime": "2020-01-02T05:00:00.000Z",
        "endTime": "2020-01-02T00:00:00.000Z",
        "isScheduled": false,
        "riderID": null,
        "repeatsOn": null,
        "driverID": ["test"]
    },
    {
        "id": "95eda1a0-788a-11ea-951d-ebcedc63b5e1",
        "startLocation": "Gates Hall",
        "endLocation": "Morrill Hall",
        "startTime": "2020-01-02T05:00:00.000Z",
        "endTime": "2020-01-02T00:00:00.000Z",
        "isScheduled": false,
        "riderID": null,
        "repeatsOn": null,
        "driverID": ["bad"]
    }
  ]
}''';
    await new Future.delayed(const Duration(seconds: 1));
    List<Ride> rides = _ridesFromJson(responseBody);
    Ride currentRide;
    if (rides.length > 0) {
      currentRide = rides[0];
      rides.removeAt(0);
    }
    var d = _RideData(rides, currentRide);
    return d;

    /*
    AppConfig config = AppConfig.of(context);
    final dateFormat = DateFormat("yyyy-MM-dd");
    var now = DateTime.now();
    final response = await http
        .get(new Uri.http(config.baseUrl,'/active-rides',{"date":dateFormat.format(now)}));
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<Ride> rides = _ridesFromJson(responseBody);
      Ride currentRide;
      if(rides.length > 0) {
        currentRide = rides[0];
        rides.removeAt(0);
      }
      var d = _RideData(rides,currentRide);
      return d;
    } else {
      throw Exception('Failed to load rides.');
    }
    */
  }

  List<Ride> _ridesFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Ride> res = data
        .map<Ride>((e) => Ride.fromJson(e))
        .where((Ride e) => e.driverId.contains(widget.driverId))
        .toList();
    res.sort((a, b) => a.startTime.compareTo(b.startTime));
    return res;
  }

  // TODO: replace this when name is stored somewhere
  String getNameFromSharedStateSomewhere() {
    return "Chris";
  }

  Widget _futureRide(BuildContext context, _RideData d, int index) {
    return FutureRide(d.rides[index]);
  }

  Widget _emptyPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 195),
        Center(
            child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/steeringWheel@3x.png'),
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            SizedBox(height: 22),
            Text(
              'Congratulations! You are done for the day. \n'
              'Come back tomorrow!',
              textAlign: TextAlign.center,
            )
          ],
        )),
      ],
    );
  }

  Widget _mainPage(BuildContext context, _RideData data) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // height: 20,
        children: <Widget>[
          LeftSubheading(heading: 'Upcoming Ride'),
          Center(
            child: CurrentRide(data.currentRide),
          ),
          SizedBox(height: 16.0),
          LeftSubheading(heading: 'Today\'s Schedule'),
          Expanded(
            child: ListView.separated(
              itemCount: data.rides.length,
              itemBuilder: (BuildContext c, int index) =>
                  _futureRide(c, data, index),
              separatorBuilder: (BuildContext context, int index) => Divider(),
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 5.0),
              shrinkWrap: true,
            ),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Greeting(getNameFromSharedStateSomewhere()),
          Expanded(
              child: FutureBuilder<_RideData>(
                  future: rideData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.rides.length == 0) {
                        return _emptyPage(context);
                      } else {
                        return _mainPage(context, snapshot.data);
                      }
                    } else if (snapshot.hasError) {
                      // TODO: placeholder error response
                      return Text("${snapshot.error}");
                    }
                    return Center(child: CircularProgressIndicator());
                  }))
        ]);
  }
}
