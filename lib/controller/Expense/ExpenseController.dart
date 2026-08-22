import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Expense_data.dart';
import 'package:Silaaty/data/model/Expense_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class Expensecontroller extends GetxController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  final nameEditController = TextEditingController();
  final priceEditController = TextEditingController();
  final descriptionEditController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  ExpenseData expenseData = ExpenseData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Expense> expense = [];

  double get totalExpenses {
    double total = 0.0;
    for (var e in expense) {
      total += (e.price ?? 0.0);
    }
    return total;
  }

  getExpense() async {
    update();
    var result = await expenseData.ShwoExpense();

    print("============================================== $result");
    if (result["status"] == 1) {
      final model = Expense_Model.fromJson(result);
      expense = model.data!.expense ?? [];
      expense.isEmpty
          ? statusrequest = Statusrequest.failure
          : statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  addExpense() async {
    if (formstate.currentState!.validate()) {
      final uuid = Uuid().v4();
      update();
      Map<String, Object?> data = {
        "uuid": uuid,
        "name": nameController.text,
        "price": double.tryParse(priceController.text) ?? 0.0,
        "description": descriptionController.text,
        "user_id": id,
        "created_at": DateTime.now().toIso8601String(),
      };
      var result = await expenseData.addExpense(data);
      print("==================================================$result");
      if (result["status"] == 1) {
        statusrequest = Statusrequest.success;
        nameController.clear();
        priceController.clear();
        descriptionController.clear();
        Get.back();
        getExpense();
        // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }
    }
  }

  EditExpense(String? uuid) async {
    if (formstate.currentState!.validate()) {
      Map<String, Object?> data = {
        "uuid": uuid,
        "name": nameEditController.text,
        "price": double.tryParse(priceEditController.text) ?? 0.0,
        "description": descriptionEditController.text,
        "updated_at": DateTime.now().toIso8601String(),
      };
      var result = await expenseData.EditExpense(data);

      print("==================================================$result");
      if (result["status"] == 1) {
        statusrequest = Statusrequest.success;
        nameEditController.clear();
        priceEditController.clear();
        descriptionEditController.clear();
        Get.back();
        getExpense();
        // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }
    }
  }

  deleteExpense(String? uuid) async {
    update();
    Map<String, Object?> data = {
      "uuid": uuid,
      'updated_at': DateTime.now().toIso8601String(),
    };
    var result = await expenseData.deleteExpense(data);
    print("==================================================$result");
    if (result["status"] == 1) {
      statusrequest = Statusrequest.success;
      Get.back();
      getExpense();
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  refreshdata() async {
    await getExpense();
  }

  @override
  void onInit() {
    getExpense();
    super.onInit();
  }
}
