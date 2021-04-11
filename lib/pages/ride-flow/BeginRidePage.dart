import '../../utils/MeasureRect.dart';
import '../../models/Ride.dart';
import 'package:carriage/widgets/AppBars.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/RideStops.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../providers/RidesProvider.dart';
import '../../utils/CarriageTheme.dart';
import 'OnTheWayPage.dart';

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
        widget.ride.rider.profilePicture(100),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.ride.rider.firstName,
              style: CarriageTheme.title2,
            ),
            widget.ride.rider.accessibilityNeeds.length > 0
                ? Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(widget.ride.rider.accessibilityNeeds.join(', '),
                        style: CarriageTheme.body))
                : Container()
          ],
        )
      ]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BackBar('Home', Colors.white),
        body: LoadingOverlay(
          color: Colors.white,
          opacity: 0.3,
          isLoading: _requestedContinue,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 15, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _picAndName(context),
                SizedBox(height: 24),
                RideStops(
                    ride: widget.ride, carIcon: false, largeSpacing: true),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: MeasureRect(
                    onChange: widget.onContinueRectChange,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: CButton(
                          text: "Begin Ride",
                          hasShadow: true,
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
                ),
              ],
            ),
          ),
        ));
  }
}
