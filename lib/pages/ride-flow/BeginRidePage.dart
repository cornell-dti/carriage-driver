import 'package:carriage/pages/Home.dart';
import '../../utils/MeasureRect.dart';
import '../../models/Ride.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:carriage/widgets/RideStops.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../providers/RidesProvider.dart';
import '../../utils/CarriageTheme.dart';
import '../Home.dart';
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
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        widget.ride.rider.profilePicture(64),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.ride.rider.firstName,
              style: CarriageTheme.title1,
            ),
            widget.ride.rider.accessibilityNeeds.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(widget.ride.rider.accessibilityNeeds.join(', '), style: CarriageTheme.body))
                : Container()
          ],
        )
      ]),
    );
  }

  Widget _homeButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home())),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.arrow_back_ios, size: 21), Text("Home", style: TextStyle(fontSize: 17))]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonVerticalPadding = 16;
    double buttonHeight = 48;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LoadingOverlay(
            color: Colors.white,
            opacity: 0.3,
            isLoading: _requestedContinue,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: buttonHeight + 2 * buttonVerticalPadding + 42),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _homeButton(),
                        SizedBox(height: 36),
                        _picAndName(context),
                        SizedBox(height: 54),
                        RideStops(ride: widget.ride, carIcon: false),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 34, vertical: buttonVerticalPadding),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          blurRadius: 10, spreadRadius: 1, offset: Offset(0, -2), color: Colors.black.withOpacity(0.05))
                    ]),
                    child: MeasureRect(
                      onChange: widget.onContinueRectChange,
                      child: CButton(
                          text: "Begin Ride",
                          hasShadow: true,
                          onPressed: () async {
                            if (_requestedContinue) return;
                            setState(() => _requestedContinue = true);
                            final response = await updateRideStatus(context, widget.ride.id, RideStatus.ON_THE_WAY);
                            if (!mounted) return;
                            if (response.statusCode == 200) {
                              widget.ride.status = RideStatus.ON_THE_WAY;
                              RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
                              ridesProvider.changeRideToCurrent(widget.ride);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => OnTheWayPage(ride: widget.ride)));
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
