import 'package:carriage/providers/LocationsProvider.dart';
import 'package:provider/provider.dart';

import '../utils/CarriageTheme.dart';
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
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context, listen: false);
    bool showAddress = !locationsProvider.isPreset(_stop);

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
                Text(_stop, style: CarriageTheme.subheadline),
                showAddress ? Text(_address, style: CarriageTheme.subheadline.copyWith(color: CarriageTheme.gray3)) : Container(),
                SizedBox(height: showAddress ? 24 : 8),
                Text(
                    "${_dropoff ? "Drop off time" : "Pick up time"}: ${DateFormat.jm().format(_time)}",
                    style: CarriageTheme.caption1.copyWith(color: CarriageTheme.gray1))
              ]),
        ),
      ),
    );
  }
}
