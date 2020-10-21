import 'package:carriage/pages/BeginRidePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Ride.dart';
import 'RidesInProgress.dart';
import 'pages/OnTheWayPage.dart';
import 'pages/PickUpPage.dart';

class RideFlow extends StatefulWidget {
  RideFlow(this.initialRide, this.initialRemainingRides);
  final Ride initialRide;
  final List<Ride> initialRemainingRides;

  @override
  _RideFlow createState() => _RideFlow();
}

class _RideFlow extends State<RideFlow> {
  Widget currentPage;
  List<Ride> currentRides;
  List<Ride> remainingRides;

  @override
  void initState() {
    super.initState();
    setBeginPage(widget.initialRide);
    currentRides = [widget.initialRide];
    remainingRides = widget.initialRemainingRides;
  }

  void setBeginPage(Ride ride) {
    setState(() {
      currentPage = BeginRidePage(ride, setOnTheWayPage);
    });
  }

  void setOnTheWayPage(Ride ride) {
    setState(() {
      currentPage = OnTheWayPage(ride, setPickUpPage);
    });
  }

  void setPickUpPage(Ride ride) {
    setState(() {
      currentPage = PickUpPage(ride, setProgressPage);
    });
  }

  void setProgressPage(Ride rideStarted) {
    setState(() {
      if (rideStarted != widget.initialRide) {
        remainingRides.remove(rideStarted);
        currentRides.add(rideStarted);
      }
      currentPage = RidesInProgressPage(currentRides, remainingRides, setBeginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}
class Rides extends StatefulWidget {
  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  List<Ride> rides;

  void createFlow(Ride initialRide) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RideFlow(initialRide, rides..remove(initialRide))));
  }

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
                  RideCard(rides[index], padding, createFlow),
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
