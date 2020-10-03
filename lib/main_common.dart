import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'AuthProvider.dart';
import 'Home.dart';
import 'UserInfoProvider.dart';
import 'app_config.dart';
import 'Login.dart';

void mainCommon() async {
  // Prevent screen from sleeping
  Wakelock.enable();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context);
    return _buildApp(context, config.baseUrl);
  }

  Widget _buildApp(BuildContext context, String baseUrl) {
    AppConfig config = AppConfig.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (BuildContext context) {
          return AuthProvider(context);
        })
      ],
      // UserInfoProvider is in a child widget because it uses AuthProvider
      child: ChangeNotifierProvider<UserInfoProvider>(
        create: (BuildContext context) {
          return UserInfoProvider(config, Provider.of<AuthProvider>(context, listen: false));
        },
        child: MaterialApp(
            title: 'Carriage',
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.red,
                fontFamily: 'SFPro',
                accentColor: Color.fromRGBO(60, 60, 67, 0.6),
                textTheme: TextTheme(
                    headline5:
                    TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    subtitle1:
                    TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                    headline4:
                    TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                    headline3: TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.normal),
                    headline2: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.normal))),
            home: HomeOrLogin()),
      ),
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
