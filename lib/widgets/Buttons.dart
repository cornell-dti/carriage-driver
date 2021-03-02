import 'package:flutter/material.dart';

import '../CarriageTheme.dart';
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
            textColor: Color(0xFFF08686),
            child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: onPressed
        )
    );
  }
}

class ShadowedIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  ShadowedIconButton(this.icon, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [CarriageTheme.shadow]
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(icon, size: 20, color: Colors.black),
          )
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowedIconButton(Icons.phone, () {
      // TODO: implement call
    });
  }
}

class NotifyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowedIconButton(Icons.notifications, () {
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
    });
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
            IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  // TODO: implement button functionality
                }
            ),
          ]
      ),
    );
  }
}