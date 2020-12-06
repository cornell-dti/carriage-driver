import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'LocationTracker.dart';
import 'Rides.dart';
import 'RidesProvider.dart';
import 'main_common.dart';
import 'Profile.dart';
import 'UserInfoProvider.dart';

class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    return Padding(
        child: Container(
            height: 46,
            child: userInfoProvider.hasInfo()
                ? Text('Hi ${userInfoProvider.info.firstName}!',
                    style: Theme.of(context).textTheme.headline5)
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
      child: Text('$heading', style: Theme.of(context).textTheme.subtitle1),
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

  Widget _profilePage(BuildContext context) {
    return Profile();
  }

  Widget getPage(BuildContext context, int index) {
    switch (index) {
      case (RIDES):
        RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
        return FutureBuilder(
            future: ridesProvider.requestActiveRides(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SafeArea(
                  child: Center(
                      child: CircularProgressIndicator()
                  ),
                );
              }
              return Rides();
            }
        );
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
        return SingleChildScrollView(child: _profilePage(context));
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
              icon: Icon(Icons.star), label: 'Rides'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Profile')
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
