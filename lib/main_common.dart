import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import 'Home.dart';
import 'app_config.dart';
import 'Login.dart';

void mainCommon() {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context);
    return _buildApp(context, config.baseUrl);
  }

  Widget _buildApp(BuildContext context, String baseUrl) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (BuildContext context) {
          return AuthProvider(context);
        })
      ],
      child: MaterialApp(
          title: 'Carriage',
          theme: ThemeData(
              primarySwatch: Colors.red,
              fontFamily: 'SFPro',
              accentColor: Color.fromRGBO(60, 60, 67, 0.6),
              textTheme: TextTheme(
                  headline:
                      TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  subhead:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  display1:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  display2:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                  display3: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.normal))),
          home: HomeOrLogin()),
    );
  }
}

class HomeOrLogin extends StatelessWidget {
  HomeOrLogin({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAuthenticated ? Home() : Login();
  }
}
