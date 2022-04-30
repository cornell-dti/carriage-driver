import 'package:carriage/pages/Onboarding.dart';
import 'package:carriage/providers/LocationsProvider.dart';
import 'package:carriage/providers/NotificationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'providers/AuthProvider.dart';
import 'pages/Home.dart';
import 'providers/DriverProvider.dart';
import 'utils/app_config.dart';
import 'pages/Login.dart';
import 'providers/RidesProvider.dart';

void mainCommon() async {
  // Prevent screen from sleeping
  await Wakelock.enable();
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
      child: ChangeNotifierProvider<DriverProvider>(
        create: (BuildContext context) {
          return DriverProvider(
              config, Provider.of<AuthProvider>(context, listen: false));
        },
        child: ChangeNotifierProvider<RidesProvider>(
          create: (BuildContext context) {
            return RidesProvider(
                config, Provider.of<AuthProvider>(context, listen: false));
          },
          child: ChangeNotifierProvider<LocationsProvider>(
            create: (BuildContext context) {
              return LocationsProvider(
                  config, Provider.of<AuthProvider>(context, listen: false));
            },
            child: ChangeNotifierProvider<NotificationsProvider>(
              create: (BuildContext context) {
                return NotificationsProvider();
              },
              child: MaterialApp(
                  title: 'Carriage Driver',
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'Inter',
                      accentColor: Color.fromRGBO(60, 60, 67, 0.6)),
                  home: HomeOrLogin()),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeOrLogin extends StatelessWidget {
  HomeOrLogin({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAuthenticated ? HomeOrOnboarding() : Login();
  }
}

class HomeOrOnboarding extends StatelessWidget {
  HomeOrOnboarding({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<bool> checkAndSetFirstLogin() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool firstLogin = prefs.getBool('loggedInPreviously') == null;
      if (firstLogin) {
        await prefs.setBool('loggedInPreviously', true);
      }
      return firstLogin;
    }

    return FutureBuilder<bool>(
        future: checkAndSetFirstLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool firstLogin = snapshot.data;
            return firstLogin ? Onboarding() : Home();
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
