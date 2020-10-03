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
  BigRideInProgressCard(this.ride);
  final Ride ride;
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
                    Center(child: Text('Terry', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
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
                          //TODO: add action when press drop off
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
                      child: FutureBuilder<String>(
                          future: widget.ride.retrieveRiderName(context),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
                            }
                            return Text(snapshot.data, style: Theme.of(context).textTheme.subtitle1);
                          }
                      )
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
  OtherRideCard(this.ride);
  final Ride ride;
  Widget build(BuildContext context) {
    return Container(
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
                      FutureBuilder<String>(
                          future: ride.retrieveRiderName(context),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
                            }
                            return Text(snapshot.data, style: Theme.of(context).textTheme.subtitle1);
                          }
                      )
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
    );
  }
}

class RidesInProgressPage extends StatefulWidget {
  RidesInProgressPage(this.currentRides, this.otherRides);
  final List<Ride> currentRides;
  final List<Ride> otherRides;
  _RidesInProgressPageState createState() => _RidesInProgressPageState();
}

class _RidesInProgressPageState extends State<RidesInProgressPage> {
  List<Ride> selectedRides = [];

  void selectRide(Ride ride, bool select) {
    setState(() {
      if (select)
        selectedRides.add(ride);
      else
        selectedRides.remove(ride);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
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
                            child: Center(child: Text(widget.currentRides.length.toString(), style: TextStyle(color: Colors.white))),
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
                        widget.currentRides.length == 1 ?
                        BigRideInProgressCard(widget.currentRides[0]) :
                        GridView.count(
                          padding: EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          shrinkWrap: true,
                          children: widget.currentRides.map((ride) => SmallRideInProgressCard(ride, selectRide)).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text('Do you also want to pick up...', style: Theme.of(context).textTheme.subtitle1),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: [SizedBox(width: 16), SizedBox(width: 16)]..insertAll(1, widget.otherRides.map((ride) => OtherRideCard(ride)).toList())
                          ),
                        ),
                        selectedRides.isNotEmpty ? SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            padding: EdgeInsets.all(16),
                            //TODO: change rider ID to rider name
                            color: Colors.black,
                            child: FutureBuilder<String>(
                                future: selectedRides[0].retrieveRiderName(context),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
                                  }
                                  return Text('Drop off ' + (selectedRides.length == 1 ? snapshot.data : 'Multiple Passengers'),
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                                  );
                                }
                            ),
                            onPressed: () {
                              //TODO: add action when press drop off
                            },
                          ),
                        ) : Container(),
                      ]
                  ),
                ],
              ),
            )
        )
    );
  }
}