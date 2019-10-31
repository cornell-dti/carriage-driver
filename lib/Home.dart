import 'package:flutter/material.dart';
import 'Upcoming.dart';
import 'Map.dart';

class Greeting extends StatelessWidget {
  String name;

  Greeting({@required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Text('Hi $name!',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      padding: EdgeInsets.only(left: 30.0, top: 50.0, bottom: 10.0),
    );
  }
}

class LeftSubheading extends StatelessWidget {
  String heading;

  LeftSubheading({@required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, bottom: 15.0),
      child: Text('$heading',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0));

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _ride(BuildContext context, int index) {
    return NextRide();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Greeting(name: 'Chris'),
              LeftSubheading(heading: 'Next Ride'),
              Center(child: NextRide()),
              SizedBox(height: 20.0),
              LeftSubheading(heading: 'Upcoming Rides'),
              Flexible(
                  child: Center(
                child: ListView.separated(
                  itemCount: 3,
                  itemBuilder: _ride,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  padding:
                      EdgeInsets.only(left: 30.0, right: 30.0, bottom: 5.0),
                ),
              ))
            ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.star), title: Text('Rides')),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), title: Text('History')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text('Profile'))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
