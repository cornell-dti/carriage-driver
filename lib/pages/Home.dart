import 'package:carriage/providers/PageNavigationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../utils/LocationTracker.dart';
import '../main_common.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //TODO: figure out if there's been a new notification
  bool hasNewNotification = true;

  @override
  void initState() {
    super.initState();
    LocationTracker.initialize();
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

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return RaisedButton(
      child: Text('Sign out', textAlign: TextAlign.start),
      onPressed: () {
        authProvider.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeOrLogin()));
      },
    );
  }
}
