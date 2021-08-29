import 'dart:convert';
import 'dart:io';

import 'package:carriage/models/Driver.dart';
import 'package:flutter/widgets.dart';
import 'AuthProvider.dart';
import '../utils/app_config.dart';
import 'package:http/http.dart' as http;

class DriverProvider with ChangeNotifier {
  Driver driver;
  bool hasInfo() => driver != null;

  final retryDelay = Duration(seconds: 30);

  DriverProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) requestInfo(config, authProvider);
    };
    callback();
    authProvider.addListener(callback);
  }

  void _setDriver(Driver newDriver) {
    this.driver = newDriver;
    notifyListeners();
  }

  /// Fetches the logged in driver's data and updates [driver] with the
  /// retrieved data. Retries continuously if the request fails.
  Future<void> requestInfo(AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    http.Response response = await http.get(
        "${config.baseUrl}/drivers/${authProvider.id}",
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setDriver(Driver.fromJson(json));
    } else {
      // TODO: retry only in certain circumstances
      await Future.delayed(retryDelay);
      requestInfo(config, authProvider);
    }
  }

  /// Updates the logged in driver's name.
  Future<void> updateName(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.put(
      "${config.baseUrl}/drivers/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setDriver(Driver.fromJson(json));
    } else {
      throw Exception('Failed to update driver.');
    }
  }

  /// Updates the logged in driver's phone number.
  Future<void> updatePhoneNumber(AppConfig config, AuthProvider authProvider,
      String phoneNumber) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.put(
      "${config.baseUrl}/drivers/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setDriver(Driver.fromJson(json));
    } else {
      throw Exception('Failed to update driver.');
    }
  }

  /// Updates the logged in driver's profile picture.
  Future<void> updateDriverPhoto(AppConfig config, AuthProvider authProvider,
      String base64Photo) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      "${config.baseUrl}/upload",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{
        'id': authProvider.id,
        'tableName': 'Drivers',
        'fileBuffer': base64Photo,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setDriver(Driver.fromJson(json));
    } else {
      print(response.body);
      throw Exception('Failed to update driver.');
    }
  }
}
