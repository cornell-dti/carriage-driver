import 'package:carriage/models/Ride.dart';
import 'package:carriage/pages/Notifications.dart';
import 'package:carriage/pages/RideHistory.dart';
import 'package:carriage/providers/NotificationsProvider.dart';
import 'package:carriage/providers/RidesProvider.dart';
import 'package:flutter/material.dart';
import '../utils/LocationTracker.dart';
import 'Rides.dart';
import 'Profile.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/app_config.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int NOTIFICATIONS = 2;
  static const int PROFILE = 3;

  int _selectedIndex = RIDES;
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin notificationsPlugin;
  NotificationSettings notifSettings;
  String deviceToken;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    LocationTracker.initialize();
  }

  Future<void> onSelectNotification(String payload) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    return Future<void>.value();
  }

  subscribe(String token) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authToken = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      Uri.parse("${AppConfig.of(context).baseUrl}/notification/subscribe"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: jsonEncode(<String, String>{
        'userId': authProvider.id,
        'userType': 'Driver',
        'platform': 'android',
        'token': token,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to subscribe.');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPage(BuildContext context, int index) {
    switch (index) {
      case (RIDES):
        return Rides(interactive: true);
      case (HISTORY):
        return RideHistory();
      case (NOTIFICATIONS):
        return Notifications();
      case (PROFILE):
        return Profile();
      default:
        return Column();
    }
  }

  _initNotifications() async {
    await _fcm.getToken().then((token) => deviceToken = token);

    if (deviceToken != null) {
      print(deviceToken);
      subscribe(deviceToken);
    }

    _fcm.onTokenRefresh.listen((newToken) {
      subscribe(newToken);
    });

    notifSettings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    notificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  _handleNotification(RemoteNotification notification, String notifId,
      Map<String, dynamic> data) async {
    RidesProvider ridesProvider =
        Provider.of<RidesProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    AppConfig appConfig = AppConfig.of(context);
    NotifEvent notifEvent = getNotifEventEnum(data['notifEvent']);
    Ride ride;
    if (notifEvent != NotifEvent.RIDE_CANCELLED) {
      ride = Ride.fromJson(json.decode(data['ride']));
      // Don't need to care about rides not today
      if (ride.isToday()) {
        try {
          // Check if ride exists
          ridesProvider.getRideByID(ride.id);
        } on Exception {
          // Get most up to date rides from server
          await ridesProvider.requestActiveRides(appConfig, authProvider);
          await ridesProvider.requestPastRides(appConfig, authProvider);
        } finally {
          // Update ride with new information
          ridesProvider.updateRideByID(ride);
        }
      }
    } else {
      // Updating from server will remove cancelled ride
      await ridesProvider.requestActiveRides(appConfig, authProvider);
      await ridesProvider.requestPastRides(appConfig, authProvider);
    }

    NotificationsProvider notifsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    BackendNotification backendNotif = BackendNotification(
        notifId,
        getNotifEventEnum(data['notifEvent']),
        notification.body,
        ride?.id,
        DateTime.parse(data['sentTime']));
    notifsProvider.addNewNotif(backendNotif);
  }

  _onMessage(RemoteMessage message) async {
    Map<String, dynamic> data = message.data;
    String notifId = data['id'];
    print('received message $notifId');

    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null) {
      _handleNotification(notification, notifId, data);
      if (android != null) {
        notificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    }
  }

  _onMessageOpenedApp(RemoteMessage message) async {
    Map<String, dynamic> data = message.data;
    String notifId = data['id'];
    print('app launched from message $notifId');

    RemoteNotification notification = message.notification;

    if (notification != null) {
      _handleNotification(notification, notifId, data);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Notifications()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: getPage(context, _selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car, size: 20), label: 'Rides'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule, size: 20), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined, size: 20),
                activeIcon: Icon(Icons.notifications, size: 20),
                label: 'Notifications'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 20),
                activeIcon: Icon(Icons.person, size: 20),
                label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
