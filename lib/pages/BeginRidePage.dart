import 'package:carriage/MeasureSize.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/pages/OnTheWayPage.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/RideDestPickupCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class _StopCircle extends StatelessWidget {
  final bool _dropoff;

  _StopCircle(this._dropoff);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          width: 26,
          height: 26,
          decoration: new BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          )),
      Container(
          width: 8,
          height: 8,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: _dropoff ? BoxShape.rectangle : BoxShape.circle,
          ))
    ]);
  }
}

class StopData {
  final bool dropoff;
  final DateTime time;
  final String stop;
  final String address;

  StopData(this.dropoff, this.time, this.stop, this.address);
}

class Stops extends StatefulWidget {
  final List<StopData> stops;

  const Stops({Key key, @required this.stops}) : super(key: key);

  @override
  StopsState createState() {
    return StopsState();
  }
}

class StopsState extends State<Stops> {
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        Container(
          width: 52,
          height: _height,
          alignment: Alignment.topCenter,
          child: Container(
            width: 4,
            decoration: new BoxDecoration(
                color: const Color(0xFFECEBED),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
        ),
        MeasureSize(
          onChange: (size) {
            setState(() {
              _height = size.height;
            });
          },
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.stops.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 32);
              },
              itemBuilder: (context, index) {
                final stop = widget.stops[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Container(width: 52, child: _StopCircle(stop.dropoff)),
                      Expanded(
                        child: RideDestPickupCard(
                            stop.dropoff, stop.time, stop.stop, stop.address),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ]),
    );
  }
}

// TODO: replace with real model later
class TempPageData {
  final String firstName;
  final ImageProvider<dynamic> photo;
  final DateTime time;
  final String stop;
  final String address;
  final String rideId;
  final List<StopData> stops;

  TempPageData(this.firstName, this.photo, this.time, this.stop, this.address,
      this.rideId, this.stops);
}

class BeginRidePage extends StatefulWidget {
  @override
  _BeginRidePageState createState() => _BeginRidePageState();
}

class _BeginRidePageState extends State<BeginRidePage> {
  final TempPageData data = TempPageData(
      "Alex",
      NetworkImage(
          "https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-001_1-225x225.jpg"),
      DateTime.now(),
      "Upson Hall",
      "124",
      "d38dab88-ace5-42b6-ae60-ca1d1dc8cde7",
      [
        StopData(false, DateTime.now(), "Upson Hall", "124 Hoy Rd"),
        StopData(true, DateTime.now(), "Uris Hall", "109 Tower Rd")
      ]);

  bool _requestedContinue = false;

  Widget _picAndName(BuildContext context) {
    return Center(
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        CircleAvatar(
          radius: 60.5,
          backgroundImage: data.photo,
        ),
        SizedBox(width: 16),
        Column(
          children: [
            Text(data.firstName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ReturnHomeBar(),
        body: LoadingOverlay(
          color: Colors.white,
          opacity: 0.3,
          isLoading: _requestedContinue,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 15, top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _picAndName(context),
                SizedBox(height: 48),
                Stops(stops: data.stops),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CButton(
                      text: "Begin Ride",
                      onPressed: () async {
                        if (_requestedContinue) return;
                        setState(() => _requestedContinue = true);
                        final response = await updateRideStatus(
                            context, data.rideId, RideStatus.ON_THE_WAY);
                        if (!mounted) return;
                        if (response.statusCode == 200) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OnTheWayPage()));
                        } else {
                          setState(() => _requestedContinue = false);
                          throw Exception('Failed to update ride status');
                        }
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
