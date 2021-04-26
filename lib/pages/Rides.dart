import 'package:carriage/providers/AuthProvider.dart';
import 'package:carriage/providers/PageNavigationProvider.dart';
import 'package:carriage/utils/app_config.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../utils/MeasureRect.dart';
import '../providers/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/CarriageTheme.dart';
import '../models/Ride.dart';
import '../widgets/RideCard.dart';
import '../widgets/RideInProgressCard.dart';
import 'package:http/http.dart' as http;

class RidesStateless extends StatelessWidget {
  final List<Ride> currentRides;
  final List<Ride> remainingRides;
  final List<String> selectedRideIDs;
  final void Function() onDropoff;
  final void Function(Ride r) selectCallback;
  final OnWidgetRectChange firstCurrentRideRectCb;
  final OnWidgetRectChange firstRemainingRideRectCb;
  final int scrollToHour;

  static void onChangeDefault(Rect s) {}

  final bool interactive;

  const RidesStateless({
    Key key,
    this.currentRides,
    this.remainingRides,
    this.selectedRideIDs,
    this.onDropoff,
    this.selectCallback,
    this.firstCurrentRideRectCb = onChangeDefault,
    this.firstRemainingRideRectCb = onChangeDefault,
    this.scrollToHour
    this.interactive

  }) : super(key: key);

  Widget emptyPage(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.2;
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset('assets/images/steeringWheel@3x.png',
              width: imageSize,
              height: imageSize
          ),
          SizedBox(height: 22),
          Text(
            'Congratulations! You are done for the day. \n'
                'Come back tomorrow!',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget ridesInProgress(BuildContext context) {
    List<Widget> buildRideGrid(BuildContext context) {
      double spacing = 16;
      List<Widget> rideCards = currentRides.asMap().map((i, ride) {
        Widget card = Container(
            width: (MediaQuery.of(context).size.width / 2) - (spacing * 1.5),
            child: RideInProgressCard(Key(ride.id), ride,
                selectedRideIDs.contains(ride.id), selectCallback
            )
        );
        if (i == 0)
          card = MeasureRect(child: card, onChange: firstCurrentRideRectCb);
        return MapEntry(i, card);
      }).values.toList();

      List<Widget> result = [];
      while (rideCards.length > 0) {
        List<Widget> rowCards = rideCards.take(2).toList();
        rideCards.removeRange(0, rowCards.length);
        if (rowCards.length == 2) {
          rowCards.insert(1, SizedBox(width: spacing));
        }
        Widget row = IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowCards,
          ),
        );
        result.add(row);
        result.add(SizedBox(height: spacing));
      }
      return result;
    }
    return Container(
        child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: RideGroupTitle('In Progress', currentRides.length),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 24, bottom: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildRideGrid(context),
                  )
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollCtrl = ScrollController();
    Map<int, List<Ride>> groupsByHour = Map();

    for (Ride ride in remainingRides) {
      int hour = ride.startTime.hour;
      if (groupsByHour.containsKey(hour)) {
        groupsByHour[hour].add(ride);
      } else {
        groupsByHour[hour] = [ride];
      }
    }
    List<int> hours = groupsByHour.keys.toList();
    List<RideGroup> rideGroups = [];
    Map<int, GlobalKey> keysByHour = Map();
    hours.forEach((hour) {
      keysByHour[hour] = GlobalKey();
    });
    hours.asMap().forEach((index, hour) {
      rideGroups.add(
          RideGroup(keysByHour[hour], groupsByHour[hour], hour, index, firstRemainingRideRectCb)
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PageNavigationProvider pageNavProvider = Provider.of<PageNavigationProvider>(context, listen: false);
      int hourToScrollTo = pageNavProvider.getHourToScrollTo();
      if (hourToScrollTo != null) {
        RenderBox renderBox = keysByHour[hourToScrollTo].currentContext.findRenderObject();
        double yPos = renderBox.localToGlobal(Offset(0, -50)).dy;
        scrollCtrl.animateTo(yPos, duration: Duration(milliseconds: 500), curve: Curves.ease);
        pageNavProvider.finishScroll();
      }
    });

    Widget rideCards = ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hours.length,
      itemBuilder: (context, index) {
        int hour = hours[index];
        return RideGroup(
            rideGroups[hour], hour, index, firstRemainingRideRectCb, interactive);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 32);
      },
    );

  @override
  Widget build(BuildContext context) {
    bool emptyMainPage = interactive && currentRides.isEmpty && remainingRides.isEmpty; // no current or remaining
    bool emptyPreviewPage = !interactive && remainingRides.isEmpty; // the ride we're switching from will be a current ride, so just check remaining
    
    return Stack(
      children: [
        emptyMainPage || emptyPreviewPage ? Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              emptyPage(context),
            ],
          ),
        ) : Container(),
        Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
                controller: scrollCtrl,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32, left: 16, right: 16, bottom: 32),
                          child: Row(
                              children: [
                                Text(
                                    DateFormat('E').format(DateTime.now()) + '. ' + DateFormat('Md').format(DateTime.now()),
                                    style: CarriageTheme.largeTitle
                                ),
                                interactive ? Container() : Spacer(),
                                interactive ?
                                Container() : GestureDetector(
                                  child: Image.asset('assets/images/carButton.png', width: 24, height: 21),
                                  onTap: () => Navigator.of(context).pop(),
                                )
                              ]
                          ),
                        ),
                        interactive && currentRides.length > 0
                            ? ridesInProgress(context)
                            : Container(),
                        selectedRideIDs.isEmpty
                            ? Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: rideCards(context, remainingRides),
                        ) : Container()]
                  )
                ]
            )
        ),
        selectedRideIDs.isNotEmpty
            ? Positioned(
          bottom: 32,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
              const EdgeInsets.only(left: 34, right: 34),
              child: FlatButton(
                  padding: EdgeInsets.all(16),
                  color: Colors.black,
                  child: Text(
                      'Drop off ' +
                          (selectedRideIDs.length == 1
                              ? currentRides.where((ride) => ride.id == selectedRideIDs.single).single.rider.firstName
                              : 'Multiple Passengers'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  onPressed: onDropoff),
            ),
          ),
        ) : Container()
      ],
    );
  }
}

class Rides extends StatefulWidget {
  Rides({@required this.interactive, this.scrollToHour});
  final int scrollToHour;
  final bool interactive;

  @override
  _RidesState createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  List<String> selectedRideIDs = [];
  bool requestedDropOff = false;

  void _selectRide(Ride ride) {
    setState(() {
      if (!selectedRideIDs.contains(ride.id))
        selectedRideIDs.add(ride.id);
      else
        selectedRideIDs.remove(ride.id);
    });
  }

  Future<void> finishRide(BuildContext context, Ride ride) async {
    http.Response statusResponse =
    await updateRideStatus(context, ride.id, RideStatus.COMPLETED);
    if (statusResponse.statusCode == 200) {
      http.Response typeResponse = await setRideToPast(context, ride.id);
      if (typeResponse.statusCode == 200) {
        Provider.of<RidesProvider>(context, listen: false)
            .finishCurrentRide(ride);
      } else {
        throw Exception('Error setting ride type to past');
      }
    } else {
      throw Exception(
          'Error setting ride status to ${toString(RideStatus.COMPLETED)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AppConfig appConfig = AppConfig.of(context);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);

    Widget page = SafeArea(
      child: LoadingOverlay(
        color: Colors.white,
        opacity: 0.3,
        isLoading: requestedDropOff,
        child: RidesStateless(
              currentRides: ridesProvider.currentRides,
              remainingRides: ridesProvider.remainingRides,
              selectedRideIDs: selectedRideIDs,
              onDropoff: () async {
                setState(() {
                  requestedDropOff = true;
                });
                for (String id in selectedRideIDs) {
                  await finishRide(context, ridesProvider.currentRides.where((ride) => ride.id == id).single);
                }
                setState(() {
                  selectedRideIDs = [];
                  requestedDropOff = false;
                });
              },
              selectCallback: _selectRide,
              interactive: widget.interactive
          ),
      ),
    );

    return !ridesProvider.hasActiveRides() ? Center(child: CircularProgressIndicator()) :
    widget.interactive ? RefreshIndicator(
        onRefresh: () async {
          await ridesProvider.requestActiveRides(appConfig, authProvider);
        },
        child: page
    ) : page;
  }
}

class RideGroupTitle extends StatelessWidget {
  RideGroupTitle(this.title, this.numRides);
  final String title;
  final int numRides;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title,
          style: CarriageTheme.title3.copyWith(color: CarriageTheme.gray1)),
      SizedBox(width: 24),
      Image.asset('assets/images/peopleIcon.png', width: 20, height: 12),
      SizedBox(width: 8),
      Text(numRides.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 17, color: Colors.black))
    ]);
  }
}

class RideGroup extends StatelessWidget {
  RideGroup(this.key, this.rides, this.hour, this.groupIndex, this.firstRemainingRideRectCb, this.interactive): super(key: key);
  final GlobalKey key;
  final int hour;
  final List<Ride> rides;
  final int groupIndex;
  final Function firstRemainingRideRectCb;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    DateTime startHour = DateTime(0, 0, 0, hour, 0);
    DateTime endHour = startHour.add(Duration(hours: 1));

    String title = DateFormat('jm').format(startHour) + ' ~ ' + DateFormat('jm').format(endHour);

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: ListView.separated(
        itemCount: rides.length + 1,
        itemBuilder: (context, index) {
          index -= 1;
          // title
          if (index == -1) {
            return Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: RideGroupTitle(title, rides.length),
            );
          }
          Widget w = Opacity(
              opacity: interactive ? 1 : 0.5,
              child: RideCard(rides[index])
          );
          if (!interactive) {
            w = IgnorePointer(child: w);
          }
          if (index == 0 && groupIndex == 0)
            w = MeasureRect(child: w, onChange: firstRemainingRideRectCb);
          return w;
        },
        separatorBuilder: (context, index) {
          return index > 0 ? SizedBox(height: 16) : Container();
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}