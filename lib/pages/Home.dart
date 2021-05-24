import 'package:carriage/pages/Notifications.dart';
import 'package:carriage/providers/PageNavigationProvider.dart';
import 'package:flutter/material.dart';
import '../utils/LocationTracker.dart';
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
  //TODO: figure out if there's been a new notification
  bool hasNewNotification = false;

  //Initialize notification variables
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StreamSubscription iosSubscription; // ignore: cancel_subscriptions
  String deviceToken;
  String id;

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
    if (id != null) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => NotificationsPage()));
    } else {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => NotificationsPage()));
    }
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
      'Ride changed by $notification',
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
        hasNewNotification = true;
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
          id = androidNotification.rideId;
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
          id = iosNotification.rideId;
        }
        Platform.isIOS
            ? showNotification(iosNotification.changedBy)
            : showNotification(androidNotification.changedBy);
        setState(() {});
      },
      onLaunch: (Map<String, dynamic> message) async {
        hasNewNotification = true;
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
          id = androidNotification.rideId;
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
          id = iosNotification.rideId;
        }
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => NotificationsPage()));
        setState(() {});
      },
      onResume: (Map<String, dynamic> message) async {
        hasNewNotification = true;
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
          id = androidNotification.rideId;
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
          id = iosNotification.rideId;
        }
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => NotificationsPage()));
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
      showNotification(jsonDecode(data)['changedBy']['userType']);
      print("_backgroundMessageHandler data: $data");
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

  @override
  Widget build(BuildContext context) {
    Widget notifIcon = Icon(Icons.notifications);
    Widget notifWidget = hasNewNotification
        ? Stack(children: [
            notifIcon,
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                    width: 9,
                    height: 9,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    )))
          ])
        : notifIcon;

    PageNavigationProvider pageNavProvider =
        Provider.of<PageNavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: pageNavProvider.getPage(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car), label: 'Rides'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule), label: 'History'),
            BottomNavigationBarItem(icon: notifWidget, label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          currentIndex: pageNavProvider.getPageIndex(),
          onTap: (index) => pageNavProvider.changePage(index),
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
