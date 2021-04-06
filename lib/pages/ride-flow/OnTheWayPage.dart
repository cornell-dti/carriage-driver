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
    return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          color: Colors.white,
          opacity: 0.3,
          isLoading: _requestedContinue,
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CalendarButton(),
                  Divider(height: 12),
                  SizedBox(height: 12),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("On your way to...",
                                  style: CarriageTheme.title2)),
                          SizedBox(height: 32),
                          Row(
                              children: [
                                widget.ride.rider.profilePicture(100),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.ride.rider.firstName,
                                        style: CarriageTheme.title3),
                                    widget.ride.rider.accessibilityNeeds.length > 0
                                        ? Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                          widget.ride.rider.accessibilityNeeds
                                              .join(', '),
                                          style: CarriageTheme.body),
                                    ) : Container(),
                                    SizedBox(height: 16),
                                    Row(
                                        children: [
                                          CallButton(widget.ride.rider.phoneNumber, 40),
                                          SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              widget.ride.status = RideStatus.NOT_STARTED;
                                              Provider.of<RidesProvider>(context, listen: false).pauseRide(widget.ride);
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(builder: (BuildContext context) => Home())
                                              );
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [CarriageTheme.shadow],
                                                    color: Colors.white
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 9),
                                                  child: Text('Pause Ride',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'SFText',
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14,
                                                      )
                                                  ),
                                                )
                                            ),
                                          )
                                        ]
                                    ),
                                  ],
                                )
                              ]),
                        ],
                      )
                  ),

                  SizedBox(height: 40),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      width: double.infinity,
                      child: RideDestPickupCard(false, widget.ride.startTime,
                          widget.ride.startLocation, widget.ride.startAddress)),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 34),
                    width: MediaQuery.of(context).size.width,
                    child: MeasureRect(
                      onChange: widget.onContinueRectChange,
                      child: CButton(
                          text: "I've Arrived",
                          hasShadow: true,
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
                  ),
                  DangerButton(
                      text: "Notify of Delay",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => ConfirmDialog(
                              title: "Notify Delay",
                              content:
                              "Would you like to notify the rider of a delay?",
                              actionName: "Notify",
                              onConfirm: () {
                                // TODO: notification functionality
                              },
                            ),
                            barrierDismissible: true);
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
