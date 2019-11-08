import 'package:flutter/material.dart';
import 'Upcoming.dart';
import 'Map.dart';

class Greeting extends StatelessWidget {
  String name;

  Greeting({@required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Text('Hi $name!', style: Theme.of(context).textTheme.headline),
      padding: EdgeInsets.only(
          left: 24.0,
          top: 18.0 + MediaQuery.of(context).padding.top,
          bottom: 16.0),
    );
  }
}

class LeftSubheading extends StatelessWidget {
  String heading;

  LeftSubheading({@required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, bottom: 16.0),
      child: Text('$heading', style: Theme.of(context).textTheme.subhead),
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
    return UpcomingRide();
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
              Center(
                  child: Column(
                children: <Widget>[
                  UpcomingRide(),
                ],
              )),
              SizedBox(height: 3),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Map();
                    }));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  color: Colors.red,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.directions_car, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Start Ride', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              LeftSubheading(heading: 'Upcoming Rides'),
              Flexible(
                child: ListView.separated(
                  itemCount: 3,
                  itemBuilder: _ride,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  padding:
                      EdgeInsets.only(left: 24.0, right: 24.0, bottom: 5.0),
                ),
              ),
            ]),
//        floatingActionButton: FloatingActionButton.extended(
//          onPressed: () {
//            Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) {
//                return Map();
//              }
//            ));
//          },
//          label: Text('Start Ride'),
//          icon: Icon(Icons.directions_car),
//        ),
//        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
