import 'package:carriage/MeasureRect.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/pages/PickUpPage.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class OnTheWayPage extends StatefulWidget {
  final Ride ride;

  final OnWidgetRectChange onContinueRectChange;
  static void onChangeDefault(Rect s) {}

  OnTheWayPage({this.ride, this.onContinueRectChange = onChangeDefault});
  @override
  _OnTheWayPageState createState() => _OnTheWayPageState();
}

class _OnTheWayPageState extends State<OnTheWayPage> {
  bool _requestedContinue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ReturnHomeBar(),
        body: LoadingOverlay(
          color: Colors.white,
          opacity: 0.3,
          isLoading: _requestedContinue,
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("On your way to...",
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 59),
                RideInfoCard(widget.ride, false),
                Expanded(child: SizedBox()),
                MeasureRect(
                  onChange: widget.onContinueRectChange,
                  child: CButton(
                      text: "Arrive",
                      onPressed: () async {
                        if (_requestedContinue) return;
                        setState(() => _requestedContinue = true);
                        final response = await updateRideStatus(
                            context, widget.ride.id, RideStatus.ARRIVED);
                        if (!mounted) return;
                        if (response.statusCode == 200) {
                          setState(() => _requestedContinue = false);
                          widget.ride.status = RideStatus.ARRIVED;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PickUpPage(ride: widget.ride)));
                        } else {
                          setState(() => _requestedContinue = false);
                          throw Exception('Failed to update ride status');
                        }
                      }),
                ),
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
          ),
        ));
  }
}
