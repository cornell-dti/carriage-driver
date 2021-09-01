import 'package:flutter/material.dart';

import '../utils/CarriageTheme.dart';
import 'Buttons.dart';

// TODO: update when design is confirmed
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionName;
  final void Function() onConfirm;

  const ConfirmDialog(
      {Key key,
      @required this.title,
      @required this.content,
      @required this.onConfirm,
      @required this.actionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: CarriageTheme.title3),
          SizedBox(height: 8),
          Text(content, style: CarriageTheme.body, textAlign: TextAlign.center),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            child: CButton(
                text: actionName, hasShadow: false, onPressed: onConfirm),
          ),
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CarriageTheme.gray3)))
        ],
      ),
    );
  }
}
