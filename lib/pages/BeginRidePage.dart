import 'package:carriage/MeasureRect.dart';
import 'package:carriage/MeasureSize.dart';
import 'package:carriage/Ride.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/RideDestPickupCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../RidesProvider.dart';
import 'OnTheWayPage.dart';

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

class Stops extends StatefulWidget {
  final Ride ride;

  const Stops({Key key, @required this.ride}) : super(key: key);

  @override
  StopsState createState() => StopsState();
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
            child: ListView(shrinkWrap: true, children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Container(width: 52, child: _StopCircle(false)),
                    Expanded(
                      child: RideDestPickupCard(false, widget.ride.startTime,
                          widget.ride.startLocation, widget.ride.startAddress),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Container(width: 52, child: _StopCircle(true)),
                    Expanded(
                      child: RideDestPickupCard(true, widget.ride.endTime,
                          widget.ride.endLocation, widget.ride.endAddress),
                    ),
                  ],
                ),
              )
            ])),
      ]),
    );
  }
}

class BeginRidePage extends StatefulWidget {
  final OnWidgetRectChange onContinueRectChange;
  static void onChangeDefault(Rect s) {}
  BeginRidePage({this.ride, this.onContinueRectChange = onChangeDefault});
  final Ride ride;
  @override
  _BeginRidePageState createState() => _BeginRidePageState();
}

class _BeginRidePageState extends State<BeginRidePage> {
  bool _requestedContinue = false;

  Widget _picAndName(BuildContext context) {
    return Center(
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        CircleAvatar(
          radius: 60.5,
          backgroundImage: AssetImage('assets/images/terry.jpg'),
        ),
        SizedBox(width: 16),
        Column(
          children: [
            Text(widget.ride.rider.firstName,
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
                Stops(ride: widget.ride),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MeasureRect(
                    onChange: widget.onContinueRectChange,
                    child: CButton(
                        text: "Begin Ride",
                        onPressed: () async {
                          if (_requestedContinue) return;
                          setState(() => _requestedContinue = true);
                          final response = await updateRideStatus(
                              context, widget.ride.id, RideStatus.ON_THE_WAY);
                          if (!mounted) return;
                          if (response.statusCode == 200) {
                            widget.ride.status = RideStatus.ON_THE_WAY;
                            RidesProvider ridesProvider =
                                Provider.of<RidesProvider>(context,
                                    listen: false);
                            ridesProvider.changeRideToCurrent(widget.ride);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OnTheWayPage(ride: widget.ride)));
                          } else {
                            setState(() => _requestedContinue = false);
                            throw Exception('Failed to update ride status');
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
