import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

Future<String> auth(String baseUrl, String token, String email) async {
  String endpoint = baseUrl + '/auth';
  Map<String, dynamic> requestBody = {
    "token": token,
    "email": email,
    "clientID":
        "241748771473-0r3v31qcthi2kj09e5qk96mhsm5omrvr.apps.googleusercontent.com",
    "table": "Drivers"
  };
  return post(endpoint, body: requestBody).then((res) {
    return res.body;
  });
}

Future<String> tokenFromAccount(GoogleSignInAccount account) async {
  GoogleSignInAuthentication auth;
  try {
    auth = await account.authentication;
    print('okay');
  } catch (error) {
    return null;
  }
  return auth.idToken;
}

class AuthProvider with ChangeNotifier {
  String id;
  StreamSubscription _userAuthSub;
  GoogleSignIn googleSignIn;

  AuthProvider() {
    googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);
    _userAuthSub = googleSignIn.onCurrentUserChanged.listen((newUser) async {
      if (newUser != null) {
        id = await tokenFromAccount(newUser).then((token) async {
          // BuildContext inaccessible from ChangeNotifier, so no Flavors :/
          String baseUrl = Platform.isAndroid ? "http://10.0.2.2:3001" : "http://localhost:3001";
          return auth(baseUrl, token, newUser.email);
        }).then((response) {
          Map<String, dynamic> json = jsonDecode(response);
          if (!json.containsKey('id')) {
            return null;
          }
          return json['id'];
        });
      } else {
        id = null;
      }
      notifyListeners();
    }, onError: (e) {
      print('AuthProvider - GoogleSignIn - onCurrentUserChanged - $e');
    });
  }

  @override
  void dispose() {
    if(_userAuthSub != null) {
      _userAuthSub.cancel();
      _userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return id != null;
  }

  void signIn() {
    googleSignIn.signIn();
  }

  void signInSilently() {
    googleSignIn.signInSilently();
  }

  void signOut() {
    googleSignIn.signOut();
    id = null;
}
} 