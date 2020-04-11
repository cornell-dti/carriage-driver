import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Login.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
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
                top: 18.0 + MediaQuery.of(context).padding.top,
                bottom: 16.0
            ),
            child: Text(
                'Your Profile',
                style: Theme.of(context).textTheme.headline
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
                    Padding (
                        padding: EdgeInsets.only(left: _picMarginLR, right: _picMarginLR, top: _picMarginTB, bottom: _picMarginTB),
                        child: Stack (
                          children: [
                            Padding (
                                padding: EdgeInsets.only(bottom: _picDiameter * 0.05),
                                child: CircleAvatar(
                                  radius: _picRadius,
                                  backgroundImage: NetworkImage(imageUrl),
                                )
                            ),

                            Positioned(
                                child: Container (
                                  height: _picBtnDiameter,
                                  width: _picBtnDiameter,
                                  child: FittedBox (
                                    child: FloatingActionButton (
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
                      child: Stack (
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
                                  onPressed: () {
                                  },
                                )
                              ]
                          ),
                          Positioned(
                            child: Text("Joined 03/2020",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                )
                            ),
                            top: 45,
                          )
                        ],
                      )
                    )
                  ]
              )
          )
        ]
    );
  }
}

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {

  Widget infoRow(BuildContext context, IconData icon, String text) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
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
    List<IconData> icons = [Icons.mail_outline, Icons.phone];
    List<String> tempText = [email, "Add your number"];

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
                    'Account Info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                ),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, icons[index], tempText[index]);
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