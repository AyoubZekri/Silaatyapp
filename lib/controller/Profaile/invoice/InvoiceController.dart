import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/functions/Snacpar.dart';
import '../../../core/services/Services.dart';

class InvoicesController extends GetxController {
  int selectedIndex = 3;
  String? uuid;
  late TextEditingController dateController;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Statusrequest statusrequest = Statusrequest.none;
  Invoicedata invoicedata = Invoicedata(Get.find());
  InvoiceData? invoice;

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  addInvoice() async {
    if (formstate.currentState!.validate()) {
      final String uuidinvoice = Uuid().v4();
      update();
      Map<String, Object?> data = {
        "uuid": uuidinvoice,
        'Transaction_uuid': uuid,
        'invoies_payment_date': dateController.text,
        "user_id": id,
        "invoies_numper":
            DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10),
        "invoies_date": DateTime.now().toIso8601String(),
        "created_at": DateTime.now().toIso8601String(),
      };
      var result = await invoicedata.addinvoice(data);

      print("==================================================$result");

      if (result["status"] == 1) {
        dateController.clear();
        Get.back();
        showInvoice();
        Get.find<RefreshService>().fire();
        showSnackbar("success".tr, "add_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operation_failed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  EditInvoice(String invuuid) async {
    if (formstate.currentState!.validate()) {

      Map<String, Object?> data = {
        "uuid": invuuid,
        'invoies_payment_date': dateController.text,
      };
      var result = await invoicedata.Editinvoise(data);

      print("==================================================$result");

      if (result) {
        dateController.clear();
        Get.back();
        Get.find<RefreshService>().fire();
        showInvoice();
        showSnackbar("success".tr, "edit_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operation_failed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  deleteInvoice(String invuuid) async {

    Map<String, Object?> data = {
      "uuid": invuuid,
    };
    var result = await invoicedata.deleteinvoice(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      Get.back();
      showInvoice();
      Get.find<RefreshService>().fire();
      showSnackbar("success".tr, "delete_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  showInvoice() async {
    update();
    Map<String, Object?> data = {'transaction_uuid': uuid};
    var rseult = await invoicedata.getMyInvoicesByTransaction(data);
    print("==================================================$rseult");

    if (rseult.isNotEmpty) {
      final model = InvoiceData.fromJson(rseult['data']);
      invoice = model;
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  switchtransactions(int idtrn) async {
    update();
    Map<String, Object?> data = {'uuid': uuid};
    var result = await invoicedata.switchStatus(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      showSnackbar("success".tr, "switchSuccess".tr, Colors.green);
      showInvoice();
    } else {
      showSnackbar("error".tr, "switchFailed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  gotoNewSale() {
    Get.toNamed(Approutes.newSale, arguments: {
      "type": invoice!.transaction!.transactions,
      "uuid": invoice!.transaction!.uuid,
      "name": invoice!.transaction!.name,
      "famlyname": invoice!.transaction!.familyName,
    });
  }

  Future<void> gotoShowInvoice(InvoiceItem invoice) async {
    final result = await Get.toNamed(
      Approutes.shwoinvoice,
      arguments: {"invoice": invoice},
    );
    if (result == true) {
      showInvoice();
    }
  }

  @override
  void onInit() {
    dateController = TextEditingController();
    uuid = Get.arguments["uuid"];
    showInvoice();
    super.onInit();
  }

  String getRemainingAmount() {
    final total = invoice?.sumPrice ?? 0.0;
    final paid = invoice?.sumPaymentPrice ?? 0.0;
    final remaining = total - paid;
    return remaining.toStringAsFixed(2);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  String getMonthAbbreviation(String? date) {
    if (date == null || date.length < 7) return '';
    final month = date.substring(5, 7);
    const months = {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Apr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Aug',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    };
    return months[month] ?? '';
  }

  refreshData() async {
    await showInvoice();
    update();
  }
}
