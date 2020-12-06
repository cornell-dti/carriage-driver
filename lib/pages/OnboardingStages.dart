import 'dart:math';

import 'package:carriage/Ride.dart';
import 'package:carriage/Rider.dart';
import 'package:carriage/Rides.dart';
import 'package:carriage/pages/BeginRidePage.dart';
import 'package:carriage/pages/OnTheWayPage.dart';
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
];

final List<Ride> _sampleCurrentRides = [
  _sampleRides[0],
  Ride(
      startLocation: "RPCC",
      endLocation: "Upson Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 50),
      endTime: DateTime(2020, 1, 1, 21, 50),
      rider: _sampleRiders[3]),
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
          CButton(text: "Continue", onPressed: () => state.nextStage(context))
        ]),
  );
}

Widget _sampleRidesPage(
    {void Function(Rect) rectCallback = RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: RidesStateless(
    remainingRides: _sampleRides,
    currentRides: [],
    selectedRides: [],
    firstRemainingRideRectCb: rectCallback,
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
        rectCallback: (rect) {
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
  return GestureDetector(
    onTap: () => state.nextStage(context),
    child: OverlayShadow(
      child: _sampleBeginRidePage(),
      overlay: Align(
        alignment: Alignment.lerp(Alignment.center, Alignment.bottomRight, 0.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 275,
            height: 100,
            child: OnboardingBubble(
              heading: RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      children: [
                    TextSpan(text: "Everything you need. "),
                    TextSpan(text: "ℹ️")
                  ])),
              text: "All information about your rides is displayed.",
            ),
          ),
        ),
      ),
    ),
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

// Widget _sampleRidesInProgressPage(
//     {void Function(Rect) onFirstRideRectChanged =
//         RidesStateless.onChangeDefault}) {
//   return IgnorePointer(
//       child: RidesInProgressPageStateless(
//     currentRides: _sampleCurrentRides,
//     remainingRides: _sampleRides.getRange(1, _sampleRides.length).toList(),
//     selectedRides: [],
//     onFirstRideRectChange: onFirstRideRectChanged,
//   ));
// }

// Widget _ridesInProgressPreview(OnboardingState state, BuildContext context) {
//   return GestureDetector(
//     onTap: () => state.nextStage(context),
//     child: OverlayShadow(
//       child: _sampleRidesInProgressPage(),
//       overlay: Align(
//         alignment:
//             Alignment.lerp(Alignment.center, Alignment.bottomRight, 0.85),
//         child: Padding(
//           padding: const EdgeInsets.only(right: 20),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 300,
//               height: 80,
//               child: OnboardingBubble(
//                 heading: RichText(
//                     text: TextSpan(
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.w500),
//                         children: [
//                       TextSpan(text: "View your current rides. "),
//                       TextSpan(text: "🚗")
//                     ])),
//                 text: "Manage multiple rides at once.",
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget _ridesInProgressTryIt(OnboardingState state, BuildContext context) {
//   final piper = CallbackPiper<Rect>();
//   return OverlayWithHighlight(
//       highlightPiper: piper,
//       child: _sampleRidesInProgressPage(
//         onFirstRideRectChanged: (rect) {
//           piper.onCallback(rect);
//         },
//       ),
//       overlayBuilder: (context, highlightRect) {
//         return Stack(children: [
//           RectPositioned(
//               rect: highlightRect,
//               child: highlightRegion(state, context, radius: 2)),
//           Padding(
//             padding: EdgeInsets.only(top: max(0, highlightRect.bottom)),
//             child: Row(children: [
//               Expanded(flex: 1, child: SizedBox()),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: 221,
//                   height: 95,
//                   child: TryItBubble(
//                       text: "Click on a ride card to drop riders off.",
//                       down: false),
//                 ),
//               ),
//               Expanded(flex: 5, child: SizedBox())
//             ]),
//           ),
//         ]);
//       });
// }

List<Widget Function(OnboardingState state, BuildContext context)>
    stageBuilders = [
  _start,
  _ridesPreview,
  _ridesTryIt,
  _beginRidePreview,
  _beginRideTryIt,
  _onTheWayTryIt,
  // _pickupTryIt,
  // _ridesInProgressPreview,
  // _ridesInProgressTryIt
];
