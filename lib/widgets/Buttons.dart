import 'package:carriage/pages/Rides.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/CarriageTheme.dart';
import 'Dialogs.dart';

/// Black button with white text
class CButton extends StatelessWidget {
  final String text;
  final hasShadow;
  final void Function() onPressed;

  CButton(
      {@required this.text,
        @required this.hasShadow,
        @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Widget button = ButtonTheme(
        child: RaisedButton(
          padding: EdgeInsets.all(16),
          color: Colors.black,
          textColor: Colors.white,
          child: Text(text,
              style: CarriageTheme.button),
          onPressed: onPressed,
        )
    );

    if (hasShadow) {
      return Container(
        child: button,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              blurRadius: 6,
              color: Colors.black.withOpacity(0.15))
        ]),
      );
    } else {
      return button;
    }
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
            onPressed: onPressed));
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
              boxShadow: [CarriageTheme.shadow]),
          child: Padding(
            padding: EdgeInsets.all(diameter / 3.5),
            child: Image.asset(imagePath, color: Colors.black),
          )),
    );
  }
}

class CallButton extends StatelessWidget {
  CallButton(this.phoneNumber, this.diameter);
  final String phoneNumber;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    String phoneURL = 'tel:' + phoneNumber;
    return ShadowedCircleButton('assets/images/phoneIcon.png', () async {
      if (await canLaunch(phoneURL)) {
        await launch(phoneURL);
      } else {
        throw 'Could not launch $phoneURL';
      }
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
          barrierDismissible: true);
    }, 40);
  }
}

class CalendarButton extends StatelessWidget {
  CalendarButton({this.highlight = false});
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Image.asset(
          highlight ? 'assets/images/highlightedCalendarButton.png' : 'assets/images/calendarButton.png',
          width: highlight ? 24 : 20,
          height: highlight ? 24 : 20,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  Scaffold(body: SafeArea(child: Rides(interactive: false)))));
        });
  }
}
