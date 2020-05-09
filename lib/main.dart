import 'app_config.dart';
import 'main_common.dart';
import 'package:flutter/material.dart';

void main() {
  AppConfig configuredApp = AppConfig(
    baseUrl: "https://carriage-web.herokuapp.com",
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
