import 'package:carriage/models/Ride.dart';
import 'package:carriage/providers/RidesProvider.dart';
import 'package:carriage/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carriage/widgets/Notification.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  DispatcherNotification rideEditedNotif(Ride ride, DateTime notifTime, bool showDate) {
    return DispatcherNotification(ride, notifTime, Colors.black, Icons.edit, 'Ride information has been edited in your schedule', showDate);
  }
  DispatcherNotification ridesAddedNotif(Ride ride, DateTime notifTime, bool showDate) {
    return DispatcherNotification(ride, notifTime, Colors.green, Icons.person_add, 'Rides have been added to your schedule', showDate);
  }
  DispatcherNotification ridesRemovedNotif(Ride ride, DateTime notifTime, bool showDate) {
    return DispatcherNotification(ride, notifTime, Colors.red, Icons.close, 'Rides have been removed from your schedule', showDate);
  }

  @override
  Widget build(BuildContext context) {
    Ride r0 = Provider.of<RidesProvider>(context, listen: false).remainingRides[0];
    Ride r1 = Provider.of<RidesProvider>(context, listen: false).remainingRides[1];
    Ride rlast = Provider.of<RidesProvider>(context, listen: false).remainingRides.last;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
                    child: Text('Notifications', style: CarriageTheme.largeTitle),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                        children: [
                          rideEditedNotif(r0, DateTime.now().subtract(Duration(days: 1)), true),
                          ridesRemovedNotif(r1, DateTime.now().subtract(Duration(days: 1)), true),
                          ridesAddedNotif(rlast, DateTime.now().subtract(Duration(days: 7)), true),

                          rideEditedNotif(r0, DateTime.now().subtract(Duration(days: 1)), false),
                          ridesRemovedNotif(r0, DateTime.now().subtract(Duration(days: 1)), false),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(days: 7)), false),

                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(days: 3)), true),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(days: 2)), true),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(days: 1)), true),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(hours: 7)), true),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(hours: 1)), true),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(minutes: 7)), true),
                          ridesAddedNotif(r0, DateTime.now().subtract(Duration(minutes: 1)), true),
                        ]
                    ),
                  )
                ]
            ),
          ),
        )
    );
  }
}

