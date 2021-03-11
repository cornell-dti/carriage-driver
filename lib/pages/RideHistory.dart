import '../utils/CarriageTheme.dart';
import '../models/Ride.dart';
import '../pages/Rides.dart';
import '../providers/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class RideHistory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);

    List<Ride> pastRides = ridesProvider.pastRides;
    Map<int, List<Ride>> rideGroups = Map();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    for (Ride ride in pastRides) {
      DateTime rideDate = DateTime(ride.startTime.year, ride.startTime.month, ride.startTime.day);
      int daysAgo = today.difference(rideDate).inDays;
      if (rideGroups.containsKey(daysAgo)) {
        rideGroups[daysAgo].add(ride);
      }
      else {
        rideGroups[daysAgo] = [ride];
      }
    }
    List<int> days = rideGroups.keys.toList()..sort((a, b) => a - b);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
              child: Text('History', style: CarriageTheme.largeTitle),
            ),
            SizedBox(height: 22),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: days.length,
              itemBuilder: (context, index) {
                int daysAgo = days[index];
                return PastRideGroup(
                    rideGroups[daysAgo].first.startTime, rideGroups[daysAgo]
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 48);
              },
            ),
            SizedBox(height: 32)
          ],
        ),
      ),
    );
  }
}

class LocationInfo extends StatelessWidget {
  LocationInfo(this.isPickup, this.location, this.dateTime);
  final bool isPickup;
  final String location;
  final DateTime dateTime;

  // source: https://stackoverflow.com/a/62536187/
  double getTextWidth(BuildContext context) {
    TextPainter painter = TextPainter(
      text: TextSpan(
          text: 'Dropoff', style: CarriageTheme.caption1
      ),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr
    )..layout();

    return painter.size.width;
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Container(
            width: getTextWidth(context), //dropoffTextSize.width,
            child: Text(isPickup ? 'Pickup' : 'Dropoff', style: CarriageTheme.caption1.copyWith(color: CarriageTheme.gray3))
        ),
        SizedBox(width: 12),
        Container(
            // TODO: try to make this less hard-coded?
            width: MediaQuery.of(context).size.width / 2,
            child: Text(location + ' @ ' + intl.DateFormat('jm').format(dateTime), style: CarriageTheme.body)
        )
      ],
    );
  }
}
class RideHistoryRow extends StatelessWidget {
  RideHistoryRow(this.ride);
  final Ride ride;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundImage: NetworkImage(ride.rider.photoLink),
        ),
        SizedBox(width: 28),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ride.rider.firstName, style: CarriageTheme.body.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            LocationInfo(true, ride.startLocation, ride.startTime),
            SizedBox(height: 4),
            LocationInfo(false, ride.endLocation, ride.endTime),
          ],
        )
      ],
    );
  }
}

class PastRideGroup extends StatelessWidget {
  PastRideGroup(this.date, this.rides);
  final DateTime date;
  final List<Ride> rides;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: rides.length + 1,
          itemBuilder: (context, index) => index == 0 ? RideGroupTitle(intl.DateFormat('yMMMMd').format(date), rides.length) : RideHistoryRow(rides[index - 1]),
          separatorBuilder: (context, index) => index > 0 ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Divider(),
          ) : SizedBox(height: 24)
      ),
    );
  }
}