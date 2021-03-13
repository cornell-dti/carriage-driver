import 'dart:convert';
import 'dart:io';

import 'package:carriage/models/Driver.dart';
import 'package:flutter/widgets.dart';
import 'AuthProvider.dart';
import '../utils/app_config.dart';
import 'package:http/http.dart' as http;

class DriverProvider with ChangeNotifier {
  Driver info;
  bool hasInfo() => info != null;

  final retryDelay = Duration(seconds: 30);

  DriverProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) requestInfo(config, authProvider);
    };
    callback();
    authProvider.addListener(callback);
  }

  void _setInfo(Driver info) {
    this.info = info;
    notifyListeners();
  }

  /// Fetches the logged in driver's data and updates [info] with the
  /// retrieved data. Retries continuously if the request fails.
  Future<void> requestInfo(AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    http.Response response = await http.get(
        "${config.baseUrl}/drivers/${authProvider.id}",
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(Driver.fromJson(
          json, authProvider.googleSignIn.currentUser.photoUrl));
    } else {
      // TODO: retry only in certain circumstances
      await Future.delayed(retryDelay);
      requestInfo(config, authProvider);
    }
  }

  /// Updates the logged in driver's name and phone number.
  Future<void> updateDriver(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName, String phoneNumber) async {
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
        'phoneNumber': phoneNumber,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(Driver.fromJson(
          json, authProvider.googleSignIn.currentUser.photoUrl));
    } else {
      throw Exception('Failed to update driver.');
    }
  }
}
