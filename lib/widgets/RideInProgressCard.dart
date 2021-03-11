import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/CarriageTheme.dart';
import '../models/Ride.dart';

class RideInProgressCard extends StatelessWidget {
  RideInProgressCard(Key key, this.ride, this.selected, this.selectCallback)
      : super(key: key);
  final Ride ride;
  final Function selectCallback;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectCallback(ride);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
            color:
            selected ? Color.fromRGBO(167, 167, 167, 0.4) : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [CarriageTheme.shadow]),
        child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, top: 8),
                child: selected
                    ? Icon(Icons.check_circle, size: 20, color: Colors.black)
                    : Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color.fromRGBO(196, 196, 196, 0.5)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(ride.rider.photoLink),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                      child: Text(ride.rider.firstName,
                          style: Theme.of(context).textTheme.subtitle2)),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'To ',
                        style: CarriageTheme.subheadline.copyWith(color: CarriageTheme.gray2),
                        children: [
                          TextSpan(
                              text: ride.endLocation,
                              style: TextStyle(
                                  fontFamily: 'SFText',
                                  fontSize: 15,
                                  color: Colors.black,
                                  letterSpacing: -0.24,
                                  fontWeight: FontWeight.w600)
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                        text: 'Drop off by ',
                        style: TextStyle(
                            fontFamily: 'SFText',
                            fontSize: 15,
                            color: CarriageTheme.gray1,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                              text: DateFormat('jm').format(ride.endTime),
                              style: TextStyle(
                                  fontFamily: 'SFText',
                                  fontSize: 15,
                                  color: CarriageTheme.gray1,
                                  fontWeight: FontWeight.w600
                              )
                          )
                        ]
                    ),
                  ),
                ]
                ),
              ),
            ]
        ),
      ),
    );
  }
}