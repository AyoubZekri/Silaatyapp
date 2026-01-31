import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Notification_data.dart';
import 'package:Silaaty/data/model/Notification_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';

class Notificaitioncontroller extends GetxController {
  NotificationData notificationData = NotificationData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Notifications> notification = [];

  getNotification() async {
    update();

    var result = await notificationData.ShwoNotification();
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
      'is_delete': 1,
      'updated_at': DateTime.now().toIso8601String(),
    };
    var result = await notificationData.deleteNotification(data);

    print("==================================================$result");
    if (result["status"] == 1) {
      statusrequest = Statusrequest.success;
      Get.back();
      getNotification();
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operationFailed".tr, Colors.orange);
    }
  }

  Future<void> Gotoshownotification(String? uuid) async {
    final result = await Get.toNamed(Approutes.shwonotification,
        arguments: {"uuid": uuid});
    if (result == true) {
      getNotification();
    }
  }

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  refreshdata() async {
    await getNotification();
  }
}
