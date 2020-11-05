import 'package:flutter/material.dart';
import 'RideDestPickupCard.dart';

class RideInfoCard extends StatelessWidget {
  final String _firstName;
  final ImageProvider<dynamic> _photo;
  ///Whether this card shows a ride dropoff
  final bool _dropoff;
  final DateTime _time;
  final String _stop;
  final String _address;

  RideInfoCard(this._firstName, this._photo, this._dropoff, this._stop,
      this._address, this._time);

  Widget _picAndName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: Column(children: <Widget>[
          CircleAvatar(
            radius: 60.5,
            backgroundImage: _photo,
          ),
          SizedBox(height: 14),
          Text(_firstName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _picAndName(context),
            RideDestPickupCard(_dropoff, _time, _stop, _address)
          ]),
    );
  }
}
