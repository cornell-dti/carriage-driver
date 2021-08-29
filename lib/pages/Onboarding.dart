import 'package:flutter/material.dart';

import 'OnboardingStages.dart';

// See OnboardingStages.dart for dummy pages used for each stage
// OnboardingWidgets.dart for widgets

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
  }
}

class OnboardingState extends State<Onboarding> {
  int stage = 0;

  void nextStage(BuildContext context) {
    if (stage + 1 < stageBuilders.length){
      setState(() => ++stage);
    }
    else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: stageBuilders[stage](this, context));
  }
}
