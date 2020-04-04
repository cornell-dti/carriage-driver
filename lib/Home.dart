import 'package:flutter/material.dart';
import 'Upcoming.dart';
import 'Login.dart';
import 'Profile.dart';

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
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int PROFILE = 2;

  int _selectedIndex = RIDES;
  List<UpcomingRide> rides;
  String _name;

  @override
  void initState() {
    super.initState();
    // Fetch name of user
    _name = "Chris";
    // TODO: fetch info about rides
    rides = [UpcomingRide(startTime: DateTime.now())];
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

  Widget _noRidesLeftPage (BuildContext context) {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Greeting(name: _name),
        SizedBox(height: 195),
        Center (
            child: Column (
              children: <Widget>[
                Image(
                  image: AssetImage('assets/images/steeringWheel@3x.png'),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
                SizedBox(height: 22),
                Text(
                  'Congratulations! You are done for the day. \n'
                      'Come back tomorrow!',
                  textAlign: TextAlign.center,
                )
              ],
            )
        ),
      ],
    );
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
        if (rides.length == 0) return _noRidesLeftPage(context);
        else return _ridesPage(context);
        break;
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
      },
    );
  }
}

