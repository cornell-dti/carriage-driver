import 'package:carriage/models/Ride.dart';
import 'package:carriage/providers/PageNavigationProvider.dart';
import 'package:carriage/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: only show notifs from past week
class DispatcherNotification extends StatelessWidget {
  DispatcherNotification(this.ride, this.notifTime, this.color, this.iconData, this.text, this.showDate);

  final Ride ride;
  final DateTime notifTime;
  final Color color;
  final IconData iconData;
  final String text;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration timeSinceNotif = now.difference(notifTime);
    String time = '';

    bool timeWithin(Duration threshold) {
      return timeSinceNotif.compareTo(threshold) <= 0;
    }

    if (timeWithin(Duration(hours: 1))) {
      time = '${timeSinceNotif.inMinutes} min ago';
    }

    else if (timeWithin(Duration(days: 1))) {
      int hoursSince = timeSinceNotif.inHours;
      time = '$hoursSince hour${hoursSince == 1 ? '' : 's'} ago';
    }
    else if (timeWithin(Duration(days: 3))) {
      int daysSince = timeSinceNotif.inDays;
      time = '$daysSince day${daysSince == 1 ? '' : 's'} ago';
    }
    else {
      time = DateFormat('yMd').format(notifTime);
    }

    return GestureDetector(
      onTap: () {
        PageNavigationProvider pageNavProvider = Provider.of<PageNavigationProvider>(context, listen: false);
        pageNavProvider.setScrollHour(ride.startTime.hour);
        pageNavProvider.changePage(PageNavigationProvider.RIDES);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: 22,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  child: Icon(iconData),
                )
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                        Text(
                          'Dispatcher',
                          style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(fontSize: 11, color: CarriageTheme.gray2),
                        ),
                      ]
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                        text: text + (showDate ? '' : '.'),
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: showDate ? [
                          TextSpan(
                              text: ' for',
                              style: TextStyle(fontSize: 15, color: Colors.black)
                          ),
                          TextSpan(
                              text: ' ${DateFormat('MM/dd/yyyy').format(ride.startTime)}.',
                              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)
                          ),
                        ] : []
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}