import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Carriage',
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'SFPro',
            accentColor: Color.fromRGBO(60, 60, 67, 0.6),
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              subhead: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              display1: TextStyle(fontSize: 17.0, color: Colors.black),
            )),
        home: Login());
  }
}

String localhost() {
  if(Platform.isAndroid) {
    return 'http://10.0.2.2:3000';
  } else {
    return 'http://localhost:3000';
  }
}

_authenticationRequest() async {
  Response response = await post(localhost(), body: {});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}