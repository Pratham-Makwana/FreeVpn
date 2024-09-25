import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';

import '../main.dart';
import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _vpnState = VpnEngine.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;

  final RxBool _startTimer = false.obs;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      setState(() => _vpnState = event);
    });

    initVpn();
  }

  void initVpn() async {
    //sample vpn config file (you can get more from https://www.vpngate.net/)
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/japan.ovpn'),
        country: 'Japan',
        username: 'vpn',
        password: 'vpn'));

    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/thailand.ovpn'),
        country: 'Thailand',
        username: 'vpn',
        password: 'vpn'));

    SchedulerBinding.instance.addPostFrameCallback(
        (t) => setState(() => _selectedVpn = _listVpn.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          CupertinoIcons.home,
        ),
        title: Text('OpenVPN Demo'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.brightness_4_outlined,
                size: 26,
              )),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.info,
                size: 26,
              ))
        ],
      ),
      bottomNavigationBar: _changeLocation(),

      /// /body
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _vpnButton(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// country flag
            HomeCard(
                title: 'Country',
                subtitle: 'Free',
                icon: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 30,
                  child: Icon(
                    color: Colors.white,
                    Icons.vpn_lock_rounded,
                    size: 30,
                  ),
                )),

            /// Ping time
            HomeCard(
                title: '100 ms',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// download
            HomeCard(
              title: '0 kbps',
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
              title: '100 ms',
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
        )
      ]),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_vpnState == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

  Widget _vpnButton() => Column(
        children: [
          /// vpn button
          Semantics(
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                _startTimer.value = !_startTimer.value;
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue.withOpacity(.1)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(.3)),
                  child: Container(
                    height: mq.height * .14,
                    width: mq.height * .14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
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
                          'Tap to connect',
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
              'Not Connect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),

          Obx(() => CountDownTimer(startTimer: _startTimer.value)),
        ],
      );

  /// bottom nav to change location
  Widget _changeLocation() => SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
          color: Colors.blue,
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
