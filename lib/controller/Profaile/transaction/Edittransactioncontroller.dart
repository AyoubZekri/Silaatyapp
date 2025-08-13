import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:Silaaty/data/model/transaction_Model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/functions/Snacpar.dart';

class EditTransactionController extends GetxController {
  int? type;
  int? id;

  final nameController = TextEditingController();
  final familyNameController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final Transactiondata transactiondata = Transactiondata(Get.find());

  Statusrequest statusrequest = Statusrequest.none;

  Future<void> editTransaction() async {
    if (!formKey.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();

    final data = {
      "id": id,
      "transactions": type.toString(),
      "name": nameController.text,
      "family_name": familyNameController.text,
      "phone_number": phoneController.text,
    };

    final response = await transactiondata.Edittransaction(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("================================================== $response");

    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Get.back(result: true);
      showSnackbar("success".tr, "edit_success".tr, Colors.green);
    } else {
      statusrequest = Statusrequest.failure;
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }

    update();
  }

  void initData(Data trans) {
    id = trans.transaction?.id;
    type = trans.transaction?.transactions;
    nameController.text = trans.transaction?.name ?? "";
    familyNameController.text = trans.transaction?.familyName ?? "";
    phoneController.text = trans.transaction?.phoneNumber ?? "";
  }



  @override
  void onClose() {
    nameController.dispose();
    familyNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
