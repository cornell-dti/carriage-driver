import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main_common.dart';
import 'utils/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AppConfig configuredApp = AppConfig(
    baseUrl: "https://carriage-pratyush1712.cloud.okteto.net/api",
    child: MyApp(),
  );

  runApp(configuredApp);

  mainCommon();
}
