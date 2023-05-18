import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/CarriageTheme.dart';
import '../models/Ride.dart';

class RideInProgressCard extends StatelessWidget {
  RideInProgressCard(Key key, this.ride, this.selected, this.selectCallback) : super(key: key);
  final Ride ride;
  final Function selectCallback;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: selected ? CarriageTheme.gray3.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: selected
              ? [BoxShadow(blurRadius: 2, color: CarriageTheme.gray3.withOpacity(0.2))]
              : [CarriageTheme.shadow]),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () {
            selectCallback(ride);
          },
          child: Stack(children: [
            Padding(
                padding: EdgeInsets.only(left: 8, top: 8),
                child: selected
                    ? Icon(Icons.check_circle, size: 20, color: Colors.black)
                    : Icon(Icons.circle, size: 20, color: Color.fromRGBO(196, 196, 196, 0.5))),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ride.rider.profilePicture(32),
                      Positioned(
                          top: 16,
                          left: 23,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
                              ),
                              Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color.fromRGBO(111, 207, 151, 1)))
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Center(
                    child: Text(ride.rider.firstName,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            color: Colors.black,
                            letterSpacing: -0.41,
                            fontWeight: FontWeight.w700))),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                      text: 'To ',
                      style: CarriageTheme.subheadline.copyWith(fontFamily: 'Inter', color: CarriageTheme.gray2),
                      children: [
                        TextSpan(
                            text: ride.endLocation,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: Colors.black,
                                letterSpacing: -0.24,
                                fontWeight: FontWeight.w600))
                      ]),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                      text: 'Drop off by ',
                      style: TextStyle(
                          fontFamily: 'Inter', fontSize: 15, color: CarriageTheme.gray1, fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(
                            text: DateFormat('jm').format(ride.endTime),
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: CarriageTheme.gray1,
                                fontWeight: FontWeight.w600))
                      ]),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
