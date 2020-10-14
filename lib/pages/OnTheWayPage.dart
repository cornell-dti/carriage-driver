import 'package:carriage/Ride.dart';
import 'package:carriage/pages/PickUpPage.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

// TODO: replace with real model later
class _TempPageData {
  final String firstName;
  final ImageProvider<dynamic> photo;
  final DateTime time;
  final String stop;
  final String address;
  final String rideId;

  _TempPageData(this.firstName, this.photo, this.time, this.stop, this.address,
      this.rideId);
}

class OnTheWayPage extends StatefulWidget {
  @override
  _OnTheWayPageState createState() => _OnTheWayPageState();
}

class _OnTheWayPageState extends State<OnTheWayPage> {
  final _TempPageData data = _TempPageData(
      "Alex",
      NetworkImage(
          "https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-001_1-225x225.jpg"),
      DateTime.now(),
      "Upson Hall",
      "124",
      "d38dab88-ace5-42b6-ae60-ca1d1dc8cde7");

  bool _requestedContinue = false;

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
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("On your way to...",
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 59),
                RideInfoCard(data.firstName, data.photo, false, data.stop,
                    data.address, data.time),
                Expanded(child: SizedBox()),
                CButton(
                    text: "Arrive",
                    onPressed: () async {
                      if (_requestedContinue) return;
                      setState(() => _requestedContinue = true);
                      final response = await updateRideStatus(
                          context, data.rideId, RideStatus.ARRIVED);
                      if (!mounted) return;
                      if (response.statusCode == 200) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PickUpPage()));
                      } else {
                        setState(() => _requestedContinue = false);
                        throw Exception('Failed to update ride status');
                      }
                    }),
                DangerButton(
                    text: "Notify Delay",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => ConfirmDialog(
                                actionName: "Notify",
                                onConfirm: () {
                                  // TODO: notify delay functionality
                                },
                                content: Text(
                                    "Do you want to notify the rider about your delay?"),
                              ),
                          barrierDismissible: true);
                    })
              ],
            ),
          ),
        ));
  }
}
