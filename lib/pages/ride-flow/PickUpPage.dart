import '../../utils/MeasureRect.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/Dialogs.dart';
import 'package:carriage/widgets/RideStops.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../utils/CarriageTheme.dart';
import '../Home.dart';
import '../../providers/RidesProvider.dart';
import '../../models/Ride.dart';

class PickUpPage extends StatefulWidget {
  final OnWidgetRectChange onContinueRectChange;
  static void onChangeDefault(Rect s) {}
  final Ride ride;

  PickUpPage({this.ride, this.onContinueRectChange = onChangeDefault});
  @override
  _PickUpPageState createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  bool _requestedContinue = false;

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    int numRides = ridesProvider.currentRides.length;

    return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          color: Colors.white,
          opacity: 0.3,
          isLoading: _requestedContinue,
          child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      CalendarButton(),
                      Divider(
                          height: 12
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Is ${widget.ride.rider.firstName} here?", style: CarriageTheme.title2)
                      ),
                      SizedBox(height: 12),
                      Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  //TODO: replace with rider image
                                  backgroundImage: AssetImage('assets/images/terry.jpg'),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 38,
                                  child: CallButton(widget.ride.rider.phoneNumber, 30)
                                )
                              ]
                            ),
                            SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.ride.rider.firstName, style: CarriageTheme.title3),
                                widget.ride.rider.accessibilityNeeds.length > 0 ?
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(widget.ride.rider.accessibilityNeeds.join(', '),
                                      style: CarriageTheme.body),
                                ) : Container(),
                              ],
                            )
                          ]
                      ),
                      SizedBox(height: 16),
                      RideStops(ride: widget.ride, carIcon: true, largeSpacing: false),
                      Spacer(),
                      MeasureRect(
                        onChange: widget.onContinueRectChange,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: CButton(
                              text: "Pick up",
                              onPressed: () async {
                                if (_requestedContinue) return;
                                setState(() => _requestedContinue = true);
                                final response = await updateRideStatus(
                                    context, widget.ride.id, RideStatus.PICKED_UP);
                                if (!mounted) return;
                                if (response.statusCode == 200) {
                                  setState(() => _requestedContinue = false);
                                  widget.ride.status = RideStatus.PICKED_UP;
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (BuildContext context) => Home())
                                  );
                                } else {
                                  setState(() => _requestedContinue = false);
                                  throw Exception('Failed to update ride status');
                                }
                              }),
                        ),
                      ),
                      DangerButton(
                          text: "Report No Show",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => ConfirmDialog(
                                  title: "Report No Show",
                                  content: "Would you like to report a no show to the dispatcher?",
                                  actionName: "Report",
                                  onConfirm: () async {
                                    final noShowResponse = await updateRideStatus(context, widget.ride.id, RideStatus.NO_SHOW);
                                    if (noShowResponse.statusCode == 200) {
                                      final pastResponse = await setRideToPast(context, widget.ride.id);
                                      if (pastResponse.statusCode == 200) {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (BuildContext context) => Home())
                                        );
                                      }
                                      else {
                                        throw 'Failed to set no-show ride to past: ' + pastResponse.body;
                                      }
                                    }
                                    else {
                                      throw 'Failed to set no-show ride status: ' + noShowResponse.body;
                                    }
                                  },
                                ),
                                barrierDismissible: true);
                          }
                      ),
                    ],
                  ),
                ),
              )
          )
        ));
  }
}
