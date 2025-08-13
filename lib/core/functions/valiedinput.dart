import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

validInput(String val, int max, int min, String type) {
  if (Type == 'username') {
    if (GetUtils.isUsername(val)) {
      return "not valid username";
    }
  }
  if (Type == 'Email') {
    if (GetUtils.isUsername(val)) {
      return "not valid Email";
    }
  }
  if (Type == 'phone') {
    if (GetUtils.isUsername(val)) {
      return "not valid phone";
    }
  }
  if (val.isEmpty) {
    return "Can't be Empty";
  }

  if (val.length > max) {
    return "Can't be larger than $max";
  }
  if (val.length < min) {
    return "Can't be less than $min";
  }
}

bool validInputsnak(String val, int min, int max, String type) {
  if (val.isEmpty) {
    showSnackbar("خطأ", "لا يمكن أن يكون الحقل فارغًا", Colors.red);
    return false;
  }

  if (val.length > max) {
    showSnackbar(
        "خطأ", "لا يمكن أن يكون حقل $type أطول من $max حرف", Colors.red);
    return false;
  }

  if (val.length < min) {
    showSnackbar(
        "خطأ", "لا يمكن أن يكون  حقل $type أقل من $min حرف", Colors.red);
    return false;
  }

  if (type == 'username' && !GetUtils.isUsername(val)) {
    showSnackbar("خطأ", "اسم المستخدم غير صالح", Colors.red);
    return false;
  }

  if (type == 'email' && !GetUtils.isEmail(val)) {
    showSnackbar("خطأ", "البريد الإلكتروني غير صالح", Colors.red);
    return false;
  }

  if (type == 'phone' && !GetUtils.isPhoneNumber(val)) {
    showSnackbar("خطأ", "رقم الهاتف غير صالح", Colors.red);
    return false;
  }

  return true;
}
