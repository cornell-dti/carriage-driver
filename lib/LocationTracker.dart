import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';

// manages position updates
abstract class LocationTracker {
  // minimum displacement from last position update
  // required to send another update, in meters
  static final double displacementFilter = 10.0;

  // TODO: placeholder
  static final TimeOfDay startTime = TimeOfDay(hour: 7, minute: 30);
  static final TimeOfDay endTime = TimeOfDay(hour: 20, minute: 20);

  static StreamSubscription<LocationResult> subscription;

  static double _todToDouble(TimeOfDay tod) {
    return tod.hour.toDouble() + (tod.minute.toDouble() / 60);
  }
  static bool _timeInRange(TimeOfDay start, TimeOfDay end, TimeOfDay time) {
    double dblTime = _todToDouble(time);
    double dblStart = _todToDouble(start);
    double dblEnd = _todToDouble(end);
    return dblTime >= dblStart && dblTime <= dblEnd;
  }
  static bool _isWorkingHours() => _timeInRange(startTime,endTime,TimeOfDay.now()); 

  static Future<bool> _requestPermission() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(
      permission: const LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );
    return result.isSuccessful;
  }

  static void _handlePosition(LocationResult r) {
    if (r.isSuccessful) {
      // TODO: report position to dispatcher
      // to test:
      // double lat = r.location.latitude;
      // double lng = r.location.longitude;
      // log("position: $lat, $lng");
    } else {
      switch (r.error.type) {
        case GeolocationResultErrorType.runtime:
          // runtime error, check result.error.message
          break;
        case GeolocationResultErrorType.locationNotFound:
          // location request did not return any result
          break;

        case GeolocationResultErrorType.serviceDisabled:
        // location services disabled on device
        // might be that GPS is turned off, or parental control (android)
        case GeolocationResultErrorType.permissionNotGranted:
        // location has not been requested yet
        // app must request permission in order to access the location
        case GeolocationResultErrorType.permissionDenied:
        // user denied the location permission for the app
        // rejection is final on iOS, and can be on Android if user checks `don't ask again`
        // user will need to manually allow the app from the settings, see requestLocationPermission(openSettingsIfDenied: true)
        case GeolocationResultErrorType.playServicesUnavailable:
          // android only
          // result.error.additionalInfo contains more details on the play services error
          throw new Exception("Not possible.");
      }
    }
  }

  static Future<bool> initialize() async {
    bool success = await _requestPermission();
    if (!success) return false;
    if (subscription != null) {
      subscription.cancel();
    }
    if(_isWorkingHours()) {
      subscription = Geolocation.locationUpdates(
        accuracy: LocationAccuracy.best,
        displacementFilter: displacementFilter,
        inBackground: true,
      ).listen((result) {
        if (result.isSuccessful) {
          _handlePosition(result);
        }
        if(!_isWorkingHours()) {
          subscription.cancel();
        }
      });
    }
    return true;
  }
}
