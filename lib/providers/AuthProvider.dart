import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_config.dart';

Future<String> auth(String baseUrl, String token, String email) async {
  String endpoint = baseUrl + '/auth';
  Map<String, dynamic> requestBody = {
    "token": token,
    "email": email,
    "clientId": Platform.isAndroid
        ? "241748771473-0r3v31qcthi2kj09e5qk96mhsm5omrvr.apps.googleusercontent.com"
        : "241748771473-e85o2d6heucd28loiq5aacese38ln4l4.apps.googleusercontent.com",
    "table": "Drivers"
  };
  return post(Uri.parse(endpoint), body: requestBody).then((res) {
    return res.body;
  });
}

Future<String> tokenFromAccount(GoogleSignInAccount account) async {
  return account.authentication.then((auth) {
    return auth.idToken;
  }).catchError((e) {
    print('tokenFromAccount - $e');
    return null;
  });
}

class AuthProvider with ChangeNotifier {
  String id;
  StreamSubscription _userAuthSub;
  GoogleSignIn googleSignIn;
  FlutterSecureStorage secureStorage;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  AuthProvider(BuildContext context) {
    secureStorage = FlutterSecureStorage();
    googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);
    _userAuthSub = googleSignIn.onCurrentUserChanged.listen((newUser) async {
      if (newUser != null) {
        String googleToken = await tokenFromAccount(newUser);
        Map<String, dynamic> authResponse = jsonDecode(await auth(
            AppConfig.of(context).baseUrl, googleToken, newUser.email));
        String token = authResponse['jwt'];
        Map<String, dynamic> jwt = JwtDecoder.decode(token);
        id = jwt['id'];
        await secureStorage.write(key: 'token', value: token);

        notifyListeners();
      } else {
        id = null;
      }
    });
  }

  @override
  void dispose() {
    if (_userAuthSub != null) {
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
