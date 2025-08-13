import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Notification_data.dart';
import 'package:Silaaty/data/model/Notification_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';

class ShwoNotificationcontroller extends GetxController {
  NotificationData notificationData = NotificationData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Notifications> notification = [];
  int? id;

  ShwoNotification() async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {
      "id": id,
    };
    var response = await notificationData.ShwoinfoNotification(data);
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Notification_Model.fromJson(response);
      notification = model.data!.notifications ?? [];
      if (notification.isEmpty) {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  deleteNotification(int? id) async {
    update();
    Map data = {
      "id": id,
    };
    var response = await notificationData.deleteNotification(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("==================================================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Get.back();
      Get.back(result: true);

      showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operationFailed".tr, Colors.orange);
    }
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    ShwoNotification();
    print("============================================== $id");
    super.onInit();
  }
}
