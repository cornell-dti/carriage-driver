import 'package:flutter/material.dart';

class ReturnHomeBar extends StatelessWidget implements PreferredSizeWidget {
  static final double prefHeight = 80;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: prefHeight,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Row(
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
                    Navigator.of(context).maybePop();
                  },
                ),
                Text("Home", style: TextStyle(fontSize: 17))
              ]),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefHeight);
}
