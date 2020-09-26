import 'package:carriage/Ride.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Locations extends StatelessWidget {
  Locations(this.startLocation, this.endLocation);
  final String startLocation;
  final String endLocation;
  @override
  Widget build(BuildContext context) {
    TextStyle fromToStyle = TextStyle(fontSize: 15, color: Colors.grey[400]);
    return Row(
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('From', style: fromToStyle), SizedBox(height: 2), Text(startLocation)]
        ),
        SizedBox(width: 24),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('To', style: fromToStyle), SizedBox(height: 2), Text(endLocation)]
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
          style: TextStyle(fontSize: 13, color: Colors.grey[850]),
          children: [
            TextSpan(
                text: DateFormat('jm').format(time),
                style: TextStyle(fontSize: 13, color: Colors.grey[850], fontWeight: FontWeight.bold)
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
        width: MediaQuery.of(context).size.width * 0.75,
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        color: Colors.black,
                        child: Text('Drop off', style: TextStyle(color: Colors.white)),
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
      child: Card(
          color: selected ? Colors.grey[300] : Colors.white,
          child: Padding(
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
                        color: Colors.grey[300]),
                  ) ,
                  Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/terry.jpg'),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(child: Text(widget.ride.riderId[0], style: Theme.of(context).textTheme.subtitle1)),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'To ',
                        style: TextStyle(fontSize: 15, color: Colors.grey[400]),
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
                        style: TextStyle(fontSize: 15, color: Colors.grey[400]),
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
      constraints: BoxConstraints(minWidth: 200),
      child: Card(
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
                      Text(ride.riderId[0], style: Theme.of(context).textTheme.subtitle1)
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
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.keyboard_arrow_left),
                              Text('Home')
                            ]
                        ),
                        onTap: () {
                          //TODO: add navigation when home button pressed
                        },
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 20,
                        height: 20,
                        child: Center(child: Text(widget.currentRides.length.toString(), style: TextStyle(color: Colors.white))),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black),
                      ),
                      Text('Ride(s) In Progress', style: Theme.of(context).textTheme.headline5),
                      widget.currentRides.length == 1 ?
                      BigRideInProgressCard(widget.currentRides[0]) :
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        //TODO: figure out how to not hardcode aspect ratio
                        childAspectRatio: 0.8,
                        shrinkWrap: true,
                        children: widget.currentRides.map((ride) => SmallRideInProgressCard(ride, selectRide)).toList(),
                      ),
                      SizedBox(height: 24),
                      Text('Do you also want to pick up...', style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.otherRides.map((ride) => OtherRideCard(ride)).toList(),
                        ),
                      ),
                      selectedRides.isNotEmpty ? SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          padding: EdgeInsets.all(16),
                          //TODO: change rider ID to rider name
                          color: Colors.black,
                          child: Text('Drop off ' + (selectedRides.length == 1 ?
                          selectedRides[0].riderId[0] :
                          'Multiple Passengers'),
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)),
                          onPressed: () {
                            //TODO: add action when press drop off
                          },
                        ),
                      ) : Container()
                    ]
                ),
              ),
            )
        )
    );
  }
}