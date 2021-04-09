import 'package:carriage/pages/Notifications.dart';
import 'package:carriage/pages/RideHistory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../utils/LocationTracker.dart';
import 'Rides.dart';
import '../main_common.dart';
import 'Profile.dart';
import '../providers/DriverProvider.dart';
import '../utils/CarriageTheme.dart';

class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DriverProvider userInfoProvider = Provider.of<DriverProvider>(context);
    return Padding(
        child: Container(
            height: 46,
            child: userInfoProvider.hasInfo()
                ? Text('Hi ${userInfoProvider.driver.firstName}!',
                style: Theme.of(context).textTheme.headline4)
                : Container()),
        padding: EdgeInsets.only(
            left: 24.0,
            top: 18.0 + MediaQuery.of(context).padding.top,
            bottom: 16.0));
  }
}

class LeftSubheading extends StatelessWidget {
  final String heading;

  LeftSubheading({@required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, bottom: 16.0),
      child: Text('$heading', style: CarriageTheme.largeTitle),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int NOTIFS = 2;
  static const int PROFILE = 3;

  int _selectedIndex = RIDES;

  @override
  void initState() {
    super.initState();

    LocationTracker.initialize();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget getPage(BuildContext context, int index) {
    switch (index) {
      case (RIDES):
        return Rides();
      case (HISTORY):
        return RideHistory();
      case (NOTIFS):
        return NotificationsPage();
      case (PROFILE):
        return SingleChildScrollView(child: Profile());
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
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car), label: 'Rides'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
