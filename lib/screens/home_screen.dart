import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controller/home_controller.dart';
import 'package:vpn_basic_project/helper/config.dart';
import 'package:vpn_basic_project/helper/pref.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/screens/network_test_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import 'package:vpn_basic_project/widgets/watch_ad_dialog.dart';
import '../helper/ad_helper.dart';
import '../main.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          CupertinoIcons.home,
        ),
        title: Text('OpenVPN Demo'),
        actions: [
          IconButton(
              onPressed: () {
                // hideAds
                if (Config.hideAds) {
                  Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  Pref.isDarkMode = !Pref.isDarkMode;
                  return;
                }
                // ads dialog
                Get.dialog(WatchAdDialog(onComplete: () {
                  // Watch Ads to gain reward
                  AdHelper.showRewardAd(onComplete: () {
                    Get.changeThemeMode(
                        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                    Pref.isDarkMode = !Pref.isDarkMode;
                  });
                }));

                // Get.changeThemeMode(
                //     Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                // Pref.isDarkMode = !Pref.isDarkMode;
              },
              icon: Icon(
                Icons.brightness_4_outlined,
                size: 26,
              )),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () {
                Get.to(() => NetworkTestScreen());
              },
              icon: Icon(
                CupertinoIcons.info,
                size: 26,
              ))
        ],
      ),
      bottomNavigationBar: _changeLocation(context),

      /// /body
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        /// von button
        Obx(() => _vpnButton()),

        /// ping time
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// country flag
              HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? 'Country'
                      : _controller.vpn.value.countryLong,
                  subtitle: 'Free',
                  icon: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 30,
                    child: _controller.vpn.value.countryLong.isEmpty
                        ? Icon(
                            color: Colors.white,
                            Icons.vpn_lock_rounded,
                            size: 30,
                          )
                        : null,
                    backgroundImage: _controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                  )),

              /// Ping time
              HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? '100 ms'
                      : '${_controller.vpn.value.ping} ms',
                  subtitle: 'PING',
                  icon: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 30,
                    child: Icon(
                      Icons.equalizer_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  )),
            ],
          ),
        ),

        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// download
              HomeCard(
                title: _controller.vpnState.value == VpnEngine.vpnConnected
                    ? '${snapshot.data?.byteIn ?? '0 kbps'}'
                    : '0 kbps',
                subtitle: 'DOWNLOAD',
                icon: CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  radius: 30,
                  child: Icon(
                    color: Colors.white,
                    Icons.arrow_downward_rounded,
                    size: 30,
                  ),
                ),
              ),

              /// upload
              HomeCard(
                title: _controller.vpnState.value == VpnEngine.vpnConnected
                    ? '${snapshot.data?.byteOut ?? '0 kbps'}'
                    : '0 kbps',
                subtitle: 'UPLOAD',
                icon: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _vpnButton() => Column(
        children: [
          /// vpn button
          Semantics(
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                _controller.connectToVpn();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    height: mq.height * .14,
                    width: mq.height * .14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// icon
                        Icon(
                          Icons.power_settings_new,
                          size: 28,
                          color: Colors.white,
                        ),

                        /// adding some space
                        SizedBox(
                          height: 4,
                        ),

                        /// text
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// connection status label
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connect'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),

          Obx(() => CountDownTimer(
              startTimer:
                  _controller.vpnState.value == VpnEngine.vpnConnected)),
        ],
      );

  /// bottom nav to change location
  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              color: Theme.of(context).bottomNav,
              height: 60,
              child: Row(
                children: [
                  /// icon
                  Icon(
                    CupertinoIcons.globe,
                    color: Colors.white,
                    size: 28,
                  ),

                  /// for adding some space
                  SizedBox(
                    width: 10,
                  ),

                  /// text
                  Text(
                    'Change Location',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),

                  /// for covering available space
                  Spacer(),

                  /// icon
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

//
// Center(
// child: TextButton(
// style: TextButton.styleFrom(
// shape: StadiumBorder(),
// backgroundColor: Theme.of(context).primaryColor,
// ),
// child: Text(
// _vpnState == VpnEngine.vpnDisconnected
// ? 'Connect VPN'
//     : _vpnState.replaceAll("_", " ").toUpperCase(),
// style: TextStyle(color: Colors.white),
// ),
// onPressed: _connectClick,
// ),
// ),
// StreamBuilder<VpnStatus?>(
// initialData: VpnStatus(),
// stream: VpnEngine.vpnStatusSnapshot(),
// builder: (context, snapshot) => Text(
// "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
// textAlign: TextAlign.center),
// ),
//
// //sample vpn list
// Column(
// children: _listVpn
//     .map(
// (e) => ListTile(
// title: Text(e.country),
// leading: SizedBox(
// height: 20,
// width: 20,
// child: Center(
// child: _selectedVpn == e
// ? CircleAvatar(backgroundColor: Colors.green)
//     : CircleAvatar(backgroundColor: Colors.grey)),
// ),
// onTap: () {
// log("${e.country} is selected");
// setState(() => _selectedVpn = e);
// },
// ),
// )
// .toList())
