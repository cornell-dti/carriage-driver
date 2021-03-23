import 'dart:math';
import '../models/Ride.dart';
import '../models/Rider.dart';
import '../pages/Rides.dart';
import '../pages/ride-flow/BeginRidePage.dart';
import '../pages/ride-flow/OnTheWayPage.dart';
import '../pages/ride-flow/PickUpPage.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/OnboardingWidgets.dart';
import 'package:flutter/material.dart';

import 'Onboarding.dart';

// SAMPLE DATA

final List<Rider> _sampleRiders = [
  Rider(
      firstName: "Alex",
      lastName: "Mcgregor",
      accessibilityNeeds: ["Crutches"]),
  Rider(
      firstName: "James", lastName: "Lee", accessibilityNeeds: ["Wheelchair"]),
  Rider(firstName: "Alex", lastName: "Mcgregor", accessibilityNeeds: []),
  Rider(firstName: "Chelsea", lastName: "Wang", accessibilityNeeds: [])
];

final List<Ride> _sampleRides = [
  Ride(
      startLocation: "RPCC",
      startAddress: "124 Hoy Rd, Ithaca, NY 14850",
      endLocation: "Teagle Hall",
      endAddress: "109 Tower Rd, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 15),
      endTime: DateTime(2020, 1, 1, 21, 50),
      rider: _sampleRiders[0]),
  Ride(
      startLocation: "Low Rise 7",
      endLocation: "Teagle Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 30),
      endTime: DateTime(2020, 1, 1, 21, 50),
      rider: _sampleRiders[1]),
  Ride(
      startLocation: "RPCC",
      endLocation: "Upson Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 50),
      endTime: DateTime(2020, 1, 1, 21, 50),
      rider: _sampleRiders[2]),
  Ride(
      startLocation: "RPCC",
      endLocation: "Upson Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 50),
      endTime: DateTime(2020, 1, 1, 21, 50),
      rider: _sampleRiders[3]),
];

final List<Ride> _sampleCurrentRides = [
  _sampleRides[0],
];

// PAGES

Widget _start(OnboardingState state, BuildContext context) {
  return Padding(
    padding:
        const EdgeInsets.only(left: 34.0, right: 34.0, bottom: 77.0, top: 97.0),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                "Welcome to Carriage",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headline5.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Click to take a tour",
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
          CButton(text: "Continue", hasShadow: false, onPressed: () => state.nextStage(context))
        ]),
  );
}

Widget _sampleRidesPage(
    {void Function(Rect) firstRemainingRideRectCb =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: RidesStateless(
    remainingRides: _sampleRides,
    currentRides: [],
    selectedRideIDs: [],
    firstRemainingRideRectCb: firstRemainingRideRectCb,
  ));
}

Widget _ridesPreview(OnboardingState state, BuildContext context) {
  return OverlayShadow(
      overlay: OnboardingSheet(
        state,
        headingText: "View your schedule with ease.",
        bodyText: "Your personalized rides for the day are organized by time.",
        progress: 0.15,
      ),
      child: _sampleRidesPage());
}

Widget _ridesTryIt(OnboardingState state, BuildContext context) {
  double radius = 12;
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _sampleRidesPage(
        firstRemainingRideRectCb: (rect) {
          piper.onCallback(rect);
        },
      ),
      radius: radius,
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, radius: radius)),
          Padding(
            padding: EdgeInsets.only(top: highlightRect.bottom),
            child: Row(children: [
              Expanded(flex: 2, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 195,
                  height: 106,
                  child: TryItBubble(
                      text: "Click on a ride card to get more details.",
                      down: false),
                ),
              ),
              Expanded(flex: 1, child: SizedBox())
            ]),
          ),
        ]);
      });
}

Widget _sampleBeginRidePage(
    {void Function(Rect) onContinueRectChange =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: BeginRidePage(
    ride: _sampleRides[0],
    onContinueRectChange: onContinueRectChange,
  ));
}

Widget _beginRidePreview(OnboardingState state, BuildContext context) {
  return OverlayShadow(
    overlay: OnboardingSheet(state,
        headingText: "Complete rides in just a few clicks.",
        bodyText: "Description here.",
        progress: 0.4),
    child: _sampleBeginRidePage(),
  );
}

Widget _beginRideTryIt(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _sampleBeginRidePage(
        onContinueRectChange: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, radius: 2)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.top - 108)),
            child: Row(children: [
              Expanded(flex: 1, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 220,
                  height: 90,
                  child: TryItBubble(
                      text: "Click to begin this ride.", down: true),
                ),
              ),
              Expanded(flex: 1, child: SizedBox())
            ]),
          ),
        ]);
      });
}

Widget _sampleOnTheWayPage(
    {void Function(Rect) onContinueRectChange =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: OnTheWayPage(
    ride: _sampleRides[0],
    onContinueRectChange: onContinueRectChange,
  ));
}

Widget _onTheWayTryIt(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _sampleOnTheWayPage(
        onContinueRectChange: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, radius: 2)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.top - 113)),
            child: Row(children: [
              Expanded(flex: 3, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 221,
                  height: 95,
                  child: TryItBubble(
                      text: "Click to notify the rider of your arrival.",
                      down: true),
                ),
              ),
              Expanded(flex: 2, child: SizedBox())
            ]),
          ),
        ]);
      });
}

Widget _samplePickupPage(
    {void Function(Rect) onContinueRectChange =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: PickUpPage(
    ride: _sampleRides[0],
    onContinueRectChange: onContinueRectChange,
  ));
}

Widget _pickupTryIt(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _samplePickupPage(
        onContinueRectChange: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, radius: 2)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.top - 113)),
            child: Row(children: [
              Expanded(flex: 3, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 221,
                  height: 95,
                  child: TryItBubble(
                      text: "Click once you've picked up.", down: true),
                ),
              ),
              Expanded(flex: 2, child: SizedBox())
            ]),
          ),
        ]);
      });
}

Widget _sampleRidesInProgressPage(
    {void Function(Rect) firstRemainingRideRectCb =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: RidesStateless(
    currentRides: _sampleCurrentRides,
    remainingRides: _sampleRides.getRange(1, _sampleRides.length).toList(),
    selectedRideIDs: [],
    firstRemainingRideRectCb: firstRemainingRideRectCb,
  ));
}

Widget _ridesInProgressPreview(OnboardingState state, BuildContext context) {
  return OverlayShadow(
    overlay: OnboardingSheet(state,
        headingText: "Complete multiple rides at once.",
        bodyText: "Description here.",
        progress: 0.7),
    child: _sampleRidesInProgressPage(),
  );
}

Widget _ridesInProgressTryIt(OnboardingState state, BuildContext context) {
  double radius = 12;
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _sampleRidesInProgressPage(
        firstRemainingRideRectCb: (rect) {
          piper.onCallback(rect);
        },
      ),
      radius: radius,
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, radius: radius)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.top - 135)),
            child: Row(children: [
              Expanded(flex: 90, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 221,
                  height: 115,
                  child: TryItBubble(
                      text:
                          "Click on another ride card to add it to your current rides.",
                      down: true),
                ),
              ),
              Expanded(flex: 102, child: SizedBox())
            ]),
          ),
        ]);
      });
}

List<Widget Function(OnboardingState state, BuildContext context)>
    stageBuilders = [
  _start,
  _ridesPreview,
  _ridesTryIt,
  _beginRidePreview,
  _beginRideTryIt,
  _onTheWayTryIt,
  _pickupTryIt,
  _ridesInProgressPreview,
  _ridesInProgressTryIt,
];
