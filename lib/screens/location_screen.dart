import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/api.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getVPNServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: Text('VPN Locations'),
      ),
      body: _loadingWidget(),
    );
  }

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// lottie animation
            LottieBuilder.asset('assets/lottie/loading.json'),
          ],
        ),
      );

  _noVPNFound() => Center(
        child: Text(
          "VPNs Not Found",
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
