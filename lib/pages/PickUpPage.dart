import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideInfoCard.dart';
import 'package:flutter/material.dart';

// TODO: replace with real model later
class _TempPageData {
  final String firstName;
  final ImageProvider<dynamic> photo;
  final DateTime time;
  final String stop;
  final String address;

  _TempPageData(this.firstName, this.photo, this.time, this.stop, this.address);
}

class PickUpPage extends StatelessWidget {
  final _TempPageData data = _TempPageData(
      "Alex",
      NetworkImage(
          "https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-001_1-225x225.jpg"),
      DateTime.now(),
      "Upson Hall",
      "124");

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
              Text("Is ${data.firstName} here?",
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 59),
              RideInfoCard(data.firstName, data.photo, false, data.stop,
                  data.address, data.time),
              Expanded(child: SizedBox()),
              CButton(
                  text: "Pick up",
                  onPressed: () {
                    // TODO: arrive functionality
                    // TODO: push next page in flow
                  }),
              DangerButton(
                  text: "Report No Show",
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                              actionName: "Notify",
                              onConfirm: () {
                                // TODO: notify delay functionality
                              },
                              content: Text(
                                  "Do you want to notify the dispatcher of a No Show?"),
                            ),
                        barrierDismissible: true);
                  })
            ],
          ),
        ));
  }
}
