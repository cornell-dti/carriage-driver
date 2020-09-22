import 'dart:convert';
import 'package:carriage/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Ride.dart';
import 'package:http/http.dart' as http;

class Rides extends StatefulWidget {
  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Ride>> _fetchRides(String id) async {
    final dateFormat = DateFormat("yyyy-MM-dd");
    DateTime now = DateTime.now();
    final response = await http.get(AppConfig.of(context).baseUrl + '/rides/active?date=${dateFormat.format(now)}&driverId=${Provider.of<AuthProvider>(context).id}');
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<Ride> rides = _ridesFromJson(responseBody);
      return rides;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  List<Ride> _ridesFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Ride> res = data
        .map<Ride>((e) => Ride.fromJson(e))
        .toList();
    res.sort((a, b) => a.startTime.compareTo(b.startTime));
    return res;
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

  Widget _mainPage(BuildContext context, List<Ride> rides) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: rides.length,
              itemBuilder: (BuildContext c, int index) =>
                  RideCard(rides[index]),
              padding: EdgeInsets.only(left: 16, right: 16),
              shrinkWrap: true,
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 32),
              child: Text(DateFormat('yMMMM').format(DateTime.now()), style: Theme.of(context).textTheme.headline5),
            ),
            Expanded(
                child: FutureBuilder<List<Ride>>(
                    future: _fetchRides(authProvider.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length == 0) {
                          return _emptyPage(context);
                        } else {
                          return _mainPage(context, snapshot.data);
                        }
                      } else if (snapshot.hasError) {
                        // TODO: placeholder error response
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                )
            )
          ]
      ),
    );
  }
}
