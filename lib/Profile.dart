import 'package:carriage/app_config.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class Break {
  String day;
  String startTime;
  String endTime;
  Break(this.day, this.startTime, this.endTime);

  factory Break.fromJson(String day, Map<String, dynamic> json) {
    return Break(day, json['startTime'], json['endTime']);
  }

  String toString() {
    return "$day: $startTime to $endTime";
  }
}

class Breaks {
  List<Break> breaks;
  Breaks(this.breaks);

  factory Breaks.fromJson(Map<String, dynamic> json) {
    List<Break> breaks;
    json.forEach((k, v) {
      breaks.add(Break.fromJson((abbrevToDay(k)), json[k]));
    });
    return Breaks(breaks);
  }

  static String abbrevToDay(String abbrev) {
    switch (abbrev) {
      case ("Mon"): return "Monday";
      case ("Tue"): return "Tuesday";
      case ("Wed"): return "Wednesday";
      case ("Thu"): return "Thursday";
      case ("Fri"): return "Friday";
      default: return "INVALID DAY";
    }
  }

  String toString() {
    return breaks.fold("", (prev, element) => "$prev\n$element");
  }
}

class Driver {
  final String id;
  final String firstName;
  final String lastName;
  final String startTime;
  final String endTime;
  final Breaks breaks;
  final String vehicle;
  final String phoneNumber;
  final String email;

  Driver({this.id, this.firstName, this.lastName, this.startTime, this.endTime,
      this.breaks, this.vehicle, this.phoneNumber, this.email});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        breaks: (json['breaks'] == null) ? null : Breaks.fromJson(json['breaks']),
        vehicle: json['vehicle'],
        phoneNumber: json['phoneNumber'],
        email: json['email']
    );
  }
}

class Profile extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;
  final String id;
  Profile(this.name, this.email, this.imageUrl, this.id, {Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Driver> futureDriver;

  Future<Driver> fetchDriver(String id) async {

    final response = await http.get(AppConfig.of(context).baseUrl + "/drivers/" + widget.id);

    if (response.statusCode == 200) {
      return Driver.fromJson(json.decode(response.body));
    }
    else {
      throw Exception('Failed to retrieve driver');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

    return FutureBuilder<Driver>(
        future: fetchDriver(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 24.0,
                      top: 18.0 + MediaQuery
                          .of(context)
                          .padding
                          .top,
                      bottom: 16.0
                  ),
                  child: Text(
                      'Your Profile',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline5
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(15, 0, 0, 0),
                            offset: Offset(0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0
                        )
                      ],
                    ),
                    child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: _picMarginLR,
                                  right: _picMarginLR,
                                  top: _picMarginTB,
                                  bottom: _picMarginTB),
                              child: Stack(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: _picDiameter * 0.05),
                                      child: CircleAvatar(
                                        radius: _picRadius,
                                        backgroundImage: NetworkImage(widget.imageUrl),
                                      )
                                  ),

                                  Positioned(
                                      child: Container(
                                        height: _picBtnDiameter,
                                        width: _picBtnDiameter,
                                        child: FittedBox(
                                          child: FloatingActionButton(
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                  Icons.add,
                                                  size: _picBtnDiameter
                                              ),
                                              onPressed: () {}
                                          ),
                                        ),
                                      ),
                                      left: _picDiameter * 0.61,
                                      top: _picDiameter * 0.66
                                  )
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 30),
                              child: Stack(
                                overflow: Overflow.visible,
                                children: [
                                  Row(
                                      children: [
                                        Text(widget.name,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            )
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              Icons.edit,
                                              size: 20
                                          ),
                                          onPressed: () {},
                                        )
                                      ]
                                  ),
                                  Positioned(
                                    child: Text("Joined 03/2020",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme
                                              .of(context)
                                              .accentColor,
                                        )
                                    ),
                                    top: 45,
                                  )
                                ],
                              )
                          )
                        ]
                    )
                ),
                SizedBox(height: 6),
                InfoGroup(
                    "Account Info",
                    [Icons.mail_outline, Icons.phone],
                    [widget.email, snapshot.data.phoneNumber]
                ),
                SizedBox(height: 6),
                InfoGroup(
                    "Schedule Info",
                    [Icons.schedule, Icons.free_breakfast, Icons.directions_car],
                    // TODO: retrieve from backend
                    ["${snapshot.data.startTime} to ${snapshot.data.endTime}",
                      (snapshot.data.breaks == null) ? 'None' : snapshot.data.breaks.toString(),
                      snapshot.data.vehicle]
                )
              ],
            );
          }
          else if (snapshot.hasError) {
            return SafeArea(
                child: Text("${snapshot.error}")
            );
          }
          return SafeArea(
              child: Center(
                child: CircularProgressIndicator()
              )
          );
        }
    );
  }
}

class InfoGroup extends StatefulWidget {

  InfoGroup(this.title, this.icons, this.fields);
  final String title;
  final List<IconData> icons;
  final List<String> fields;

  @override
  _InfoGroupState createState() => _InfoGroupState();
}

class _InfoGroupState extends State<InfoGroup> {

  Widget infoRow(BuildContext context, IconData icon, String text) {
    double paddingTB = 10;
    return Padding(
        padding: EdgeInsets.only(top: paddingTB, bottom: paddingTB),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 19),
            Expanded (
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(15, 0, 0, 0),
                offset: Offset(0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0
            )
          ],
        ),
        child: Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )
                ),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, widget.icons[index], widget.fields[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                      );
                    }
                )
              ],
            )
        )
    );
  }
}