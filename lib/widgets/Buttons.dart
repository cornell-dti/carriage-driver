import 'package:carriage/models/Ride.dart';
import 'package:carriage/pages/Rides.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/CarriageTheme.dart';
import 'Dialogs.dart';

/// Black button with white text
class CButton extends StatelessWidget {
  final String text;
  final bool hasShadow;
  final void Function() onPressed;

  CButton({@required this.text, @required this.hasShadow, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
              primary: Colors.black,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.8,
                50,
              )),
          child: Text(text, style: CarriageTheme.button),
          onPressed: onPressed,
        ));
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
        child: TextButton(
            child: Text(text, style: CarriageTheme.button.copyWith(color: Color.fromRGBO(240, 134, 134, 1))),
            onPressed: onPressed));
  }
}

class ShadowedCircleButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;
  final double diameter;
  ShadowedCircleButton(this.icon, this.onPressed, this.diameter);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100), boxShadow: [CarriageTheme.shadow]),
      child: Material(
          type: MaterialType.transparency,
          child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              onTap: onPressed,
              child: icon)),
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
    return ShadowedCircleButton(Icon(Icons.phone), () async {
      if (await canLaunch(phoneURL)) {
        await launch(phoneURL);
      } else {
        throw 'Could not launch $phoneURL';
      }
    }, diameter);
  }
}

class NotifyButton extends StatelessWidget {
  NotifyButton(this.ride, this.diameter);
  final Ride ride;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ShadowedCircleButton(Icon(Icons.notifications), () {
      showDialog(
          context: context,
          builder: (_) => ConfirmDialog(
                title: "Notify Delay",
                content: "Would you like to notify the rider of a delay?",
                actionName: "Notify",
                onConfirm: () async {
                  await notifyDelay(context, ride.id);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
          barrierDismissible: true);
    }, diameter);
  }
}

class CalendarButton extends StatelessWidget {
  CalendarButton({this.highlight = false});
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
          icon: Image.asset(
            highlight ? 'assets/images/highlightedCalendarButton.png' : 'assets/images/calendarButton.png',
            width: highlight ? 24 : 20,
            height: highlight ? 24 : 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Scaffold(body: SafeArea(child: Rides(interactive: false)))));
          }),
    );
  }
}
