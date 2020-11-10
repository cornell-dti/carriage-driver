import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/Rider.dart';
import 'package:carriage/Rides.dart';
import 'package:carriage/RidesInProgress.dart';
import 'package:carriage/pages/BeginRidePage.dart';
import 'package:carriage/pages/OnTheWayPage.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:flutter/material.dart';

final Color _highlightColor = Color(0xFF1AA0EB);
final Color _overlayColor = Colors.transparent;

class RectPositioned extends StatelessWidget {
  final Rect rect;
  final Widget child;

  const RectPositioned({Key key, this.rect, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: rect.top,
        left: rect.left,
        width: rect.width,
        height: rect.height,
        child: child);
  }
}

class OnboardingBubble extends StatelessWidget {
  final Widget heading;
  final String text;

  const OnboardingBubble({Key key, @required this.text, @required this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 9)),
        ]),
        child: Bubble(
            color: _highlightColor,
            nip: BubbleNip.no,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 11),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    heading,
                    SizedBox(height: 3),
                    Text(text,
                        style: TextStyle(fontSize: 14, color: Colors.white))
                  ]),
            )));
  }
}

class TryItBubble extends StatelessWidget {
  final String text;
  final bool down;

  const TryItBubble({Key key, @required this.text, @required this.down})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingBubble(
        heading: RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                children: [
              TextSpan(text: "Try it "),
              TextSpan(text: down ? "👇" : "☝️")
            ])),
        text: text);
  }
}

class CarProgressBar extends StatelessWidget {
  final double progress;

  const CarProgressBar({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Color(0xFFDCDCDC),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    );
  }
}

class OnboardingSheet extends StatelessWidget {
  final String headingText;
  final String bodyText;
  final double progress;
  final OnboardingState state;

  const OnboardingSheet(this.state,
      {Key key, this.headingText, this.bodyText, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        height: 350,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 34.0, right: 34.0, bottom: 30.0, top: 35.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headingText,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      bodyText,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                CButton(
                    text: "Continue",
                    onPressed: () => state.nextStage(context)),
                CarProgressBar(progress: progress)
              ]),
        ));
  }
}

///Triggers another callback when a callback is triggered
class CallbackPiper<T> {
  void Function(T) onCallback;
  static void pass(_) {}
  CallbackPiper({this.onCallback = pass});
  void trigger(T data) {
    onCallback(data);
  }
}

class Overlay extends StatelessWidget {
  final Widget child;
  final Widget overlay;

  const Overlay({Key key, this.overlay, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [child, Container(color: _overlayColor), overlay],
    );
  }
}

class OverlayWithHighlight extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Rect highlightRect)
      overlayBuilder;
  final CallbackPiper<Rect> highlightPiper;

  const OverlayWithHighlight(
      {Key key, this.overlayBuilder, this.child, this.highlightPiper})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OverlayWithHighlightState();
  }
}

class OverlayWithHighlightState extends State<OverlayWithHighlight> {
  Rect highlightRect = Rect.largest;

  void setRect(Rect s) {
    setState(() {
      highlightRect = s;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.highlightPiper.onCallback = (rect) {
      setRect(rect);
    };
  }

  @override
  void didUpdateWidget(OverlayWithHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    highlightRect = Rect.largest;
    widget.highlightPiper.onCallback = (rect) {
      setRect(rect);
    };
  }

  Widget _overlay() {
    return ColorFiltered(
        colorFilter: ColorFilter.mode(_overlayColor, BlendMode.srcOut),
        child: Stack(children: [
          Container(decoration: BoxDecoration(color: Colors.transparent)),
          Positioned(
              top: highlightRect.top,
              left: highlightRect.left,
              width: highlightRect.width,
              height: highlightRect.height,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: _highlightColor, width: 10),
                    borderRadius: BorderRadius.circular(5)),
              )),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _overlay(),
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: highlightRect != Rect.largest
                ? widget.overlayBuilder(context, highlightRect)
                : SizedBox())
      ],
    );
  }
}

/* ONBOARDING PAGES */

Widget _startPage(OnboardingState state, BuildContext context) {
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

final List<Rider> _sampleRiders = [
  Rider(
      firstName: "Alex",
      lastName: "Mcgregor",
      accessibilityNeeds: ["Crutches"]),
  Rider(
      firstName: "James", lastName: "Lee", accessibilityNeeds: ["Wheelchair"]),
  Rider(firstName: "Alex", lastName: "Mcgregor", accessibilityNeeds: [])
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

Widget _sampleRidesPage(
    {void Function(Rect) onFirstRideRectChange =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: RidesStateless(
    rides: _sampleRides,
    onFirstRideRectChange: onFirstRideRectChange,
  ));
}

Widget _highlightRegion(OnboardingState state, BuildContext context,
    {double radius = 5}) {
  return GestureDetector(
    onTap: () => state.nextStage(context),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: _highlightColor, width: 4),
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

Widget _ridesTryIt(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _sampleRidesPage(
        onFirstRideRectChange: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect, child: _highlightRegion(state, context)),
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

Widget _beginRideIntro(OnboardingState state, BuildContext context) {
  return GestureDetector(
    onTap: () => state.nextStage(context),
    child: Overlay(
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
              child: _highlightRegion(state, context, radius: 2)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.top - 100)),
            child: Row(children: [
              Expanded(flex: 1, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 220,
                  height: 82,
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
              child: _highlightRegion(state, context, radius: 2)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.top - 100)),
            child: Row(children: [
              Expanded(flex: 3, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 221,
                  height: 87,
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

Widget _sampleRidesInProgressPage(
    {void Function(Rect) onFirstRideRectChanged =
        RidesStateless.onChangeDefault}) {
  return IgnorePointer(
      child: RidesInProgressPageStateless(
    currentRides: _sampleRides,
    remainingRides: _sampleRides,
    selectedRides: [],
    onFirstRideRectChange: onFirstRideRectChanged,
  ));
}

Widget _ridesInProgressIntro(OnboardingState state, BuildContext context) {
  return GestureDetector(
    onTap: () => state.nextStage(context),
    child: Overlay(
      child: _sampleRidesInProgressPage(),
      overlay: Align(
        alignment:
            Alignment.lerp(Alignment.center, Alignment.bottomRight, 0.85),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              height: 80,
              child: OnboardingBubble(
                heading: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        children: [
                      TextSpan(text: "View your current rides. "),
                      TextSpan(text: "🚗")
                    ])),
                text: "Manage multiple rides at once.",
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _ridesInProgressTryIt(OnboardingState state, BuildContext context) {
  final piper = CallbackPiper<Rect>();
  return OverlayWithHighlight(
      highlightPiper: piper,
      child: _sampleRidesInProgressPage(
        onFirstRideRectChanged: (rect) {
          piper.onCallback(rect);
        },
      ),
      overlayBuilder: (context, highlightRect) {
        return Stack(children: [
          RectPositioned(
              rect: highlightRect,
              child: _highlightRegion(state, context, radius: 2)),
          Padding(
            padding: EdgeInsets.only(top: max(0, highlightRect.bottom)),
            child: Row(children: [
              Expanded(flex: 1, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 221,
                  height: 87,
                  child: TryItBubble(
                      text: "Click on a ride card to drop riders off.",
                      down: false),
                ),
              ),
              Expanded(flex: 5, child: SizedBox())
            ]),
          ),
        ]);
      });
}

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
  }
}

class OnboardingState extends State<Onboarding> {
  int stage = 0;

  static List<Widget Function(OnboardingState state, BuildContext context)>
      stageBuilders = [
    _startPage,
    _ridesTryIt,
    _beginRideIntro,
    _beginRideTryIt,
    _onTheWayTryIt,
    _ridesInProgressIntro,
    _ridesInProgressTryIt
  ];

  void nextStage(BuildContext context) {
    if (stage + 1 < stageBuilders.length)
      setState(() => ++stage);
    else {
      // TODO: continue to home
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: stageBuilders[stage](this, context));
  }
}
