import 'package:flutter/material.dart';

// black button with white text
class CButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  CButton(this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(16),
      color: Colors.black,
      child: Text(text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
      onPressed: onPressed,
    );
  }
}
