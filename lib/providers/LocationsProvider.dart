import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import './AuthProvider.dart';
import '../utils/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Location.dart';

//Manage the state of locations with ChangeNotifier
class LocationsProvider with ChangeNotifier {
  List<Location> locations;
  List<Location> favLocations;
  Map<String, Location> locationsByName = Map();

  LocationsProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () async {
      if (authProvider.isAuthenticated) {
        await fetchLocations(config, authProvider);
        locations.forEach((loc) => locationsByName[loc.name] = loc);
      }
    };
    callback();
  }

  final retryDelay = Duration(seconds: 30);

  bool hasLocations() {
    return locations != null;
  }

  bool hasFavLocations() {
    return favLocations != null;
  }

  //Fetches all the locations from the backend as a list by using the baseUrl of [config] and id from [authProvider].
  Future<void> fetchLocations(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get('${config.baseUrl}/locations',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      String responseBody = response.body;
      locations = _locationsFromJson(responseBody);
      notifyListeners();
    } else {
      await Future.delayed(retryDelay);
      fetchLocations(config, authProvider);
    }
  }

  //Decodes the string [json] of locations into a list representation of the locations.
  List<Location> _locationsFromJson(String json) {
    var data = jsonDecode(json)['data'];
    List<Location> res =
        data.map<Location>((e) => Location.fromJson(e)).toList();
    return res;
  }

  bool isPreset(String name) {
    return locationsByName[name] != null;
  }
}
