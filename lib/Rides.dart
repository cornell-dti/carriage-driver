import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Ride.dart';

class Rides extends StatefulWidget {
  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  // this is for passing the retrieved rides from the FutureBuilder to the ride flow rather than needing another request to retrieve the same data
  List<Ride> rides;

  Widget _emptyPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 195),
        Center(
            child: Column(
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
            )),
      ],
    );
  }

  Widget _mainPage(BuildContext context, List<Ride> rides) {
    double padding = 16;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: rides.length,
              itemBuilder: (BuildContext c, int index) =>
                  RideCard(rides[index], padding),
              padding: EdgeInsets.only(left: padding, right: padding),
              shrinkWrap: true,
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 32),
                child: Text(DateFormat('yMMMM').format(DateTime.now()), style: Theme.of(context).textTheme.headline5),
              ),
              Expanded(
                  child: FutureBuilder<List<Ride>>(
                      future: fetchRides(context, authProvider.id),
                      builder: (context, snapshot) {
                        rides = snapshot.data;
                        if (snapshot.hasData) {
                          if (snapshot.data.length == 0) {
                            return _emptyPage(context);
                          } else {
                            return _mainPage(context, snapshot.data);
                          }
                        } else if (snapshot.hasError) {
                          // TODO: placeholder error response
                          return Text("${snapshot.error}");
                        }
                        return Center(child: CircularProgressIndicator());
                      }
                  )
              )
            ]
        )
    );
  }
}
