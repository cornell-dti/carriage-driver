import 'package:flutter/material.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/placeholder.png'),
                    fit: BoxFit.cover))));
  }
}
