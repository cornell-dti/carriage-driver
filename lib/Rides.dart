import 'package:carriage/MeasureRect.dart';
import 'package:carriage/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Ride.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class RidesStateless extends StatelessWidget {  
  final List<Ride> currentRides;
  final List<Ride> remainingRides;
  final List<Ride> selectedRides;
  final void Function() onDropoff;
  final void Function(Ride r) selectCallback;

  final OnWidgetRectChange firstCurrentRideRectCb;
  final OnWidgetRectChange firstRemainingRideRectCb;
  static void onChangeDefault(Rect s) {}

  const RidesStateless(
      {Key key,
      this.currentRides,
      this.remainingRides,
      this.selectedRides,
      this.onDropoff,
      this.selectCallback,
      this.firstCurrentRideRectCb = onChangeDefault,
      this.firstRemainingRideRectCb = onChangeDefault})
      : super(key: key);

  Widget emptyPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget ridesInProgress(BuildContext context) {
    return Container(
        child: Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: RideGroupTitle('In Progress', currentRides.length),
      ),
      GridView.count(
        padding: EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        shrinkWrap: true,
        children: currentRides
            .asMap()
            .map((i, ride) {
              Widget w = RideInProgressCard(Key(ride.id), ride,
                  selectedRides.contains(ride), selectCallback);
              if (i == 0)
                w = MeasureRect(child: w, onChange: firstCurrentRideRectCb);
              return MapEntry(i, w);
            })
            .values
            .toList(),
      )
    ]));
  }

  Widget rideCards(BuildContext context, List<Ride> rides) {
    Map<int, List<Ride>> rideGroups = Map();
    for (Ride ride in rides) {
      int hour = ride.startTime.hour;
      if (rideGroups.containsKey(hour)) {
        rideGroups[hour].add(ride);
      } else {
        rideGroups[hour] = [ride];
      }
    }
    List<int> hours = rideGroups.keys.toList();
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: hours.length,
      itemBuilder: (context, index) {
        int hour = hours[index];
        return RideGroup(
            rideGroups[hour], hour, index, firstRemainingRideRectCb);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 32);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: currentRides.isEmpty && remainingRides.isEmpty
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: emptyPage(context)))
            : Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 16, right: 16),
                              child: Text(
                                  DateFormat('yMMMM').format(DateTime.now()),
                                  style: Theme.of(context).textTheme.headline5),
                            ),
                            SizedBox(height: 32),
                            currentRides.length > 0
                                ? ridesInProgress(context)
                                : Container(),
                            selectedRides.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(bottom: 32),
                                    child: rideCards(context, remainingRides),
                                  )
                                : Container()
                          ]),
                    ),
                  ),
                  selectedRides.isNotEmpty
                      ? Positioned(
                          bottom: 32,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 34, right: 34),
                              child: FlatButton(
                                  padding: EdgeInsets.all(16),
                                  color: Colors.black,
                                  child: Text(
                                      'Drop off ' +
                                          (selectedRides.length == 1
                                              ? selectedRides[0].rider.firstName
                                              : 'Multiple Passengers'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: onDropoff),
                            ),
                          ),
                        )
                      : Container()
                ],
              ));
  }
}

class Rides extends StatefulWidget {
  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  List<Ride> selectedRides = [];

  void selectRide(Ride ride) {
    setState(() {
      if (!selectedRides.contains(ride))
        selectedRides.add(ride);
      else
        selectedRides.remove(ride);
    });
  }

  void finishRide(BuildContext context, Ride ride) async {
    http.Response statusResponse =
        await updateRideStatus(context, ride.id, RideStatus.COMPLETED);
    if (statusResponse.statusCode == 200) {
      http.Response typeResponse = await setRideToPast(context, ride.id);
      if (typeResponse.statusCode == 200) {
        Provider.of<RidesProvider>(context, listen: false)
            .finishCurrentRide(ride);
      } else {
        throw Exception('Error setting ride type to past');
      }
    } else {
      throw Exception(
          'Error setting ride status to ${toString(RideStatus.COMPLETED)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);

    var currentRides = ridesProvider.currentRides;
    var remainingRides = ridesProvider.remainingRides;

    return RidesStateless(
      currentRides: currentRides,
      remainingRides: remainingRides,
      selectedRides: selectedRides,
      onDropoff: () {
        setState(() {
          selectedRides.forEach((Ride r) => finishRide(context, r));
          selectedRides = [];
        });
      },
      selectCallback: selectRide,
    );
  }
}

class RideGroupTitle extends StatelessWidget {
  RideGroupTitle(this.title, this.numRides);
  final String title;
  final int numRides;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF4A4A4A))),
      SizedBox(width: 24),
      Icon(Icons.people),
      SizedBox(width: 8),
      Text(numRides.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 17, color: Colors.black))
    ]);
  }
}

class RideGroup extends StatelessWidget {
  RideGroup(
      this.rides, this.hour, this.groupIndex, this.firstRemainingRideRectCb);
  final int hour;
  final List<Ride> rides;
  final int groupIndex;
  final Function firstRemainingRideRectCb;

  @override
  Widget build(BuildContext context) {
    int hour12 = hour;
    String period;
    if (hour < 12) {
      period = 'AM';
    } else {
      period = 'PM';
      if (hour > 12) {
        hour12 -= 12;
      }
    }
    String title = '$hour12:00 ~ $hour12:50 ' + period;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: rides.length + 1,
        itemBuilder: (context, index) {
          index -= 1;
          // title
          if (index == -1) {
            return Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: RideGroupTitle(title, rides.length),
            );
          }
          Widget w = RideCard(rides[index]);
          if (index == 0 && groupIndex == 0)
            w = MeasureRect(child: w, onChange: firstRemainingRideRectCb);
          return w;
        },
        separatorBuilder: (context, index) {
          return index > 0 ? SizedBox(height: 16) : Container();
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class RideInProgressCard extends StatelessWidget {
  RideInProgressCard(Key key, this.ride, this.selected, this.selectCallback)
      : super(key: key);
  final Ride ride;
  final Function selectCallback;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectCallback(ride);
      },
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: selected ? Color(0xFFBDBDBD) : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.25))
              ]),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selected
                      ? Icon(Icons.check_circle, size: 20, color: Colors.black)
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0x7FC4C4C4)),
                        ),
                  Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/terry.jpg'),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                      child: Text(ride.rider.firstName,
                          style: Theme.of(context).textTheme.subtitle1)),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'To ',
                        style:
                            TextStyle(fontSize: 15, color: Color(0x7F3F3356)),
                        children: [
                          TextSpan(
                              text: ride.endLocation,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black))
                        ]),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'Drop off by ',
                        style:
                            TextStyle(fontSize: 15, color: Color(0x7F3F3356)),
                        children: [
                          TextSpan(
                              text: DateFormat('jm').format(ride.endTime),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                ]),
          )),
    );
  }
}

class RidesCompletedPage extends StatefulWidget {
  @override
  _RidesCompletedPageState createState() => _RidesCompletedPageState();
}

class _RidesCompletedPageState extends State<RidesCompletedPage> {
  @override
  initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: 90),
          Text('Rides Completed', style: Theme.of(context).textTheme.headline5),
          SizedBox(height: 120),
          Image.asset('assets/images/townCar.png')
        ]),
      ),
    );
  }
}
