import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controller/loading_controller.dart';
import 'package:vpn_basic_project/controller/native_ad_controller.dart';
import 'package:vpn_basic_project/helper/ad_helper.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';

import '../main.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = LocationController();
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVpnData();

    _adController.ad = AdHelper.loadNativeAd(controller: _adController);
    return Obx(
      () => Scaffold(
        // app bar
        appBar: AppBar(
          title: Text('VPN Locations(${_controller.vpnList.length})'),
        ),

        bottomNavigationBar:
            _adController.ad != null && _adController.adLoaded.isTrue
                ? SizedBox(height: 80, child: AdWidget(ad: _adController.ad!) )
                : null,

        /// Refresh Vpn Data
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () => _controller.getVpnData(),
            child: Icon(
              CupertinoIcons.refresh,
              color: Colors.white,
            ),
          ),
        ),

        body: _controller.isLoading.value
            ? _loadingWidget()
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(),
      ),
    );
  }

  _vpnData() => ListView.builder(
        itemCount: _controller.vpnList.length,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            left: mq.width * .04,
            right: mq.width * .04,
            top: mq.height * .015,
            bottom: mq.height * .05),
        itemBuilder: (BuildContext context, int index) {
          return VpnCard(
            vpn: _controller.vpnList[index],
          );
        },
      );

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
