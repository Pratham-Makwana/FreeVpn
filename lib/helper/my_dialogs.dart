import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogs {
  static success({required String msg}) {
    Get.snackbar(
      'Success',
      msg,
      backgroundColor: Colors.green.withOpacity(.9),
      colorText: Colors.white,
    );
  }

  static error({required String msg}) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: Colors.redAccent.withOpacity(.9),
      colorText: Colors.white,
    );
  }

  static info({required String msg}) {
    Get.snackbar(
      'info',
      msg,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  static showProgress() {
    Get.dialog(Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }
}
