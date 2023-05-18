import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carriage/pages/RideHistory.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/AuthProvider.dart';
import '../utils/app_config.dart';
import 'Profile.dart';
import 'Rides.dart';

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
  static const int PROFILE = 2;

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
    // LocationTracker.initialize();
  }

  Future<void> onSelectNotification(String payload) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    return Future<void>.value();
  }

  subscribe(String token) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
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
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    notificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  _onMessage(RemoteMessage message) {
    print('received message');
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      notificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ));
    }
  }

  _onMessageOpenedApp(RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
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
            BottomNavigationBarItem(icon: Icon(Icons.directions_car, size: 20), label: 'Rides'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule, size: 20), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 20), label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
