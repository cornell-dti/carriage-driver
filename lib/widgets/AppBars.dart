import 'package:flutter/material.dart';

import '../Home.dart';
import '../Rides.dart';

class ReturnHomeBar extends StatelessWidget implements PreferredSizeWidget {
  static final double prefHeight = 80;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: prefHeight,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => Home())
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 40,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.comfortable,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) => Home())
                      );
                    },
                  ),
                  Text("Home", style: TextStyle(fontSize: 17))
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefHeight);
}

class CalendarButtonBar extends StatelessWidget implements PreferredSizeWidget {
  final double buttonSize = 24;
  final double topPadding = 40;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: topPadding, right: 16),
          child: Image.asset('assets/images/calendarButton.png', width: buttonSize, height: buttonSize),
        ),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => Scaffold(
              body: SafeArea(
                child: Rides(false)
              )
            ))
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(buttonSize + topPadding);
}
