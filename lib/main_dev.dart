import 'app_config.dart';
import 'main_common.dart';
import 'package:flutter/material.dart';

void main() {
  var configuredApp = AppConfig(
    baseUrl: "http://10.0.2.2:3000",
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}