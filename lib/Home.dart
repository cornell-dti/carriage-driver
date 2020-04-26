import 'package:flutter/material.dart';
import 'Rides.dart';
import 'Upcoming.dart';
import 'Login.dart';
import 'Profile.dart';

class Greeting extends StatelessWidget {
  final String name;

  Greeting(this.name);

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
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int PROFILE = 2;

  int _selectedIndex = RIDES;
  List<FutureRide> rides;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  Widget _profilePage(BuildContext context) {
    return Column (
      children: <Widget>[
        Profile(),
        Padding (
            padding: EdgeInsets.only(top: 6),
            child: AccountInfo()
        )
      ],
    );
  }
  Widget getPage(BuildContext context, int index) {
    switch (index) {
      case (RIDES):
        return Rides();
      case (HISTORY):
        return Column(
          children: <Widget>[
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SignOutButton(),
              ],
            )
          ],
        );
      case (PROFILE):
        return _profilePage(context);
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Login()));
      },
    );
  }
}

