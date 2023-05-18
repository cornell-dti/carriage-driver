import 'package:carriage/pages/Onboarding.dart';
import 'package:carriage/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:speech_bubble/speech_bubble.dart';

final Color highlightColor = Color.fromRGBO(26, 160, 235, 1);
final Color overlayColor = Colors.black.withAlpha(128);

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
  final String title;
  final String body;
  final NipLocation nipLocation;

  static double borderRadius = 11;

  const OnboardingBubble(
      {Key key, @required this.title, @required this.body, this.nipLocation})
      : super(key: key);

  Widget _inner() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: CarriageTheme.title3.copyWith(color: Colors.white)),
              SizedBox(height: 16),
              Text(body, style: TextStyle(fontSize: 15, color: Colors.white))
            ]));
  }

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
        child: nipLocation == null
            ? Container(
                decoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: BorderRadius.circular(borderRadius)),
                child: _inner())
            : SpeechBubble(
                color: highlightColor,
                borderRadius: borderRadius,
                nipLocation: nipLocation,
                child: _inner()));
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

class OnboardingOverlay extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Rect highlightRect)
      overlayBuilder;
  final double radius;
  final CallbackPiper<Rect> highlightPiper;
  final bool noButton;

  const OnboardingOverlay(
      {Key key,
      this.overlayBuilder,
      this.child,
      this.highlightPiper,
      this.radius = 5,
      this.noButton = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OnboardingOverlayState();
  }
}

class OnboardingOverlayState extends State<OnboardingOverlay> {
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
  void didUpdateWidget(OnboardingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    highlightRect = Rect.largest;
    widget.highlightPiper.onCallback = (rect) {
      setRect(rect);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: widget.noButton || highlightRect != Rect.largest
                ? widget.overlayBuilder(context, highlightRect)
                : SizedBox())
      ],
    );
  }
}

Widget highlightRegion(OnboardingState state, BuildContext context,
    {double radius = 3, bool hide = false}) {
  return GestureDetector(
    onTap: () => state.nextStage(context),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: hide ? Colors.transparent : highlightColor, width: 4),
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
