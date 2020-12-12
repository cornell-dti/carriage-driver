import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideDestPickupCard extends StatelessWidget {
  // otherwise pickup
  final bool _dropoff;
  final DateTime _time;
  final String _stop;
  final String _address;

  RideDestPickupCard(this._dropoff, this._time, this._stop, this._address);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 9)),
            ]),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_stop, style: TextStyle(fontSize: 17, letterSpacing: -0.41, fontWeight: FontWeight.w400)),
                Text(
                    _address,
                    style: TextStyle(color: Color(0xFFA7A7A7), fontSize: 17, letterSpacing: -0.41, fontWeight: FontWeight.w400)
                ),
                SizedBox(height: 24),
                Text(
                    "${_dropoff ? "Drop off time" : "Pick up time"}: ${DateFormat.jm().format(_time)}",
                    style: TextStyle(fontSize: 13))
              ]),
        ),
      ),
    );
  }
}
