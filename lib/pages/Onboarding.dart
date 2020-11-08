import 'package:bubble/bubble.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/Rider.dart';
import 'package:carriage/Rides.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:flutter/material.dart';

final Color _highlightColor = Color(0xFF1AA0EB);

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
  }
}

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

class TryItBubble extends StatelessWidget {
  final String text;
  final bool down;

  const TryItBubble({Key key, @required this.text, @required this.down})
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
              padding: const EdgeInsets.only(left: 13, right: 13, top: 11),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            children: [
                          TextSpan(text: "Try it "),
                          TextSpan(text: down ? "👇" : "☝️")
                        ])),
                    SizedBox(height: 3),
                    Text(text,
                        style: TextStyle(fontSize: 14, color: Colors.white))
                  ]),
            )));
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
                CarProgressBar(progress: 0.44)
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
      children: [child, Container(color: Colors.black54), overlay],
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
    final state = OverlayWithHighlightState();
    highlightPiper.onCallback = (rect) {
      state.setRect(rect);
    };
    return state;
  }
}

class OverlayWithHighlightState extends State<OverlayWithHighlight> {
  Rect highlightRect = Rect.zero;

  void setRect(Rect s) {
    setState(() {
      highlightRect = s;
    });
  }

  Widget _overlay() {
    return ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcOut),
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
            child: widget.overlayBuilder(context, highlightRect))
      ],
    );
  }
}

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
      endLocation: "Teagle Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 15),
      rider: _sampleRiders[0]),
  Ride(
      startLocation: "Low Rise 7",
      endLocation: "Teagle Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 30),
      rider: _sampleRiders[1]),
  Ride(
      startLocation: "RPCC",
      endLocation: "Upson Hall",
      status: RideStatus.NOT_STARTED,
      startTime: DateTime(2020, 1, 1, 21, 50),
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

Widget _ridesIntro(OnboardingState state, BuildContext context) {
  return Overlay(
    child: _sampleRidesPage(),
    overlay: OnboardingSheet(
      state,
      headingText: "View your schedule with ease",
      bodyText: "Your personalized rides for the day are organized by time.",
    ),
  );
}

Widget _highlightRegion(OnboardingState state, BuildContext context) {
  return GestureDetector(
    onTap: () => state.nextStage(context),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: _highlightColor, width: 4),
        borderRadius: BorderRadius.circular(5),
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

class OnboardingState extends State<Onboarding> {
  int stage = 0;

  final List<Widget Function(OnboardingState state, BuildContext context)>
      stageBuilders = [_startPage, _ridesIntro, _ridesTryIt];

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
