import 'package:Silaaty/controller/Profaile/transaction/Edittransactioncontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:Silaaty/data/model/transaction_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transactioncontroller extends GetxController {
  final Transactiondata transactiondata = Transactiondata(Get.find());
  List<Data> transaction = [];
  Statusrequest statusrequest = Statusrequest.none;
  int? type;

  getTransactions() async {
    statusrequest = Statusrequest.loadeng;
    update();

    Map data = {'transactions': type.toString()};
    var response = await transactiondata.Shwotransaction(data);
    print("============================================== $response");

    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final model = transaction_Model.fromJson(response);
        transaction = model.data ?? [];
        if (transaction.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  deletetransaction(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();

    Map data = {'id': id};
    var response = await transactiondata.deletetransaction(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("============================================== $response");

    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
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

  Future<void> GotoEditDealer() async {
    final trans = transaction[0];
    final controller = Get.put(EditTransactionController());
    controller.initData(trans);
    final result = await Get.toNamed(Approutes.EditDealer);
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoEditConvist() async {
    final trans = transaction[0];
    final controller = Get.put(EditTransactionController());
    controller.initData(trans);
    final result = await Get.toNamed(Approutes.EditConvict);
    if (result == true) {
      getTransactions();
    }
  }

  GotoinvoiceDealer(int id) {
    Get.toNamed(Approutes.invoicesdealer, arguments: {"id": id});
  }

  Gotoinvoiceconvist(int id) {
    Get.toNamed(Approutes.invoice, arguments: {"id": id});
  }

  @override
  void onInit() {
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
