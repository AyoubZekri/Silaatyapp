import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/functions/Snacpar.dart';

class AddTransactionController extends GetxController {
  int? type;

  final nameController = TextEditingController();
  final familyNameController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final Transactiondata transactionData = Transactiondata(Get.find());

  Statusrequest statusRequest = Statusrequest.none;

  @override
  void onInit() {
    type = Get.arguments?["type"];
    super.onInit();
  }

  Future<void> addTransaction() async {
    if (!formKey.currentState!.validate()) return;

    statusRequest = Statusrequest.loadeng;
    update();

    final data = {
      'transactions': type.toString(),
      'name': nameController.text.trim(),
      'family_name': familyNameController.text.trim(),
      'phone_number': phoneController.text.trim(),
    };

    final response = await transactionData.addtransaction(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
      Get.back(result: true);
      showSnackbar("success".tr, "add_success".tr, Colors.green);
    } else {
      statusRequest = Statusrequest.failure;
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }

    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    familyNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
