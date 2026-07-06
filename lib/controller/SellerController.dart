import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:Silaaty/data/datasource/Remote/SellerData.dart';

import '../core/class/Crud.dart';
import '../core/functions/handlingdatacontroller.dart';

class SellerController extends GetxController {
  SellerData sellerData = SellerData(Get.find<Crud>());
  Statusrequest statusrequest = Statusrequest.none;

  List sellers = [];

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  showPassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    getSellers();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  getSellers() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await sellerData.getSellers();
    statusrequest = handlingData(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        sellers = response['data']['sellers'] ?? [];
      } else {
        sellers = [];
      }
    }
    update();
  }

  addSeller() async {
    if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();

    var response = await sellerData.addSeller(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        Get.back();
        getSellers();
        nameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("خطأ".tr, "لم يتم إضافة البائع".tr, Colors.red);
      }
    }
    update();
  }

  updateSeller(int id) async {
    if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();

    var response = await sellerData.updateSeller(
      id,
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        Get.back();
        getSellers();
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("خطأ".tr, "لم يتم التعديل".tr, Colors.red);
      }
    }
    update();
  }

  deleteSeller(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await sellerData.deleteSeller(id);

    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        getSellers();
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("خطأ".tr, "لم يتم حذف البائع".tr, Colors.red);
      }
    }
    update();
  }

  void openAddDialog() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    // Usually triggered in UI, but controller handles state reset
  }

  void openEditDialog(Map seller) {
    nameController.text = seller['name'];
    emailController.text = seller['email'];
    passwordController.clear(); // Ensure password is clear for edit
  }
}
