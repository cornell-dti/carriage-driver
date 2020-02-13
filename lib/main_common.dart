import 'package:flutter/material.dart';
import 'app_config.dart';
import 'Login.dart';

void mainCommon() {

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context);
    return _buildApp(config.baseUrl);
  }

  Widget _buildApp(String baseUrl) {
    return MaterialApp(
        title: 'Carriage',
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'SFPro',
            accentColor: Color.fromRGBO(60, 60, 67, 0.6),
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              subhead: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            )),
        home: Login());
  }
}
