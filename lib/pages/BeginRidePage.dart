import 'package:carriage/MeasureSize.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/RideDestPickupCard.dart';
import 'package:flutter/material.dart';

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

class _StopData {
  final bool dropoff;
  final DateTime time;
  final String stop;
  final String address;

  _StopData(this.dropoff, this.time, this.stop, this.address);
}

class Stops extends StatefulWidget {
  final List<_StopData> stops;

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
class _TempPageData {
  final String firstName;
  final ImageProvider<dynamic> photo;
  final DateTime time;
  final String stop;
  final String address;

  final List<_StopData> stops;

  _TempPageData(this.firstName, this.photo, this.time, this.stop, this.address,
      this.stops);
}

class BeginRidePage extends StatelessWidget {
  final _TempPageData data = _TempPageData(
      "Alex",
      NetworkImage(
          "https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-001_1-225x225.jpg"),
      DateTime.now(),
      "Upson Hall",
      "124",
      [
        _StopData(false, DateTime.now(), "Upson Hall", "124 Hoy Rd"),
        _StopData(true, DateTime.now(), "Uris Hall", "109 Tower Rd")
      ]);

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
        body: Padding(
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
                    onPressed: () {
                      // TODO: backend update functionality
                      // TODO: push next page in flow
                    }),
              ),
            ],
          ),
        ));
  }
}
