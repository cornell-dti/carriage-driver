import 'dart:async';
import 'dart:developer';

import 'package:geolocation/geolocation.dart';

// manages position updates
abstract class LocationTracker {
  static StreamSubscription<LocationResult> subscription;

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
      double lat = r.location.latitude;
      double lng = r.location.longitude;
      // TODO: report position to dispatcher
      log("position: $lat, $lng");
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
          break;
        case GeolocationResultErrorType.permissionNotGranted:
          // location has not been requested yet
          // app must request permission in order to access the location
          break;
        case GeolocationResultErrorType.permissionDenied:
          // user denied the location permission for the app
          // rejection is final on iOS, and can be on Android if user checks `don't ask again`
          // user will need to manually allow the app from the settings, see requestLocationPermission(openSettingsIfDenied: true)
          break;
        case GeolocationResultErrorType.playServicesUnavailable:
          // android only
          // result.error.additionalInfo contains more details on the play services error
          switch (r.error.additionalInfo as GeolocationAndroidPlayServices) {
            // TODO: show a dialog inviting the user to install/update play services
            case GeolocationAndroidPlayServices.missing:
            case GeolocationAndroidPlayServices.updating:
            case GeolocationAndroidPlayServices.versionUpdateRequired:
            case GeolocationAndroidPlayServices.disabled:
            case GeolocationAndroidPlayServices.invalid:
          }
          break;
      }
    }
  }

  static Future<bool> initialize() async {
    bool success = await _requestPermission();
    if (!success) return false;
    if (subscription != null) {
      subscription.cancel();
    }
    subscription = Geolocation.locationUpdates(
      accuracy: LocationAccuracy.best,
      displacementFilter: 10.0, // in meters
      inBackground: true,
    ).listen((result) {
      if (result.isSuccessful) {
        _handlePosition(result);
      }
    });
    return true;
  }
}
