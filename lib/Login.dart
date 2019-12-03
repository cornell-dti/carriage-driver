import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount currentUser; // this is synonymous with Google's currentUser

  setCurrentUser (GoogleSignInAccount account) {
    setState(() {
      currentUser = account;
    });
  }

  @override
  Widget build(BuildContext context) {
    googleSignIn.signInSilently();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setCurrentUser(account);
    });
    print(currentUser == null);
    if (currentUser == null) {
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
      return Home();
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

