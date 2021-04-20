import 'package:carriage/utils/CarriageTheme.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_bubble/speech_bubble.dart';
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
      firstName: 'Marisa',
      accessibilityNeeds: ['Crutches'],
      phoneNumber: '',
      photoPath: 'assets/images/marisa.png'
  ),
  Rider(
      firstName: 'Douglas',
      accessibilityNeeds: ['Wheelchair'],
      phoneNumber: '',
      photoPath: 'assets/images/douglas.png'
  ),
  Rider(
      firstName: 'Victoria',
      accessibilityNeeds: ['Wheelchair'],
      phoneNumber: '',
      photoPath: 'assets/images/victoria.png'
  ),
  Rider(
      firstName: 'Nick',
      accessibilityNeeds: ['Crutches'],
      phoneNumber: '',
      photoPath: 'assets/images/nick.png'
  ),
];

final List<Ride> _sampleRides = [
  Ride(
      startLocation: "Upson Hall",
      startAddress: "124 Hoy Rd, Ithaca, NY 14850",
      endLocation: "Uris Hall",
      endAddress: "109 Tower Rd, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 9, 10),
      endTime: DateTime(2020, 1, 1, 9, 30),
      rider: _sampleRiders[0]
  ),
  Ride(
      startLocation: "Statler Hall",
      startAddress: "7 East Ave, Ithaca, NY 14850",
      endLocation: "Uris Hall",
      endAddress: "109 Tower Rd, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 9, 20),
      endTime: DateTime(2020, 1, 1, 9, 30),
      rider: _sampleRiders[1]
  ),
  Ride(
      startLocation: "310 Eddy Street",
      startAddress: "310 Eddy Street, Ithaca, NY 14850",
      endLocation: "Keeton House",
      endAddress: "4 Forest Park Lane, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 10, 0),
      endTime: DateTime(2020, 1, 1, 10, 15),
      rider: _sampleRiders[2]
  ),
  Ride(
      startLocation: "Barton Hall",
      startAddress: "117 Statler Dr, Ithaca, NY 14853",
      endLocation: "Mann Library",
      endAddress: "237 Mann Dr, Ithaca, NY 14853",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 10, 20),
      endTime: DateTime(2020, 1, 1, 10, 35),
      rider: _sampleRiders[3]
  ),
];

final List<Ride> _sampleCurrentRides = [
  _sampleRides[0],
];

// PAGES

Widget _start(OnboardingState state, BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(left: 34.0, right: 34.0, bottom: 77.0, top: 97.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/app_logo.png', width: width * 0.6, height: width * 0.6),
        SizedBox(height: 75),
        Text(
            'Welcome to Carriage',
            style: CarriageTheme.largeTitle, textAlign: TextAlign.center
        ),
        SizedBox(height: 20),
        Text(
          "Let's take a tour.",
          style: CarriageTheme.body,
        ),
        Spacer(),
        Container(
            width: double.infinity,
            child: CButton(text: "Continue", hasShadow: false, onPressed: () => state.nextStage(context))
        )
      ],

    ),
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
      )
  );
}

Widget startRideCard(OnboardingState state, BuildContext context) {
  double radius = 12;
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleRidesPage(
        firstRemainingRideRectCb: (rect) {
          piper.onCallback(rect);
        },
      ),
      radius: radius,
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: radius)
              ),
              Positioned(
                top: highlightRect.bottom,
                left: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: OnboardingBubble(
                    title: 'Easily start a ride.',
                    body: 'Tap on the ride card to get started.',
                    nipLocation: NipLocation.TOP,
                  ),
                ),
              ),
            ]
        );
      }
  );
}

Widget _sampleBeginRidePage(Ride ride, {void Function(Rect) onContinueRectChange = RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: BeginRidePage(
        ride: ride,
        onContinueRectChange: onContinueRectChange,
      )
  );
}

Widget beginRidePage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleBeginRidePage(
          _sampleRides[0],
          onContinueRectChange: (rect) {
            piper.onCallback(rect);
          }
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: 2)),
              Positioned(
                bottom: MediaQuery.of(context).size.height - highlightRect.top,
                left: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                        title: 'Begin your ride.',
                        body: 'Try it! Press on the button to begin your ride.',
                        nipLocation: NipLocation.BOTTOM
                    ),
                  ),
                ),
              ),
            ]
        );
      }
  );
}

Widget _sampleOnTheWayPage(Ride ride,
    {void Function(Rect) onContinueRectChange =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: OnTheWayPage(
        ride: _sampleRides[0],
        onContinueRectChange: onContinueRectChange,
      ));
}

Widget onTheWayPage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleOnTheWayPage(
        _sampleRides[0],
        onContinueRectChange: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: 2)),
              Positioned(
                bottom: MediaQuery.of(context).size.height - highlightRect.top,
                left: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                        title: "Let your rider know you've arrived.",
                        body: 'Try it! Press on the button to let your rider know you’ve arrived.',
                        nipLocation: NipLocation.BOTTOM
                    ),

                  ),
                ),
              ),
            ]
        );
      }
  );
}

Widget _samplePickupPage(Ride ride,
    {void Function(Rect) onContinueRectChange =
        RidesStateless.onChangeDefault, bool highlightPickUpButton, bool highlightScheduleButton}) {
  return IgnorePointer(
      child: PickUpPage(
        ride: _sampleRides[0],
        onContinueRectChange: onContinueRectChange,
        highlightPickUpButton: highlightPickUpButton,
        highlightScheduleButton: highlightScheduleButton,
      )
  );
}

Widget pickUpPage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _samplePickupPage(
          _sampleRides[0],
          onContinueRectChange: (rect) {
            piper.onCallback(rect);
          },
          highlightPickUpButton: true,
          highlightScheduleButton: false
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: 2)),
              Positioned(
                bottom: MediaQuery.of(context).size.height - highlightRect.top,
                left: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                      title: 'Update your dispatcher in real time.',
                      body: 'Try it! Press on the button to let your dispatcher know you’ve picked up the rider successfully.',
                      nipLocation: NipLocation.BOTTOM,
                    ),
                  ),
                ),
              ),
            ]
        );
      }
  );
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

Widget startRideCard2(OnboardingState state, BuildContext context) {
  double radius = 12;
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleRidesInProgressPage(
        firstRemainingRideRectCb: (rect) {
          piper.onCallback(rect);
        },
      ),
      radius: radius,
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: radius)),
              Positioned(
                bottom: MediaQuery.of(context).size.height - highlightRect.top,
                left: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                      title: 'Complete multiple rides at once.',
                      body: 'Try it! Tap to start another ride.',
                      nipLocation: NipLocation.BOTTOM,
                    ),
                  ),
                ),
              ),
            ]
        );
      }
  );
}

Widget beginRidePage2(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleBeginRidePage(
          _sampleRides[1],
          onContinueRectChange: (rect) {
            piper.onCallback(rect);
          }
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: 2)),
              Positioned(
                bottom: MediaQuery.of(context).size.height - highlightRect.top,
                left: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                        title: 'Begin another ride.',
                        body: 'Try it! Press on the button to add a new rider and complete multiple rides at once.',
                        nipLocation: NipLocation.BOTTOM
                    ),
                  ),
                ),
              ),
            ]
        );
      }
  );
}

Widget onTheWayPage2(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleOnTheWayPage(
        _sampleRides[0],
        onContinueRectChange: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: 2)),
              Positioned(
                bottom: MediaQuery.of(context).size.height - highlightRect.top,
                left: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                        title: "Let your rider know you've arrived.",
                        body: 'Try it! Press on the button to let your rider know you’ve arrived.',
                        nipLocation: NipLocation.BOTTOM
                    ),
                  ),
                ),
              ),
            ]
        );
      }
  );
}

Widget checkYourSchedule(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _samplePickupPage(
          _sampleRides[0],
          onContinueRectChange: (rect) {
            piper.onCallback(rect);
          },
          highlightPickUpButton: false,
          highlightScheduleButton: true
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(
            children: [
              RectPositioned(
                  rect: highlightRect,
                  child: highlightRegion(state, context, radius: 2)
              ),
              Positioned(
                top: highlightRect.bottom + 8,
                right: 8,
                child: Container(
                    width: 32,
                    child: SpeechBubble(
                        color: highlightColor,
                        borderRadius: 11,
                        nipLocation: NipLocation.TOP,
                        child: Container()
                    )
                ),
              ),
              Positioned(
                top: highlightRect.bottom + 8,
                right: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: OnboardingBubble(
                    title: 'Check your schedule',
                    body: 'Try it! Tap to check your schedule mid ride flow.',
                  ),
                ),
              ),
            ]
        );
      }
  );
}

List<Widget Function(OnboardingState state, BuildContext context)>
stageBuilders = [
  _start,
//  startRideCard,
//  beginRidePage,
//  onTheWayPage,
//  pickUpPage,
//  startRideCard2,
//  beginRidePage2,
//  onTheWayPage2,
  checkYourSchedule,
];
