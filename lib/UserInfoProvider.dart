import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'AuthProvider.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

class UserInfoProvider with ChangeNotifier {
  String firstName;
  String lastName;
  String fullName() => firstName + " " + lastName;
  String email;
  String photoUrl;

  final retryDelay = Duration(seconds: 30);

  UserInfoProvider(AppConfig config, AuthProvider auth) {
    void Function() callback;
    callback = () {
      if (auth.isAuthenticated) {
        photoUrl = auth.googleSignIn.currentUser.photoUrl;
        requestInfo(config, auth.id);
      }
    };
    callback();
    auth.addListener(callback);
  }

  Future<void> requestInfo(AppConfig config, String id) async {
    await http.get("${config.baseUrl}/drivers/$id").then((response) async {
      if(response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        firstName = json["firstName"];
        lastName = json["lastName"];
        email = json["email"];
        notifyListeners();
      } else {
        // TODO: retry only in certain circumstances
        await Future.delayed(retryDelay);
        requestInfo(config,id);
      }
    });
  }
}
