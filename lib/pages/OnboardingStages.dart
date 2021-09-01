import 'package:carriage/pages/Home.dart';
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
      photoPath: 'assets/images/marisa.png'),
  Rider(
      firstName: 'Douglas',
      accessibilityNeeds: ['Wheelchair'],
      phoneNumber: '',
      photoPath: 'assets/images/douglas.png'),
  Rider(
      firstName: 'Victoria',
      accessibilityNeeds: ['Wheelchair'],
      phoneNumber: '',
      photoPath: 'assets/images/victoria.png'),
  Rider(
      firstName: 'Nick',
      accessibilityNeeds: ['Crutches'],
      phoneNumber: '',
      photoPath: 'assets/images/nick.png'),
  Rider(
      firstName: 'Alex',
      accessibilityNeeds: ['Wheelchair'],
      phoneNumber: '',
      photoPath: 'assets/images/alex.png'),
  Rider(
      firstName: 'Luke',
      accessibilityNeeds: ['Crutches'],
      phoneNumber: '',
      photoPath: 'assets/images/luke.png'),
];

final List<Ride> _sampleRides = [
  Ride(
      id: 'sample0',
      startLocation: "Upson Hall",
      startAddress: "124 Hoy Rd, Ithaca, NY 14850",
      endLocation: "Uris Hall",
      endAddress: "109 Tower Rd, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 9, 10),
      endTime: DateTime(2020, 1, 1, 9, 30),
      rider: _sampleRiders[0]),
  Ride(
      id: 'sample1',
      startLocation: "Statler Hall",
      startAddress: "7 East Ave, Ithaca, NY 14850",
      endLocation: "Uris Hall",
      endAddress: "109 Tower Rd, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 9, 20),
      endTime: DateTime(2020, 1, 1, 9, 30),
      rider: _sampleRiders[1]),
  Ride(
      id: 'sample2',
      startLocation: "310 Eddy Street",
      startAddress: "310 Eddy Street, Ithaca, NY 14850",
      endLocation: "Keeton House",
      endAddress: "4 Forest Park Lane, Ithaca, NY 14850",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 10, 0),
      endTime: DateTime(2020, 1, 1, 10, 15),
      rider: _sampleRiders[2]),
  Ride(
      id: 'sample3',
      startLocation: "Barton Hall",
      startAddress: "117 Statler Dr, Ithaca, NY 14853",
      endLocation: "Mann Library",
      endAddress: "237 Mann Dr, Ithaca, NY 14853",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 10, 20),
      endTime: DateTime(2020, 1, 1, 10, 35),
      rider: _sampleRiders[3]),
  Ride(
      id: 'sample4',
      startLocation: "Keeton House",
      startAddress: "4 Forest Park Lane, Ithaca, NY 14850",
      endLocation: "Duffield Hall",
      endAddress: "343 Campus Rd, Ithaca, NY 14853",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 9, 30),
      endTime: DateTime(2020, 1, 1, 9, 45),
      rider: _sampleRiders[4]),
  Ride(
      id: 'sample5',
      startLocation: "Keeton House",
      startAddress: "4 Forest Park Lane, Ithaca, NY 14850",
      endLocation: "Duffield Hall",
      endAddress: "343 Campus Rd, Ithaca, NY 14853",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 9, 30),
      endTime: DateTime(2020, 1, 1, 9, 45),
      rider: _sampleRiders[5]),
];

// PAGES

Widget _start(OnboardingState state, BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Padding(
    padding: EdgeInsets.only(left: 34.0, right: 34.0, top: height * 0.2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/carScene.png',
            width: width * 0.6, height: width * 0.6),
        SizedBox(height: height * 0.01),
        Text('Welcome to Carriage',
            style: CarriageTheme.largeTitle, textAlign: TextAlign.center),
        SizedBox(height: height * 0.01),
        Text(
          "Let's take a tour.",
          style: CarriageTheme.body,
        ),
        Spacer(),
        Container(
            width: double.infinity,
            child: CButton(
                text: "Continue",
                hasShadow: true,
                onPressed: () => state.nextStage(context))),
        SizedBox(height: height * 0.05),
      ],
    ),
  );
}

Widget startRideCard(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child:
          _sampleHomePage(_sampleRides.sublist(0, 2), [], [], callback: (rect) {
        piper.onCallback(rect);
      }, remaining: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect, child: highlightRegion(state, context)),
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
        ]);
      });
}

Widget _sampleBeginRidePage(Ride ride,
    {void Function(Rect) onContinueRectChange =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: BeginRidePage(
    ride: ride,
    onContinueRectChange: onContinueRectChange,
  ));
}

Widget beginRidePage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child:
          _sampleBeginRidePage(_sampleRides[0], onContinueRectChange: (rect) {
        piper.onCallback(rect);
      }),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
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
                    nipLocation: NipLocation.BOTTOM),
              ),
            ),
          ),
        ]);
      });
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
        return Stack(children: [
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
                    body:
                        'Try it! Press on the button to let your rider know you’ve arrived.',
                    nipLocation: NipLocation.BOTTOM),
              ),
            ),
          ),
        ]);
      });
}

Widget _samplePickupPage(Ride ride,
    {void Function(Rect) onContinueRectChange = RidesStateless.onChangeDefault,
    bool highlightPickUpButton,
    bool highlightScheduleButton}) {
  return IgnorePointer(
      child: PickUpPage(
    ride: ride,
    onContinueRectChange: onContinueRectChange,
    highlightPickUpButton: highlightPickUpButton,
    highlightScheduleButton: highlightScheduleButton,
  ));
}

Widget pickUpPage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _samplePickupPage(_sampleRides[0], onContinueRectChange: (rect) {
        piper.onCallback(rect);
      }, highlightPickUpButton: true, highlightScheduleButton: false),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
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
                  body:
                      'Try it! Press on the button to let your dispatcher know you’ve picked up the rider successfully.',
                  nipLocation: NipLocation.BOTTOM,
                ),
              ),
            ),
          ),
        ]);
      });
}

Widget _sampleHomePage(List<Ride> remainingRides, List<Ride> currentRides,
    List<String> selectedRideIDs,
    {void Function(Rect) callback = RidesStateless.onChangeDefault,
    bool remaining = false,
    bool firstCurrent = false,
    bool secondCurrent = false,
    bool carButton = false,
    bool dropOffButton = false}) {
  return IgnorePointer(
      child: RidesStateless(
    remainingRides: remainingRides,
    currentRides: currentRides,
    selectedRideIDs: selectedRideIDs,
    firstRemainingRideRectCb: callback,
    firstCurrentRideRectCb: callback,
    secondCurrentRideRectCb: callback,
    carButtonRectCb: callback,
    dropOffButtonRectCb: callback,
    highlightRemainingRide: remaining,
    highlightFirstCurrentRide: firstCurrent,
    highlightSecondCurrentRide: secondCurrent,
    highlightCarButton: carButton,
    highlightDropOffButton: dropOffButton,
  ));
}

Widget startRideCard2(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleHomePage([_sampleRides[1]], [_sampleRides[0]], [],
          callback: (rect) {
        piper.onCallback(rect);
      }, remaining: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect, child: highlightRegion(state, context)),
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
        ]);
      });
}

Widget beginRidePage2(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child:
          _sampleBeginRidePage(_sampleRides[1], onContinueRectChange: (rect) {
        piper.onCallback(rect);
      }),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
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
                    body:
                        'Try it! Press on the button to add a new rider and complete multiple rides at once.',
                    nipLocation: NipLocation.BOTTOM),
              ),
            ),
          ),
        ]);
      });
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
        return Stack(children: [
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
                    body:
                        'Try it! Press on the button to let your rider know you’ve arrived.',
                    nipLocation: NipLocation.BOTTOM),
              ),
            ),
          ),
        ]);
      });
}

Widget checkYourSchedule(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _samplePickupPage(_sampleRides[0], onContinueRectChange: (rect) {
        piper.onCallback(rect);
      }, highlightPickUpButton: false, highlightScheduleButton: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, hide: true)),
          Positioned(
            top: highlightRect.bottom + 8,
            right: 8,
            child: Container(
                width: 32,
                child: SpeechBubble(
                    color: highlightColor,
                    borderRadius: 11,
                    nipLocation: NipLocation.TOP,
                    child: Container())),
          ),
          Positioned(
            top: highlightRect.bottom + 8,
            right: 8,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: OnboardingBubble(
                title: 'Check your schedule',
                body:
                    'Try it! Tap to check your schedule while completing a ride.',
              ),
            ),
          ),
        ]);
      });
}

Widget _sampleSchedulePage(
    {void Function(Rect) carButtonRectCb = RidesStateless.onChangeDefault,
    bool highlightCarButton}) {
  return IgnorePointer(
      child: RidesStateless(
    remainingRides: _sampleRides.sublist(2, 4),
    currentRides: [],
    selectedRideIDs: [],
    carButtonRectCb: carButtonRectCb,
    interactive: false,
    highlightRemainingRide: false,
    highlightFirstCurrentRide: false,
    highlightCarButton: highlightCarButton,
  ));
}

Widget viewSchedulePage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      noButton: true,
      child: _sampleSchedulePage(
          carButtonRectCb: (rect) {
            piper.onCallback(rect);
          },
          highlightCarButton: false),
      overlayBuilder: (context, highlightRect) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(children: [
                      OnboardingBubble(
                        title: 'View Schedule',
                        body:
                            'Check your schedule to make sure you are on track!',
                      ),
                      SizedBox(height: 16),
                      CButton(
                          text: 'Next',
                          hasShadow: false,
                          onPressed: () {
                            state.nextStage(context);
                          })
                    ])),
              ],
            ),
          ),
        );
      });
}

Widget scheduleButtonPage(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleSchedulePage(
          carButtonRectCb: (rect) {
            piper.onCallback(rect);
          },
          highlightCarButton: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: highlightRegion(state, context, hide: true)),
          Positioned(
            top: highlightRect.bottom + 8,
            right: 12,
            child: Container(
                width: 32,
                child: SpeechBubble(
                    color: highlightColor,
                    borderRadius: 11,
                    nipLocation: NipLocation.TOP,
                    child: Container())),
          ),
          FutureBuilder(
              future: Future.delayed(Duration(seconds: 2)),
              builder: (context, snapshot) {
                return Positioned(
                  top: highlightRect.bottom + 8,
                  right: 12,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: OnboardingBubble(
                      title: 'Return to your current ride.',
                      body:
                          'Try it! Tap to return to the ride you were completing.',
                    ),
                  ),
                );
              }),
        ]);
      });
}

Widget pickUpPage2(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _samplePickupPage(_sampleRides[1], onContinueRectChange: (rect) {
        piper.onCallback(rect);
      }, highlightPickUpButton: true, highlightScheduleButton: false),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
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
                  body:
                      'Try it! Press on the button to let your dispatcher know you’ve picked up the rider successfully.',
                  nipLocation: NipLocation.BOTTOM,
                ),
              ),
            ),
          ),
        ]);
      });
}

Widget selectFirstCurrent(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleHomePage(
          _sampleRides.sublist(2, 4), _sampleRides.sublist(0, 2), [],
          callback: (rect) {
        piper.onCallback(rect);
      }, firstCurrent: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect, child: highlightRegion(state, context)),
          Positioned(
            top: highlightRect.bottom,
            left: 64,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                  width: 32,
                  child: SpeechBubble(
                      color: highlightColor,
                      borderRadius: 11,
                      nipLocation: NipLocation.TOP,
                      child: Container())),
            ),
          ),
          Positioned(
            top: highlightRect.bottom,
            left: 8,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: OnboardingBubble(
                  title: 'Select a rider to drop off.',
                  body:
                      "Try it! Tap when you have reached the drop off location and it's time to drop off your rider.",
                ),
              ),
            ),
          ),
        ]);
      });
}

Widget selectSecondCurrent(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleHomePage(_sampleRides.sublist(2, 4),
          _sampleRides.sublist(0, 2), [_sampleRides[0].id], callback: (rect) {
        piper.onCallback(rect);
      }, secondCurrent: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect, child: highlightRegion(state, context)),
          Positioned(
            top: highlightRect.bottom,
            right: 64,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                  width: 32,
                  child: SpeechBubble(
                      color: highlightColor,
                      borderRadius: 11,
                      nipLocation: NipLocation.TOP,
                      child: Container())),
            ),
          ),
          Positioned(
            top: highlightRect.bottom,
            right: 8,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: OnboardingBubble(
                  title: 'Choose multiple riders.',
                  body:
                      'Try it! Tap to choose the second rider you are dropping off.',
                ),
              ),
            ),
          ),
        ]);
      });
}

Widget dropOffRiders(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      highlightPiper: piper,
      child: _sampleHomePage(
          _sampleRides.sublist(2, 4),
          _sampleRides.sublist(0, 2),
          _sampleRides.sublist(0, 2).map((Ride r) => r.id).toList(),
          callback: (rect) {
        piper.onCallback(rect);
      }, dropOffButton: true),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect, child: highlightRegion(state, context)),
          Positioned(
            bottom: MediaQuery.of(context).size.height - highlightRect.top,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: OnboardingBubble(
                  title: 'Drop off riders.',
                  body: 'Try it! Tap to drop off the selected passengers.',
                  nipLocation: NipLocation.BOTTOM,
                ),
              ),
            ),
          ),
        ]);
      });
}

Widget pullToRefresh(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return RefreshIndicator(
    onRefresh: () async {
      await Future(() => state.nextStage(context));
    },
    child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: OnboardingOverlay(
          noButton: true,
          highlightPiper: piper,
          child: _sampleHomePage(
            _sampleRides.sublist(2, 4),
            [],
            [],
            callback: (rect) {
              piper.onCallback(rect);
            },
          ),
          overlayBuilder: (context, highlightRect) {
            return Stack(children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 64),
                    child: Image.asset('assets/images/refreshArrow.png',
                        height: MediaQuery.of(context).size.height * 0.25),
                  )),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: OnboardingBubble(
                    title: 'Pull to refresh.',
                    body:
                        'Try it! Pull downward on the screen and release to refresh and update your schedule.',
                  ),
                ),
              ),
            ]);
          }),
    ),
  );
}

Widget refreshed(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OnboardingOverlay(
      noButton: true,
      highlightPiper: piper,
      child: _sampleHomePage(
        [_sampleRides[4], _sampleRides[5], _sampleRides[3]],
        [],
        [],
        callback: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return FutureBuilder(
            future: Future.delayed(Duration(seconds: 2)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Column(children: [
                              OnboardingBubble(
                                title: "That's all!",
                                body: "You're ready to start using Carriage!",
                              ),
                              SizedBox(height: 16),
                              CButton(
                                  text: 'Start',
                                  hasShadow: false,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home()));
                                  })
                            ])),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            });
      });
}

List<Widget Function(OnboardingState state, BuildContext context)>
    stageBuilders = [
  _start,
  startRideCard,
  beginRidePage,
  onTheWayPage,
  pickUpPage,
  startRideCard2,
  beginRidePage2,
  onTheWayPage2,
  checkYourSchedule,
  viewSchedulePage,
  scheduleButtonPage,
  pickUpPage2,
  selectFirstCurrent,
  selectSecondCurrent,
  dropOffRiders,
  pullToRefresh,
  refreshed
];
