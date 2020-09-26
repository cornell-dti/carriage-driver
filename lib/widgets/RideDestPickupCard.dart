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
      width: 295,
      height: 110,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_stop),
                    Text(
                      _address,
                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                ),
                Text(
                    "${_dropoff ? "Drop off time" : "Pick up time"}: ${DateFormat.jm().format(_time)}",
                    style: TextStyle(fontSize: 13))
              ]),
        ),
      ),
    );
  }
}
