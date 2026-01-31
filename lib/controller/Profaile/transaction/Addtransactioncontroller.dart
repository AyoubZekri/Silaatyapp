import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/functions/Snacpar.dart';
import '../../../core/services/Services.dart';

class AddTransactionController extends GetxController {
  int? type;

  final nameController = TextEditingController();
  final familyNameController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final Transactiondata transactionData = Transactiondata(Get.find());

  Statusrequest statusRequest = Statusrequest.none;

  int? userid = Get.find<Myservices>().sharedPreferences?.getInt("id");

  @override
  void onInit() {
    type = Get.arguments?["type"];
    super.onInit();
  }

  Future<void> addTransaction() async {
    if (!formKey.currentState!.validate()) return;
    update();
    final String uuid = Uuid().v4();

    final data = {
      "uuid": uuid,
      "user_id": userid,
      'transactions': type.toString(),
      'name': nameController.text.trim(),
      'family_name': familyNameController.text.trim(),
      'phone_number': phoneController.text.trim(),
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };

    final result = await transactionData.addtransaction(data);

    if (result == true) {
      Get.back(result: true);
      // showSnackbar("success".tr, "add_success".tr, Colors.green);
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
