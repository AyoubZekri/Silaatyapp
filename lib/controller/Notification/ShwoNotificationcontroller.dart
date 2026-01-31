import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/Notification_data.dart';
import 'package:Silaaty/data/model/Notification_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';

class ShwoNotificationcontroller extends GetxController {
  NotificationData notificationData = NotificationData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Notifications> notification = [];
  String? uuid;

  ShwoNotification() async {

    Map<String, Object?> data = {
      "uuid": uuid,
    };
    var result = await notificationData.ShwoinfoNotification(data);
    print("============================================== $result");
    if (result["status"] == 1) {
      final model = Notification_Model.fromJson(result);
      notification = model.data!.notifications ?? [];
      statusrequest = Statusrequest.success;
      if (notification.isEmpty) {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  deleteNotification(String? uuid) async {
    update();
    Map<String, Object?> data = {
      "uuid": uuid,
    };
    var result = await notificationData.deleteNotification(data);

    print("==================================================$result");
    if (result["status"] == 1) {
      statusrequest = Statusrequest.success;
      Get.back();
      Get.back(result: true);
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operationFailed".tr, Colors.orange);
    }
  }

  @override
  void onInit() {
    uuid = Get.arguments['uuid'];
    ShwoNotification();
    super.onInit();
  }
}
