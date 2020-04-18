import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;

class Break {
  String day;
  String startTime;
  String endTime;
  Break(this.day, this.startTime, this.endTime);

  factory Break.fromJson(String day, Map<String, dynamic> json) {
    return Break(day, json['startTime'], json['endTime']);
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
}

class Driver {
  String id;
  String firstName;
  String lastName;
  Breaks breaks;
  String vehicle;
  String phoneNumber;
  String email;

  Driver(this.id, this.firstName, this.lastName, this.breaks,
      this.vehicle, this.phoneNumber, this.email);

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        json['id'],
        json['firstName'],
        json['lastName'],
        Breaks.fromJson(json['breaks']),
        json['vehicle'],
        json['phoneNumber'],
        json['email']
    );
  }
}

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Driver> futureDriver;

  Future<Driver> fetchDriver(String id) async {
    final response = await http.get('localhost:3000/drivers/' + getID());

    if (response.statusCode == 200) {
      print("got status code 200");
      return Driver.fromJson(json.decode(response.body));
    }
    else {
      throw Exception('Failed to retrieve driver');
    }
  }
  @override
  void initState() {
    super.initState();
    futureDriver = fetchDriver(getID());
  }

  Widget buildProfile(BuildContext context, AsyncSnapshot snapshot) {
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

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
                  .headline
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
                                backgroundImage: NetworkImage(imageUrl),
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
                                Text(name,
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
            [email, "Add your number"]
        ),
        SizedBox(height: 6),
        InfoGroup(
            "Schedule Info",
            [Icons.schedule, Icons.free_breakfast, Icons.directions_car],
            // TODO: retrieve from backend
            ["Start - end time", "Break day", snapshot.data.vehicle]
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Driver>(
        future: futureDriver,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            buildProfile(context, snapshot);
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Column();
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
    double paddingTB = 5;
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