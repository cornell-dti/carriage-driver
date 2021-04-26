import 'package:carriage/pages/Profile.dart';
import 'package:carriage/pages/Rides.dart';
import 'package:flutter/material.dart';

import 'package:carriage/pages/Notifications.dart';
import 'package:carriage/pages/RideHistory.dart';
class PageNavigationProvider extends ChangeNotifier {
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int NOTIFS = 2;
  static const int PROFILE = 3;

  int _pageIndex = RIDES;
  final retryDelay = Duration(seconds: 30);
  int scrollHour;

  int getPageIndex() {
    return _pageIndex;
  }

  int getHourToScrollTo() {
    return scrollHour;
  }

  void changePage(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  void setScrollHour(int hour) {
    scrollHour = hour;
    notifyListeners();
  }

  void finishScroll() {
    scrollHour = null;
    notifyListeners();
  }

  Widget getPage() {
    switch (_pageIndex) {
      case (RIDES):
        return Rides(scrollToHour: scrollHour);
      case (HISTORY):
        return RideHistory();
      case (NOTIFS):
        return NotificationsPage();
      case (PROFILE):
        return SingleChildScrollView(child: Profile());
      default:
        return Column();
    }
  }
}