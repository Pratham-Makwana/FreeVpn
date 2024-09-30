import 'package:get/get.dart';
import 'package:vpn_basic_project/models/vpn.dart';

import '../api/api.dart';

class LoadingController extends GetxController {
  List<Vpn> vpnList = [];
  final RxBool isLoading = false.obs;

  Future<void> getVpnData() async {
    isLoading.value = true;
    vpnList.clear();
    vpnList = await APIs.getVPNServer();
    isLoading.value = false;
  }
}
