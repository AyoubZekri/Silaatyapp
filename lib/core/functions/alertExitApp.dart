import 'dart:io';

import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    backgroundColor: AppColor.white,
    title: "Alert".tr,
    titleStyle: const TextStyle(
        fontWeight: FontWeight.bold, color: AppColor.backgroundcolor),
    middleText: "هل تريد الخروج من التطبيق".tr,
    onConfirm: () {
      exit(0);
    },
    onCancel: () {},
    buttonColor: AppColor.backgroundcolor,
    confirmTextColor: AppColor.primarycolor,
    cancelTextColor: AppColor.backgroundcolor,
  );
  return Future.value(true);
}
