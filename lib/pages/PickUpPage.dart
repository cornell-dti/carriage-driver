import 'package:carriage/MeasureRect.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../Home.dart';

class PickUpPage extends StatefulWidget {
  final OnWidgetRectChange onContinueRectChange;
  static void onChangeDefault(Rect s) {}
  final Ride ride;

  PickUpPage({this.ride, this.onContinueRectChange = onChangeDefault});
  @override
  _PickUpPageState createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  bool _requestedContinue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CalendarButtonBar(),
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
                Text("Is ${widget.ride.rider.firstName} here?",
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 59),
                RideInfoCard(widget.ride, false),
                Expanded(child: SizedBox()),
                MeasureRect(
                  onChange: widget.onContinueRectChange,
                  child: CButton(
                      text: "Pick up",
                      onPressed: () async {
                        if (_requestedContinue) return;
                        setState(() => _requestedContinue = true);
                        final response = await updateRideStatus(
                            context, widget.ride.id, RideStatus.PICKED_UP);
                        if (!mounted) return;
                        if (response.statusCode == 200) {
                          setState(() => _requestedContinue = false);
                          widget.ride.status = RideStatus.PICKED_UP;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Home()));
                        } else {
                          setState(() => _requestedContinue = false);
                          throw Exception('Failed to update ride status');
                        }
                      }),
                ),
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
          ),
        ));
  }
}
