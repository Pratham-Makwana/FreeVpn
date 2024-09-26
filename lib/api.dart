import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:http/http.dart';
import 'package:vpn_basic_project/models/vpn.dart';

class APIs {
  static Future<void> getVPNServer() async {
    List<Vpn> vpnList = [];
    final res = await get(Uri.parse('https://www.vpngate.net/api/iphone/'));
    final csvString = res.body.split("#")[1].replaceAll('*', '');

    List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

    final header = list[0];

    for (int i = 1; i < header.length; ++i) {
      Map<String, dynamic> tempJson = {};
      for (int j = 0; j < header.length; ++j) {
        tempJson.addAll({header[j].toString(): list[i][j]});
      }
      vpnList.add(Vpn.fromJson(tempJson));
    }

    log(vpnList.first.hostname);
  }
}

// Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36

// For Understanding Purpose

//*** CSV Data ***
// Name,    Country,  Ping
// Test1,   JP,       12
// Test2,   US,       112
// Test3,   IN,       7

//*** List Data ***
// [ [Name, Country, Ping], [Test1, JP, 12], [Test2, US, 112], [Test3, IN, 7] ]

//*** Json Data ***
// {"Name": "Test1", "Country": "JP", "Ping": 12}
