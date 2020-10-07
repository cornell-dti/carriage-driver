import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/RideInfoCard.dart';
import 'package:flutter/material.dart';

// TODO: replace later
class TempRideData {
  final String firstName;
  final ImageProvider<dynamic> photo;
  final bool dropoff;
  final DateTime time;
  final String stop;
  final String address;

  TempRideData(this.firstName, this.photo, this.dropoff, this.time, this.stop,
      this.address);
}

// red text button
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
            onPressed: onPressed));
  }
}

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

class ReturnHomeBar extends StatelessWidget implements PreferredSizeWidget {
  static final double prefHeight = 100;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: prefHeight,
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
                Navigator.of(context).maybePop();
              },
            ),
            Text("Home", style: TextStyle(fontSize: 17))
          ]),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefHeight);
}

class OnTheWayPage extends StatefulWidget {
  @override
  _OnTheWayPageState createState() => _OnTheWayPageState(TempRideData(
      "Alex",
      NetworkImage(
          "https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-001_1-225x225.jpg"),
      true,
      DateTime.now(),
      "Upson Hall",
      "124"));
}

class _OnTheWayPageState extends State<OnTheWayPage> {
  final TempRideData data;

  _OnTheWayPageState(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ReturnHomeBar(),
        body: Padding(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("On your way to...",
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 59),
              RideInfoCard(data.firstName, data.photo, data.dropoff, data.stop,
                  data.address, data.time),
              Expanded(child: SizedBox()),
              CButton("Arrive", onPressed: () {
                // TODO: arrive functionality
                // TODO: push next page in flow
              }),
              DangerButton(
                  text: "Notify Delay",
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                              actionName: "Notify",
                              onConfirm: () {
                                // TODO: notify delay functionality
                              },
                              content: Text(
                                  "Do you want to notify the rider about your delay?"),
                            ),
                        barrierDismissible: true);
                  })
            ],
          ),
        ));
  }
}
