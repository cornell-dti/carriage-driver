import 'package:flutter/material.dart';
import '../Ride.dart';
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
          CircleAvatar(
            radius: 50,
            //TODO: replace with rider image
            backgroundImage: AssetImage('assets/images/terry.jpg'),
          ),
          SizedBox(height: 14),
          Text(ride.rider.firstName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
          ),
          ride.rider.accessibilityNeeds.length > 0 ?
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(ride.rider.accessibilityNeeds.join(', '),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: -0.41)),
          ) : Container()
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
                dropoff, dropoff ? ride.endTime : ride.startTime,
                dropoff ? ride.endLocation : ride.startLocation,
                dropoff ? ride.endAddress : ride.startAddress
            )
          ]),
    );
  }
}
