import 'package:Silaaty/controller/Profaile/transaction/Edittransactioncontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:Silaaty/data/model/transaction_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transactioncontroller extends GetxController {
  final Transactiondata transactiondata = Transactiondata(Get.find());
  String query = "";

  List<Data> transaction = [];
  Statusrequest statusrequest = Statusrequest.none;
  int? type;

  getTransactions() async {
    update();

    Map<String, Object?> data = {
      'transactions': type.toString(),
      "query": query,
    };
    var result = await transactiondata.showTransactions(data);
    print("============================================== $result");

    if (result.isNotEmpty) {
      transaction =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  deletetransaction(String uuid) async {

    Map<String, Object?> data = {'uuid': uuid};
    var result = await transactiondata.deletetransaction(data);

    print("============================================== $result");

    if (result == true) {
      Get.back();
      getTransactions();
      showSnackbar("success".tr, "delete_success".tr, Colors.green);
    } else {
      statusrequest = Statusrequest.failure;
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }
    update();
  }

  Future<void> GotoAddDealer() async {
    final result =
        await Get.toNamed(Approutes.AddDealer, arguments: {"type": type});
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoAddConvict() async {
    final result =
        await Get.toNamed(Approutes.AddConvict, arguments: {"type": type});
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoEditDealer(String uuid) async {
    final trans = transaction.firstWhere(
      (t) => t.transaction!.uuid! == uuid,
      orElse: () => throw Exception("Transaction not found"),
    );
    final controller = Get.put(EditTransactionController());
    controller.initData(trans);
    final result = await Get.toNamed(Approutes.EditDealer);
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoEditConvist(String uuid) async {
    final trans = transaction.firstWhere(
      (t) => t.transaction!.uuid! == uuid,
      orElse: () => throw Exception("Transaction not found"),
    );
    final controller = Get.put(EditTransactionController());
    controller.initData(trans);
    final result = await Get.toNamed(Approutes.EditConvict);
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> Gotoinvoiceconvist(String uuid) async {
    final result =
        await Get.toNamed(Approutes.invoice, arguments: {"uuid": uuid});
    if (result == true) {
      getTransactions();
    }
  }

  GotoBacksale(String uuid, String name, String famlyname) {
    print("Returning customer: $name $famlyname");
    Get.back(result: {"uuid": uuid, "name": name, "famlyname": famlyname});
  }

  @override
  void onInit() {
    type = 0;
    type = Get.arguments["type"];
    getTransactions();
    super.onInit();
  }

  refreshData() async {
    await getTransactions();
    update();
  }

  void showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
    );
  }
}
