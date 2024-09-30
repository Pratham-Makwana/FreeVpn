import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vpn_basic_project/helper/pref.dart';

import 'screens/splash_screen.dart';

/// global object for accessing device screen size
late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Pref.initializeHive();

  /// for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 21),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        color: Colors.blue,
        elevation: 3,
      )),
      title: 'OpenVpn Demo',
      home: SplashScreen(),
    );
  }
}
