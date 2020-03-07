import 'package:flutter/material.dart';
import 'Upcoming.dart';
import 'Login.dart';

class Greeting extends StatelessWidget {
  final String name;

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
  final String heading;

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
  int _selectedIndex = 0;

  String _name;

  @override
  void initState() {
    super.initState();
    // Fetch name of user
    _name = "Chris";
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _ride(BuildContext context, int index) {
    return UpcomingRide();
  }

  Widget _ridesPage(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Greeting(name: _name),
          LeftSubheading(heading: 'Upcoming Ride'),
          Center(
              child: Column(
            children: <Widget>[
              CurrentRide(),
            ],
          )),
          SizedBox(height: 16.0),
          LeftSubheading(heading: 'Today\'s Schedule'),
          Flexible(
            child: ListView.separated(
              itemCount: 3,
              itemBuilder: _ride,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 5.0),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _selectedIndex == 0
            ? _ridesPage(context)
            : _selectedIndex == 1
                ? Column()
                : Column(
                    children: <Widget>[SizedBox(height: 50), Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       SignOutButton(),
                      ],
                    )],
                  ),
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

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Sign out', textAlign: TextAlign.start),
      onPressed: () {
        googleSignIn.signOut();
      },

    );
  }
}
