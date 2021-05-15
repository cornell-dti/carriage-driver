import 'package:carriage/pages/RideHistory.dart';
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
import '../utils/NotificationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int PROFILE = 2;

  int _selectedIndex = RIDES;

  //Initialize notification variables
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StreamSubscription iosSubscription; // ignore: cancel_subscriptions
  String deviceToken;

  @override
  void initState() {
    super.initState();
    LocationTracker.initialize();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    initialize();
    getMessage();
  }

  Future<void> onSelectNotification(String payload) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Home()));
    return Future<void>.value();
  }

  _registerOnFirebase() async {
    //_fcm.subscribeToTopic('all');
    await _fcm.getToken().then((token) => deviceToken = token);

    if (deviceToken != null) {
      subscribe(deviceToken);
    }
    _fcm.onTokenRefresh.listen((newToken) {
      subscribe(newToken);
    });
  }

  void initialize() async {
    _registerOnFirebase();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
        _fcm.subscribeToTopic('all');
      });
      await _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    }
  }

  // Show notification banner on background and foreground.
  static void showNotification(String notification) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        await getAndroidNotificationDetails(notification);
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await notificationsPlugin.show(
      0,
      'Carriage Driver',
      notification,
      platformChannelSpecifics,
    );
  }

  static Future<AndroidNotificationDetails> getAndroidNotificationDetails(
      dynamic notification) async {
    return AndroidNotificationDetails('general', 'General notifications',
        'General notifications that are not sorted to any specific topics.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        category: 'General',
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'));
  }

  void getMessage() async {
    PushNotificationMessageAndroid androidNotification;
    PushNotificationMessageIOS iosNotification;

    _fcm.configure(
      onBackgroundMessage: Platform.isIOS ? null : backgroundHandle,
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Platform.isIOS
            ? showNotification(iosNotification.body)
            : showNotification(androidNotification.body);
        setState(() {});
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Home()));
        setState(() {});
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Home()));
        setState(() {});
      },
    );
  }

  static Future<dynamic> backgroundHandle(
    Map<String, dynamic> message,
  ) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data']['default'];
      showNotification('$data');
      print("_backgroundMessageHandler data: $data");
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification']['body'];
      showNotification('$notification');
      print("_backgroundMessageHandler notification: $notification");
    }
    return Future<void>.value();
  }

  subscribe(String token) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String authToken = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      "${AppConfig.of(context).baseUrl}/notification/subscribe",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: jsonEncode(<String, String>{
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
                icon: Icon(Icons.person, size: 20), label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
