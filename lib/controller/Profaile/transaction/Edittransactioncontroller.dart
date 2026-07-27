import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:Silaaty/data/model/transaction_Model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/functions/Snacpar.dart';
import '../../../core/services/Services.dart';

class EditTransactionController extends GetxController {
  int? type;
  String? uuid;

  final nameController = TextEditingController();
  final familyNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();
  final supplierProductsController = TextEditingController();
  int? customerSaleType;

  final formKey = GlobalKey<FormState>();
  final Transactiondata transactiondata = Transactiondata(Get.find());

  Statusrequest statusrequest = Statusrequest.none;
  int get sellType => Get.find<Myservices>().sharedPreferences?.getInt("sell_type") ?? 3;

  Future<void> editTransaction() async {
    if (!formKey.currentState!.validate()) return;

    update();

    final data = {
      "uuid": uuid,
      "transactions": type.toString(),
      "name": nameController.text,
      "family_name": familyNameController.text,
      "phone_number": phoneController.text,
      "address": addressController.text,
      "notes": notesController.text,
      "supplier_products": supplierProductsController.text,
      "customer_sale_type": customerSaleType?.toString() ?? '',
      "updated_at": DateTime.now().toIso8601String(),
    };

    final result = await transactiondata.edittransaction(data);

    print("================================================== $result");

    if (result == true) {
      Get.back(result: true);
      // showSnackbar("success".tr, "edit_success".tr, Colors.green);
    } else {
      statusrequest = Statusrequest.failure;
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }

    update();
  }

  void initData(Data trans) {
    uuid = trans.transaction?.uuid;
    type = trans.transaction?.transactions;
    nameController.text = trans.transaction?.name ?? "";
    familyNameController.text = trans.transaction?.familyName ?? "";
    phoneController.text = trans.transaction?.phoneNumber ?? "";
    addressController.text = trans.transaction?.address ?? "";
    notesController.text = trans.transaction?.notes ?? "";
    supplierProductsController.text = trans.transaction?.supplierProducts ?? "";
    customerSaleType = int.tryParse(trans.transaction?.customerSaleType ?? '');
  }

  @override
  void onClose() {
    nameController.dispose();
    familyNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    supplierProductsController.dispose();
    super.onClose();
  }
}
