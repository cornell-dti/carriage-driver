import 'package:flutter/material.dart';

import '../pages/Home.dart';

class BackBar extends StatelessWidget implements PreferredSizeWidget {
  BackBar(this.text, this.backgroundColor, {this.action});
  final String text;
  final Color backgroundColor;
  final Function action;

  static final double prefHeight = 80;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: prefHeight,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () => action != null ? action : Navigator.of(context).pop(),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Image.asset('assets/images/backArrow.png', width: 12, height: 21),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) => Home())
                      );
                    },
                  ),
                  Text(text, style: TextStyle(fontSize: 17))
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefHeight);
}
