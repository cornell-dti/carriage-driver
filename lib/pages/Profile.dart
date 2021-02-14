import '../utils/app_config.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../utils/CarriageTheme.dart';
import '../providers/UserInfoProvider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

    if (userInfoProvider.hasInfo()) {
      List<String> availabilities = [];
      userInfoProvider.info.availability.forEach((key, value) {
        availabilities.add('$key: ${value['startTime']}-${value['endTime']}');
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 24.0,
                top: 18.0 + MediaQuery.of(context).padding.top,
                bottom: 16.0),
            child: Text('Your Profile',
                style: CarriageTheme.largeTitle),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
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
                            padding:
                            EdgeInsets.only(bottom: _picDiameter * 0.05),
                            child: CircleAvatar(
                              radius: _picRadius,
                              backgroundImage:
                              NetworkImage(userInfoProvider.info.photoUrl),
                            )
                        ),
                        Positioned(
                            child: Container(
                              height: _picBtnDiameter,
                              width: _picBtnDiameter,
                              child: FittedBox(
                                child: FloatingActionButton(
                                    backgroundColor: Colors.black,
                                    child:
                                    Icon(Icons.add, size: _picBtnDiameter),
                                    onPressed: () {
                                      // TODO: add functionality to select photo if we decide to store profile images
                                    }),
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
                        Row(children: [
                          Text(
                              userInfoProvider.info.firstName +
                                  " " +
                                  userInfoProvider.info.lastName,
                              style: TextStyle(
                                  fontFamily: 'SFDisplay',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, size: 20),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(userInfoProvider.info)
                                  )
                              );
                            },
                          )
                        ]),
                        Positioned(
                          child: Text(
                              "Joined 03/2020",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(132, 132, 132, 1),
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
            [
              InfoRow(
                "email",
                Icons.mail_outline,
                userInfoProvider.info.email,
              ),
              InfoRow("phone number", Icons.phone,
                  userInfoProvider.info.phoneNumber)
            ],
          ),
          SizedBox(height: 6),
          InfoGroup(
            "Schedule Info",
            [
              InfoRow("hours", Icons.schedule,
                  availabilities.join('\n')),
              InfoRow("vehicle", Icons.directions_car,
                  userInfoProvider.info.vehicle),
            ],
          )
        ],
      );
    }
    else {
      return SafeArea(
          child: Center(
              child: CircularProgressIndicator()
          )
      );
    }
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
                  color: Color.fromRGBO(74, 74, 74, 1),
                ),
              ),
            ),
          ],
        )
    );
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
                color: Colors.black.withOpacity(0.15),
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
                    TextStyle(fontFamily: 'SFDisplay', fontSize: 20, fontWeight: FontWeight.bold)),
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
  EditProfile(this.driver);
  final UserInfo driver;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
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
              Text('Edit Profile',
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 20),
              Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(icon: Icon(Icons.person)),
                          initialValue: _firstName,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter your first name.';
                            }
                            return null;
                          },
                          onSaved: (input) {
                            setState(() {
                              _firstName = input;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Last Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(icon: Icon(Icons.person)),
                          initialValue: _lastName,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter your last name.';
                            }
                            return null;
                          },
                          onSaved: (input) {
                            setState(() {
                              _lastName = input;
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
                          keyboardType: TextInputType.number,
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
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      userInfoProvider.updateDriver(AppConfig.of(context),
                          authProvider, _firstName, _lastName, _phoneNumber);
                      Navigator.pop(context);
                    }
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
