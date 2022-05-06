import 'package:flutter/material.dart';
import '../utils/CarriageTheme.dart';
import '../models/Ride.dart';
import 'RideDestPickupCard.dart';

class RideInfoCard extends StatelessWidget {
  final Ride ride;

  ///Whether this card shows a ride dropoff
  final bool dropoff;

  RideInfoCard(this.ride, this.dropoff);

  Widget _picAndName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: Column(children: <Widget>[
          ride.rider.profilePicture(100),
          SizedBox(height: 16),
          Text(ride.rider.firstName, style: CarriageTheme.largeTitle),
          ride.rider.accessibilityNeeds.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(ride.rider.accessibilityNeeds,
                      style: CarriageTheme.body),
                )
              : Container()
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
            RideDestPickupCard(
                dropoff,
                dropoff ? ride.endTime : ride.startTime,
                dropoff ? ride.endLocation : ride.startLocation,
                dropoff ? ride.endAddress : ride.startAddress)
          ]),
    );
  }
}
