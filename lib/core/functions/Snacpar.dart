import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String titleKey, String messageKey, Color color) {
  IconData iconData;

  if (color == Colors.green) {
    iconData = Icons.check_circle;
  } else if (color == Colors.red) {
    iconData = Icons.error;
  } else if (color == Colors.orange) {
    iconData = Icons.warning;
  } else {
    iconData = Icons.info;
  }

  Get.snackbar(
    titleKey.tr,
    messageKey.tr,
    backgroundColor: color,
    colorText: Colors.white,
    icon: Icon(iconData, color: Colors.white),
    snackPosition: SnackPosition.TOP,
  );
}
