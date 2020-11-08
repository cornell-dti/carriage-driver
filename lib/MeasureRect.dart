// Source: https://stackoverflow.com/questions/49307677/how-to-get-a-height-of-a-widget

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef void OnWidgetRectChange(Rect rect);

class MeasureRect extends StatefulWidget {
  final Widget child;
  final OnWidgetRectChange onChange;

  const MeasureRect({
    Key key,
    @required this.onChange,
    @required this.child,
  }) : super(key: key);

  @override
  _MeasureRectState createState() => _MeasureRectState();
}

class _MeasureRectState extends State<MeasureRect> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldRect;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    final RenderBox renderBox = context.findRenderObject();

    final sz = renderBox.size;
    final pos = renderBox.localToGlobal(Offset.zero);
    final newRect = Rect.fromLTRB(
      pos.dx,
      pos.dy,
      pos.dx + sz.width,
      pos.dy + sz.height,
    );
    if (oldRect == newRect) return;
    oldRect = newRect;
    widget.onChange(newRect);
  }
}
