import 'package:carriage/app_config.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'AuthProvider.dart';

AuthProvider authProvider;

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
      case ("Mon"):
        return "Monday";
      case ("Tue"):
        return "Tuesday";
      case ("Wed"):
        return "Wednesday";
      case ("Thu"):
        return "Thursday";
      case ("Fri"):
        return "Friday";
      default:
        return "INVALID DAY";
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

  Driver(
      {this.id,
      this.firstName,
      this.lastName,
      this.startTime,
      this.endTime,
      this.breaks,
      this.vehicle,
      this.phoneNumber,
      this.email});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        breaks:
            (json['breaks'] == null) ? null : Breaks.fromJson(json['breaks']),
        vehicle: json['vehicle'],
        phoneNumber: json['phoneNumber'],
        email: json['email']);
  }
}

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Driver> futureDriver;

  Future<Driver> fetchDriver() async {
    final response = await http
        .get(AppConfig.of(context).baseUrl + "/drivers/" + authProvider.id);
    if (response.statusCode == 200) {
      return Driver.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to retrieve driver');
    }
  }

  void refresh(Future<Driver> newDriver) {
    print("refresh");
    setState(() {
      futureDriver = newDriver;
    });
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

    futureDriver = fetchDriver();

    return FutureBuilder<Driver>(
        future: futureDriver,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24.0,
                        top: 18.0 + MediaQuery.of(context).padding.top,
                        bottom: 16.0),
                    child: Text('Your Profile',
                        style: Theme.of(context).textTheme.headline),
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
                              spreadRadius: 1.0)
                        ],
                      ),
                      child: Row(children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: _picMarginLR,
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
                                      backgroundImage: NetworkImage(authProvider
                                          .googleSignIn.currentUser.photoUrl),
                                    )),
                                Positioned(
                                    child: Container(
                                      height: _picBtnDiameter,
                                      width: _picBtnDiameter,
                                      child: FittedBox(
                                        child: FloatingActionButton(
                                            backgroundColor: Colors.black,
                                            child: Icon(Icons.add,
                                                size: _picBtnDiameter),
                                            onPressed: () {}),
                                      ),
                                    ),
                                    left: _picDiameter * 0.61,
                                    top: _picDiameter * 0.66)
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                Row(children: [
                                  Text(
                                      snapshot.data.firstName +
                                          " " +
                                          snapshot.data.lastName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProfile(
                                                  snapshot.data, refresh)));
                                    },
                                  )
                                ]),
                                Positioned(
                                  child: Text("Joined 03/2020",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).accentColor,
                                      )),
                                  top: 45,
                                )
                              ],
                            ))
                      ])),
                  SizedBox(height: 6),
                  InfoGroup(
                    "Account Info",
                    [
                      InfoRow(
                        "email",
                        Icons.mail_outline,
                        snapshot.data.email,
                      ),
                      InfoRow("phone number", Icons.phone,
                          snapshot.data.phoneNumber)
                    ],
                  ),
                  SizedBox(height: 6),
                  InfoGroup(
                    "Schedule Info",
                    [
                      InfoRow("hours", Icons.schedule,
                          "${snapshot.data.startTime} to ${snapshot.data.endTime}"),
                      InfoRow(
                          "breaks",
                          Icons.free_breakfast,
                          (snapshot.data.breaks == null)
                              ? 'None'
                              : snapshot.data.breaks.toString()),
                      InfoRow("vehicle", Icons.directions_car,
                          snapshot.data.vehicle),
                    ],
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return SafeArea(child: Text("${snapshot.error}"));
            }
          }
          return SafeArea(child: Center(child: CircularProgressIndicator()));
        });
  }
}

class InfoRow extends StatefulWidget {
  InfoRow(this.fieldName, this.icon, this.text);
  final String fieldName;
  final IconData icon;
  final String text;

  @override
  _InfoRowState createState() => _InfoRowState();
}

class _InfoRowState extends State<InfoRow> {
  @override
  Widget build(BuildContext context) {
    double paddingTB = 16;

    return Padding(
        padding: EdgeInsets.only(top: paddingTB, bottom: paddingTB),
        child: Row(
          children: <Widget>[
            Icon(widget.icon),
            SizedBox(width: 19),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ));
  }
}

class InfoGroup extends StatefulWidget {
  InfoGroup(this.title, this.rows);
  final String title;
  final List<InfoRow> rows;

  @override
  _InfoGroupState createState() => _InfoGroupState();
}

class _InfoGroupState extends State<InfoGroup> {
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
                spreadRadius: 1.0)
          ],
        ),
        child: Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.rows.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.rows[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                      );
                    })
              ],
            )));
  }
}

class EditProfile extends StatefulWidget {
  EditProfile(this.driver, this.refresher);
  final Driver driver;
  final Function refresher;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  Future<Driver> updateDriver(AuthProvider authProvider, String firstName,
      String lastName, String phoneNumber) async {
    final response = await http.post(
      AppConfig.of(context).baseUrl + "/drivers/" + authProvider.id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      }),
    );
    if (response.statusCode == 200) {
      return Driver.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update driver');
    }
  }

  @override
  Widget build(BuildContext context) {
    String _firstName = widget.driver.firstName;
    String _lastName = widget.driver.lastName;
    String _phoneNumber = widget.driver.phoneNumber;
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18.0 + MediaQuery.of(context).padding.top,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Edit Profile', style: Theme.of(context).textTheme.headline),
              SizedBox(height: 20),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(icon: Icon(Icons.person)),
                          initialValue: _firstName + ' ' + _lastName,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter your first and last name.';
                            }
                            return null;
                          },
                          onSaved: (input) {
                            setState(() {
                              List<String> split = input.split(' ');
                              _firstName = split.first;
                              _lastName = split.removeLast();
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Phone Number',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(icon: Icon(Icons.phone)),
                          initialValue: _phoneNumber,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter your phone number.';
                            }
                            return null;
                          },
                          onSaved: (input) {
                            setState(() {
                              _phoneNumber = input;
                            });
                          },
                        ),
                      ])),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    _formKey.currentState.save();
                    widget.refresher(updateDriver(
                        authProvider, _firstName, _lastName, _phoneNumber));
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 30),
                RaisedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ])
            ])));
  }
}
