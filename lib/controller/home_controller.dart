import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helper/ad_helper.dart';
import 'package:vpn_basic_project/helper/my_dialogs.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import '../helper/pref.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToVpn() {
    ///Stop right here if user not select a vpn
    if (vpn.value.openVPNConfigDataBase64.isEmpty) {
      MyDialogs.success(
          msg: 'Select a Location by clicking \'Change Location\'');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      log('\nBefore ${vpn.value.openVPNConfigDataBase64}');

      /// Base64Decoder convert to into Uint8List
      final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);

      /// Utf8Decoder convert to String
      final config = Utf8Decoder().convert(data);

      final vpnConfig = VpnConfig(
          country: vpn.value.countryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);
      log('\nAfter $vpnConfig');

      ///Start if stage is disconnected
      AdHelper.showInterstitialAd(onComplete: () async {
        await VpnEngine.startVpn(vpnConfig);
        ;
      });
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

  /// vpn button color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.orangeAccent;
    }
  }

  /// vpn button text
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';
      case VpnEngine.vpnConnected:
        return 'Disconnect';
      default:
        return 'Connecting...';
    }
  }
}
