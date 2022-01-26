import 'package:carriage/providers/AuthProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    try {
      authProvider.signInSilently();
    } catch (e) {
      print(
          'User has not logged in previously, therefore, we should not proceed');
    }
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
//        mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Welcome to Carriage',
                        style: TextStyle(fontSize: 33, color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Sign in using your Cornell email',
                      style: TextStyle(fontSize: 15, color: Colors.white54)),
                ],
              ),
            ),
            Image.asset(
              'assets/images/app_logo.png',
              height: 270,
              width: 270,
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: SignInButton(),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    return TextButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.6, 50)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.grey;
            return null; // Defer to the widget's default.
          }),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)))),
      onPressed: () {
        authProvider.signIn();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage('assets/images/google_logo.png'),
                height: 20.0),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      //    ),
    );
  }
}
