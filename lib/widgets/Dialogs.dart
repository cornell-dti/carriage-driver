import 'package:flutter/material.dart';

// TODO: update when design is confirmed
class ConfirmDialog extends StatelessWidget {
  final Widget content;
  final String actionName;
  final void Function() onConfirm;

  const ConfirmDialog(
      {Key key,
      @required this.content,
      @required this.onConfirm,
      @required this.actionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            textColor: Colors.blue,
            child: Text(actionName)),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
  }
}
