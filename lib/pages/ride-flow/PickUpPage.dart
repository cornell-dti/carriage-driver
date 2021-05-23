import 'package:carriage/providers/RidesProvider.dart';
import 'package:provider/provider.dart';

import '../../utils/MeasureRect.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideStops.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../utils/CarriageTheme.dart';
import '../Home.dart';
import '../../models/Ride.dart';

class PickUpPage extends StatefulWidget {
  final OnWidgetRectChange onContinueRectChange;
  static void onChangeDefault(Rect s) {}
  final Ride ride;
  final bool highlightScheduleButton;
  final bool highlightPickUpButton;

  PickUpPage({this.ride, this.onContinueRectChange = onChangeDefault, this.highlightPickUpButton = false, this.highlightScheduleButton = false});
  @override
  _PickUpPageState createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  bool _requestedContinue = false;

  @override
  Widget build(BuildContext context) {

    Widget pickUpButton = CButton(
        text: "I've Picked Up",
        hasShadow: true,
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
                    builder: (BuildContext context) =>
                        Home()));
          } else {
            setState(() => _requestedContinue = false);
            throw Exception('Failed to update ride status');
          }
        }
    );

    double buttonVerticalPadding = 16;
    double buttonHeight = 48;
    double noShowButtonHeight = 48;

    return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
            color: Colors.white,
            opacity: 0.3,
            isLoading: _requestedContinue,
            child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: buttonHeight + 2*buttonVerticalPadding + noShowButtonHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 16),
                            widget.highlightScheduleButton ? Row(
                                children: [
                                  Spacer(),
                                  MeasureRect(
                                      onChange: widget.onContinueRectChange,
                                      child: CalendarButton(highlight: true)
                                  )
                                ]
                            ) : Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Row(
                                  children: [
                                    Spacer(),
                                    CalendarButton()
                                  ]
                              ),
                            ),
                            Divider(height: 32),
                            SizedBox(height: 24),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Is ${widget.ride.rider.firstName} here?",
                                        style: CarriageTheme.title1)),
                                SizedBox(height: 24),
                                Row(children: [
                                  Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        widget.ride.rider.profilePicture(86),
                                        Positioned(
                                            bottom: -12,
                                            right: -12,
                                            child:
                                            CallButton(widget.ride.rider.phoneNumber, 48))
                                      ]),
                                  SizedBox(width: 24),
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
                                      )
                                          : Container(),
                                    ],
                                  )
                                ]),
                                SizedBox(height: 40),
                                RideStops(
                                    ride: widget.ride,
                                    carIcon: true
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(top: buttonVerticalPadding),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: Offset(0, -2),
                                      color: Colors.black.withOpacity(0.05)
                                  )
                                ]
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(horizontal: 34),
                                      child: widget.highlightPickUpButton ? MeasureRect(
                                          onChange: widget.onContinueRectChange,
                                          child: pickUpButton
                                      ) : pickUpButton
                                  ),
                                  DangerButton(
                                      text: "Report No Show",
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ConfirmDialog(
                                              title: "Report No Show",
                                              content:
                                              "Would you like to report a no show to the dispatcher?",
                                              actionName: "Report",
                                              onConfirm: () async {
                                                final noShowResponse =
                                                await updateRideStatus(context,
                                                    widget.ride.id, RideStatus.NO_SHOW);
                                                if (noShowResponse.statusCode == 200) {
                                                  final pastResponse = await setRideToPast(
                                                      context, widget.ride.id);
                                                  if (pastResponse.statusCode == 200) {
                                                    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
                                                    ridesProvider.finishCurrentRide(widget.ride);
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext context) =>
                                                                Home()));
                                                  } else {
                                                    throw 'Failed to set no-show ride to past: ' +
                                                        pastResponse.body;
                                                  }
                                                } else {
                                                  throw 'Failed to set no-show ride status: ' +
                                                      noShowResponse.body;
                                                }
                                              },
                                            ),
                                            barrierDismissible: true
                                        );

                                      }
                                  ),
                                ]
                            )
                        )
                    )
                  ],
                )
            )
        )
    );
  }
}
