import 'package:flutter/material.dart';

import '../utils/CarriageTheme.dart';
import 'Dialogs.dart';

/// Black button with white text
class CButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  CButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(16),
      color: Colors.black,
      child: Text(text,
          style: CarriageTheme.button),
      onPressed: onPressed,
    );
  }
}

/// Button with red text, no background
class DangerButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  DangerButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FlatButton(
            textColor: Color.fromRGBO(240, 134, 134, 1),
            child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: onPressed
        )
    );
  }
}

class ShadowedCircleButton extends StatelessWidget {
  final String imagePath;
  final Function onPressed;
  final double diameter;
  ShadowedCircleButton(this.imagePath, this.onPressed, this.diameter);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [CarriageTheme.shadow]
          ),
          child: Padding(
            padding: EdgeInsets.all(diameter / 4),
            child: Image.asset(imagePath, color: Colors.black),
          )
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  CallButton(this.phoneNumber, this.diameter);
  final String phoneNumber;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ShadowedCircleButton('assets/images/phoneIcon.png', () {
      // TODO: implement call
    }, diameter);
  }
}

class NotifyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowedCircleButton('assets/images/bellIcon.png', () {
      showDialog(
          context: context,
          builder: (_) => ConfirmDialog(
            title: "Notify Delay",
            content: "Would you like to notify the rider of a delay?",
            actionName: "Notify",
            onConfirm: () {
              // TODO: notify delay functionality
            },
          ),
          barrierDismissible: true
      );
    }, 40);
  }
}

class CalendarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
          children: [
            Spacer(),
            GestureDetector(
              child: Image.asset('assets/images/calendarButton.png', width: 20, height: 20,),
              onTap: () {
                //TODO: view switching functionality
              }
            )
          ]
      ),
    );
  }
}