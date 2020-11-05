import 'package:bubble/bubble.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/Rider.dart';
import 'package:carriage/Rides.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:flutter/material.dart';

final Color _highlight = Color(0xFF1AA0EB);

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
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
        width: 169,
        height: 109,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 9)),
        ]),
        child: Bubble(
            color: _highlight,
            nip: BubbleNip.no,
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            children: [
                          TextSpan(text: "Try it "),
                          TextSpan(text: down ? "👇" : "☝️")
                        ])),
                    Text(text, style: TextStyle(color: Colors.white))
                  ]),
            )));
  }
}

class CarProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      color: Colors.black,
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
                CarProgressBar()
              ]),
        ));
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
      children: [
        child,
        Opacity(opacity: 0.5, child: Container(color: Colors.black)),
        overlay
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
  Rider(firstName: "James", lastName: "Lee", accessibilityNeeds: ["Wheelchair"])
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
      rider: _sampleRiders[0]),
];

Widget _sampleRidesPage() {
  return RidesStateless(rides: _sampleRides);
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

class OnboardingState extends State<Onboarding> {
  int stage = 0;

  final List<Widget Function(OnboardingState state, BuildContext context)>
      stageBuilders = [_startPage, _ridesIntro, _startPage];

  void nextStage(BuildContext context) {
    if (stage + 1 < stageBuilders.length)
      setState(() => ++stage);
    else {
      // TODO: THIS COMMIT continue to home
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: stageBuilders[stage](this, context));
  }
}
