import 'package:bubble/bubble.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:flutter/material.dart';

final Color highlight = Color(0xFF1AA0EB);

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
            color: highlight,
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

class OnboardingState extends State<Onboarding> {
  int stage = 0;

  final List<Widget Function(OnboardingState state, BuildContext context)>
      stageBuilders = [startPage];

  void nextStage(BuildContext context) {
    if (stage + 1 < stageBuilders.length)
      setState(() => ++stage);
    else {
      // TODO: THIS COMMIT continue to home
      Navigator.pop(context);
    }
  }

  static Widget startPage(OnboardingState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 34.0, right: 34.0, bottom: 77.0, top: 97.0),
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

  @override
  Widget build(BuildContext context) {
    return Material(child: stageBuilders[stage](this, context));
  }
}
