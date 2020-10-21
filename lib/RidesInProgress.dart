import 'package:carriage/Ride.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

BoxDecoration dropShadow = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.07),
        blurRadius: 20,
        offset: Offset(0, 7), // changes position of shadow
      ),
    ]
);

class Locations extends StatelessWidget {
  Locations(this.startLocation, this.endLocation);
  final String startLocation;
  final String endLocation;
  @override
  Widget build(BuildContext context) {
    TextStyle fromToStyle = TextStyle(fontSize: 15, color: Color(0x7F1A051D));
    TextStyle locationStyle = TextStyle(fontSize: 15, color: Color(0xFF1A051D));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('From', style: fromToStyle), SizedBox(height: 2), Text(startLocation, style: locationStyle)]
          ),
        ),
        SizedBox(width: 24),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('To', style: fromToStyle), SizedBox(height: 2), Text(endLocation, style: locationStyle)]
            )
        )
      ],
    );
  }
}

class PickupTime extends StatelessWidget {
  PickupTime(this.time);
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'Pick up time: ',
          style: TextStyle(fontSize: 13, color: Color(0xFF3F3356)),
          children: [
            TextSpan(
                text: DateFormat('jm').format(time),
                style: TextStyle(fontSize: 13, color: Color(0xFF3F3356), fontWeight: FontWeight.bold)
            )
          ]
      ),
    );
  }
}
class BigRideInProgressCard extends StatelessWidget {
  BigRideInProgressCard(this.ride, this.finishRide);
  final Ride ride;
  final Function finishRide;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 237,
        child: DecoratedBox(
            decoration: dropShadow,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/terry.jpg'),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(child: Text(ride.rider.firstName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    SizedBox(height: 16),
                    Locations(ride.startLocation, ride.endLocation),
                    SizedBox(height: 16),
                    PickupTime(ride.startTime),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: Colors.black,
                        child: Text('Drop off', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          finishRide(ride);
                        },
                      ),
                    )
                  ]
              ),
            )
        ),
      ),
    );
  }
}

class SmallRideInProgressCard extends StatefulWidget {
  SmallRideInProgressCard(this.ride, this.selectCallback);
  final Ride ride;
  final Function selectCallback;

  @override
  _SmallRideInProgressCardState createState() => _SmallRideInProgressCardState();
}

class _SmallRideInProgressCardState extends State<SmallRideInProgressCard> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
          if (selected) {
            widget.selectCallback(widget.ride, true);
          }
          else {
            widget.selectCallback(widget.ride, false);
          }
        });
      },
      child: DecoratedBox(
          decoration: dropShadow.copyWith(color: selected ? Color(0xFFBDBDBD) : Colors.white),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selected ?
                  Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Colors.black
                  ): Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x7FC4C4C4)),
                  ) ,
                  Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/terry.jpg'),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                      child: Text(widget.ride.rider.firstName, style: Theme.of(context).textTheme.subtitle1)
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'To ',
                        style: TextStyle(fontSize: 15, color: Color(0x7F3F3356)),
                        children: [
                          TextSpan(
                              text: widget.ride.endLocation,
                              style: TextStyle(fontSize: 15, color: Colors.black)
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'Drop off by ',
                        style: TextStyle(fontSize: 15, color: Color(0x7F3F3356)),
                        children: [
                          TextSpan(
                              text: DateFormat('jm').format(widget.ride.endTime),
                              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)
                          )
                        ]
                    ),
                  ),
                ]
            ),
          )
      ),
    );
  }
}

class OtherRideCard extends StatelessWidget {
  OtherRideCard(this.ride, this.startRide);
  final Ride ride;
  final Function startRide;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        startRide(ride);
      },
      child: Container(
        margin: EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 32),
        constraints: BoxConstraints(minWidth: 200),
        child: DecoratedBox(
            decoration: dropShadow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/images/terry.jpg'),
                        ),
                        SizedBox(width: 16),
                        Text(ride.rider.firstName, style: Theme.of(context).textTheme.subtitle1)
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                        width: 200,
                        child: Locations(ride.startLocation, ride.endLocation)
                    ),
                    SizedBox(height: 16),
                    PickupTime(ride.endTime)
                  ]
              ),
            )
        ),
      ),
    );
  }
}

class RidesInProgressPage extends StatefulWidget {
  RidesInProgressPage(this.initCurrentRides, this.otherRides, this.startRide);
  final List<Ride> initCurrentRides;
  final List<Ride> otherRides;
  final Function startRide;
  _RidesInProgressPageState createState() => _RidesInProgressPageState();
}

class _RidesInProgressPageState extends State<RidesInProgressPage> {
  List<Ride> currentRides;
  List<Ride> selectedRides = [];

  @override
  void initState() {
    super.initState();
    currentRides = widget.initCurrentRides;
  }
  void selectRide(Ride ride, bool select) {
    setState(() {
      if (select)
        selectedRides.add(ride);
      else
        selectedRides.remove(ride);
    });
  }

  void finishRide(Ride ride) {
    setState(() {
      currentRides.remove(ride);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: currentRides.isEmpty ? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  SizedBox(height: 90),
                  Text('Rides Completed', style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 120),
                  Image.asset('assets/images/townCar.png')
                ]
              ),
            ) : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  GestureDetector(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_arrow_left, size: 30),
                          Text('Home', style: TextStyle(fontSize: 17))
                        ]
                    ),
                    onTap: () {
                      //TODO: add navigation when home button pressed
                    },
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      width: 24,
                      height: 24,
                      child: Center(child: Text(currentRides.length.toString(), style: TextStyle(color: Colors.white))),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text('Ride(s) In Progress', style: Theme.of(context).textTheme.headline5),
                  ),
                  SizedBox(height: 24),
                  currentRides.length == 1 ?
                  BigRideInProgressCard(currentRides[0], finishRide) :
                  GridView.count(
                    padding: EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    shrinkWrap: true,
                    children: currentRides.map((ride) => SmallRideInProgressCard(ride, selectRide)).toList(),
                  ),
                  SizedBox(height: 32),
                  widget.otherRides.isNotEmpty ? Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text('Do you also want to pick up...', style: Theme.of(context).textTheme.subtitle1),
                  ) : Container(),
                  widget.otherRides.isNotEmpty ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: [SizedBox(width: 16), SizedBox(width: 16)]..insertAll(1, widget.otherRides.map((ride) => OtherRideCard(ride, widget.startRide)).toList())
                    ),
                  ) : Container(),
                  Spacer(),
                  selectedRides.isNotEmpty ? SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 34, right: 34, bottom: 32),
                      child: FlatButton(
                        padding: EdgeInsets.all(16),
                        color: Colors.black,
                        child: Text('Drop off ' + (selectedRides.length == 1 ? selectedRides[0].rider.firstName : 'Multiple Passengers'),
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRides.forEach((Ride r) => finishRide(r));
                            selectedRides = [];
                          });
                        },
                      ),
                    ),
                  ) : Container(),
                ]
            )
        )
    );
  }
}