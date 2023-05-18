import 'package:carriage/providers/RidesProvider.dart';
import 'package:provider/provider.dart';

import '../../utils/MeasureRect.dart';
import '../../models/Ride.dart';
import '../Home.dart';
import 'PickUpPage.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideDestPickupCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../utils/CarriageTheme.dart';

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
    double buttonVerticalPadding = 16;
    double buttonHeight = 48;
    double delayButtonHeight = 48;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LoadingOverlay(
            color: Colors.white,
            opacity: 0.3,
            isLoading: _requestedContinue,
            child: Stack(children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: buttonHeight +
                          2 * buttonVerticalPadding +
                          delayButtonHeight +
                          16),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Row(children: [Spacer(), CalendarButton()]),
                      Divider(height: 32),
                      SizedBox(height: 24),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("On your way to...",
                                  style: CarriageTheme.title1)),
                          SizedBox(height: 48),
                          Row(children: [
                            widget.ride.rider.profilePicture(90),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.ride.rider.firstName,
                                    style: CarriageTheme.title3),
                                widget.ride.rider.accessibilityNeeds.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Text(
                                            widget.ride.rider.accessibilityNeeds
                                                .join(', '),
                                            style: CarriageTheme.body),
                                      )
                                    : Container(),
                                SizedBox(height: 16),
                                Row(children: [
                                  CallButton(widget.ride.rider.phoneNumber, 48),
                                  SizedBox(width: 12),
                                  Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                          boxShadow: [CarriageTheme.shadow],
                                          color: Colors.white),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          onTap: () {
                                            widget.ride.status =
                                                RideStatus.NOT_STARTED;
                                            Provider.of<RidesProvider>(context,
                                                    listen: false)
                                                .pauseRide(widget.ride);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Home()));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Center(
                                              child: Text('Pause Ride',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ))
                                ]),
                              ],
                            )
                          ]),
                        ],
                      ),
                      SizedBox(height: 60),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          width: double.infinity,
                          child: RideDestPickupCard(
                              false,
                              widget.ride.startTime,
                              widget.ride.startLocation,
                              widget.ride.startAddress)),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 34, right: 34, top: buttonVerticalPadding),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, -2),
                            color: Colors.black.withOpacity(0.05))
                      ]),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        MeasureRect(
                          onChange: widget.onContinueRectChange,
                          child: CButton(
                              text: "I've Arrived",
                              hasShadow: true,
                              onPressed: () async {
                                if (_requestedContinue) return;
                                setState(() => _requestedContinue = true);
                                final response = await updateRideStatus(context,
                                    widget.ride.id, RideStatus.ARRIVED);
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
                                  throw Exception(
                                      'Failed to update ride status');
                                }
                              }),
                        ),
                        SizedBox(
                          height: delayButtonHeight,
                          child: DangerButton(
                              text: "Notify of Delay",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => ConfirmDialog(
                                          title: "Notify Delay",
                                          content:
                                              "Would you like to notify the rider of a delay?",
                                          actionName: "Notify",
                                          onConfirm: () async {
                                            await notifyDelay(
                                                context, widget.ride.id);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                    barrierDismissible: true);
                              }),
                        ),
                        SizedBox(height: 8),
                      ])))
            ]),
          ),
        ));
  }
}
