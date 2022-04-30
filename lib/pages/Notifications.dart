import 'dart:ui';
import 'package:carriage/models/Ride.dart';
import 'package:carriage/pages/RideHistory.dart';
import 'package:carriage/providers/NotificationsProvider.dart';
import 'package:carriage/providers/RidesProvider.dart';
import 'package:carriage/utils/CarriageTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum NotifEvent {
  RIDE_CREATED,
  RIDE_EDITED,
  RIDE_SCHEDULED,
  RIDE_CANCELLED,
}

NotifEvent getNotifEventEnum(String notifEvent) {
  switch (notifEvent) {
    case ('created'):
      return NotifEvent.RIDE_CREATED;
    case ('edited'):
      return NotifEvent.RIDE_EDITED;
    case ('scheduled'):
      return NotifEvent.RIDE_SCHEDULED;
    case ('cancelled'):
      return NotifEvent.RIDE_CANCELLED;
    default:
      throw Exception('Notif event is invalid');
  }
}

class AdminNotification extends StatelessWidget {
  AdminNotification(
      this.ride, this.notifTime, this.text, this.color, this.iconData);

  final Ride ride;
  final DateTime notifTime;
  final String text;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    Widget icon = CircleAvatar(
        radius: 22,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Icon(iconData),
        ));
    return Notification(this.ride, this.notifTime, icon, 'Admin', this.text);
  }
}

class Notification extends StatelessWidget {
  Notification(
      this.ride, this.notifTime, this.circularWidget, this.title, this.text);

  final Ride ride;
  final DateTime notifTime;
  final Widget circularWidget;
  final String title;
  final String text;

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
    } else if (timeWithin(Duration(days: 1))) {
      int hoursSince = timeSinceNotif.inHours;
      time = '$hoursSince hour${hoursSince == 1 ? '' : 's'} ago';
    } else if (timeWithin(Duration(days: 3))) {
      int daysSince = timeSinceNotif.inDays;
      time = '$daysSince day${daysSince == 1 ? '' : 's'} ago';
    } else {
      time = DateFormat('yMd').format(notifTime);
    }

    return InkWell(
      onTap: () {
        if (ride != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RideHistory()));
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            circularWidget,
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      time,
                      style:
                          TextStyle(fontSize: 11, color: CarriageTheme.gray2),
                    ),
                  ]),
                  SizedBox(height: 4),
                  Text(text,
                      style: TextStyle(fontSize: 15, color: Colors.black))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackendNotification {
  BackendNotification(
      this.id, this.type, this.message, this.rideID, this.timeSent);

  final String id;
  final NotifEvent type;
  final String message;
  final DateTime timeSent;
  final String rideID;

  String toString() => 'Notification $type: $rideID';
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationsProvider notifsProvider =
          Provider.of<NotificationsProvider>(context, listen: false);
      notifsProvider.notifOpened();
    });
  }

  Widget buildNotification(
      NotifEvent type, String message, DateTime time, Ride ride) {
    switch (type) {
      case NotifEvent.RIDE_CANCELLED:
        return AdminNotification(ride, time, message, Colors.red, Icons.close);
      case NotifEvent.RIDE_EDITED:
        return AdminNotification(ride, time, message, Colors.red, Icons.edit);
      case NotifEvent.RIDE_SCHEDULED:
      case NotifEvent.RIDE_CREATED:
        return AdminNotification(
            ride, time, message, Colors.green, Icons.check);
      default:
        throw Exception('Notification could not be built: $type, ${ride.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    List<Ride> rides =
        ridesProvider.currentRides + ridesProvider.remainingRides;

    NotificationsProvider notifsProvider =
        Provider.of<NotificationsProvider>(context);
    List<BackendNotification> backendNotifs = notifsProvider.notifs;
    List<Widget> notifWidgets = [];

    for (BackendNotification notif in backendNotifs) {
      Ride ride = rides.firstWhere((ride) => ride.id == notif.rideID,
          orElse: () => null);
      notifWidgets.add(
          buildNotification(notif.type, notif.message, notif.timeSent, ride));
    }

    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Text('Notifications', style: CarriageTheme.largeTitle),
          ),
          Column(children: notifWidgets.reversed.toList())
        ])));
  }
}
