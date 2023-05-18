import 'package:carriage/utils/CarriageTheme.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // TODO: add these to DriverProvider when added to backend
  bool newRides = false;
  bool rideEdits = false;
  bool rideCancellations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackBar('Profile', CarriageTheme.backgroundColor),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: CarriageTheme.backgroundColor,
              child: Padding(
                padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                child: Text('Notifications', style: CarriageTheme.largeTitle),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SettingRow('New Rides', 'Get notifications when a new ride is added to your schedule.', newRides,
                      (selection) => setState(() => newRides = selection)),
                  Divider(),
                  SettingRow('Ride Edits', "Get notifications when a ride's info is edited in to your schedule.",
                      rideEdits, (selection) => setState(() => rideEdits = selection)),
                  Divider(),
                  SettingRow('Ride Cancellations', 'Get notifications when a new ride is removed from your schedule.',
                      rideCancellations, (selection) => setState(() => rideCancellations = selection)),
                  Divider()
                ],
              ),
            ),
          ],
        ));
  }
}

class SettingRow extends StatelessWidget {
  SettingRow(this.title, this.description, this.value, this.callback);
  final String title;
  final String description;
  final bool value;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(description, style: TextStyle(fontSize: 17, color: CarriageTheme.gray1))),
            ],
          ),
          Spacer(),
          Switch(
            onChanged: callback,
            value: value,
            activeTrackColor: Colors.black,
            activeColor: Colors.white,
          )
        ],
      ),
    );
  }
}
