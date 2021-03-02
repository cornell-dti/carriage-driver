import 'package:carriage/MeasureRect.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/pages/PickUpPage.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideDestPickupCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../CarriageTheme.dart';
import '../RidesProvider.dart';

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
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    int numRides = ridesProvider.currentRides.length;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CalendarButtonBar(),
        body: LoadingOverlay(
          color: Colors.white,
          opacity: 0.3,
          isLoading: _requestedContinue,
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    CalendarButton(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            numRides > 0
                                ? Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(numRides.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ))
                                : SizedBox(height: 24),
                            Text("On your way to...",
                                style: CarriageTheme.largeTitle)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    CircleAvatar(
                      radius: 50,
                      //TODO: replace with rider image
                      backgroundImage: AssetImage('assets/images/terry.jpg'),
                    ),
                    SizedBox(height: 16),
                    Text(widget.ride.rider.firstName,
                        style: CarriageTheme.title1),
                    widget.ride.rider.accessibilityNeeds.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                                widget.ride.rider.accessibilityNeeds.join(', '),
                                style: CarriageTheme.body),
                          )
                        : Container(),
                    SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CallButton(),
                      SizedBox(width: 16),
                      NotifyButton()
                    ]),
                    SizedBox(height: 40),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        width: double.infinity,
                        child: RideDestPickupCard(
                            false,
                            widget.ride.startTime,
                            widget.ride.startLocation,
                            widget.ride.startAddress)),
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      width: MediaQuery.of(context).size.width,
                      child: MeasureRect(
                        onChange: widget.onContinueRectChange,
                        child: CButton(
                            text: "I've Arrived",
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
                        text: "Cancel Ride",
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => ConfirmDialog(
                                    title: "Cancel Current Ride",
                                    content:
                                        "Would you like to cancel this current ride?",
                                    actionName: "Cancel Ride",
                                    onConfirm: () {
                                      // TODO: cancel ride functionality
                                    },
                                  ),
                              barrierDismissible: true);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
