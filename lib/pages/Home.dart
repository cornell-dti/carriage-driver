import 'package:carriage/pages/RideHistory.dart';
import 'package:flutter/material.dart';
import '../utils/LocationTracker.dart';
import 'Rides.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int PROFILE = 2;

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
