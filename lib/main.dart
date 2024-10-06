import "package:firebase_core/firebase_core.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vpn_basic_project/helper/ad_helper.dart';
import 'package:vpn_basic_project/helper/config.dart';
import 'package:vpn_basic_project/helper/pref.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

/// global object for accessing device screen size
late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  /// firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// initializing remote config
  await Config.initConfig();
  await Pref.initializeHive();

  await AdHelper.initAds();

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

      /// theme
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 21),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        color: Colors.blue,
        elevation: 3,
      )),

      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      /// dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 21),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 3,
        ),
      ),
      title: 'OpenVpn Demo',
      home: SplashScreen(),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Pref.isDarkMode ? Colors.white70 : Colors.black54;

  Color get bottomNav => Pref.isDarkMode ? Colors.white12 : Colors.blue;

  Color get vpnCard => Pref.isDarkMode ? Colors.white12 : Colors.white;
}
