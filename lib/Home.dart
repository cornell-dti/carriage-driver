import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Upcoming.dart';
import 'Map.dart';

class Home extends StatelessWidget {
  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carriage'),
      ),
      body: SlidingUpPanel(
          minHeight: 62.0,
          panelSnapping: false,
          panel: Upcoming(),
          body: Map(),
          borderRadius: radius),
    );
  }
}
