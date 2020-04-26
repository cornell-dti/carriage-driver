import 'dart:convert';
import 'package:carriage/app_config.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'app_config.dart';
import 'main_common.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

_handleSignIn() async {
  try {
    await googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount currentUser;
  String id;

  setCurrentUser(GoogleSignInAccount account) {
    setState(() {
      currentUser = account;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = null;
    id = null;
    try {
      googleSignIn.signInSilently();
    } catch (error) {
      googleSignIn.signIn();
    }
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setCurrentUser(account);
      tokenFromAccount(currentUser).then((token) async {
        return await authenticationRequest(
            AppConfig.of(context).baseUrl, token, currentUser.email);
      }).then((response) {
        var json = jsonDecode(response);
        setState(() {
          if (!json.containsKey('id')) {
            id = null;
            currentUser = null;
          } else {
            id = json['id'];
          }
        });
        return id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Scaffold(
          body: Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 150),
                  SizedBox(height: 50),
                  SignInButton()
                ],
              ))));
    } else {
      assert(googleSignIn.currentUser.displayName != null);
      assert(googleSignIn.currentUser.email != null);
      assert(googleSignIn.currentUser.photoUrl != null);
      //assert(id != null);
      String name = googleSignIn.currentUser.displayName;
      String email = googleSignIn.currentUser.email;
      String imageUrl = googleSignIn.currentUser.photoUrl;
      String driverID = id;
      return Home(name, email, imageUrl, driverID);
    }
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          _handleSignIn();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/google_logo.png'),
                    height: 35.0),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
              ],
            )));
  }
}
