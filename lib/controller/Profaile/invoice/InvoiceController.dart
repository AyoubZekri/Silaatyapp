
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/model/invoice_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/functions/Snacpar.dart';

class InvoicesController extends GetxController {
  int selectedIndex = 3;
  int? id;
  late TextEditingController dateController;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Statusrequest statusrequest = Statusrequest.none;
  Invoicedata invoicedata = Invoicedata(Get.find());
  Data? invoice;

  addInvoice() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        'Transaction_id': id,
        'invoies_payment_date': dateController.text,
      };
      var response = await invoicedata.addinvoice(data);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("==================================================$response");
      statusrequest = handlingData(response);

      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        dateController.clear();
        Get.back();
        showInvoice();
        showSnackbar("success".tr, "add_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operation_failed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  EditInvoice(int invid) async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": invid,
        'invoies_payment_date': dateController.text,
      };
      var response = await invoicedata.Editinvoise(data);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("==================================================$response");
      statusrequest = handlingData(response);

      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        dateController.clear();
        Get.back();
        showInvoice();
        showSnackbar("success".tr, "edit_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operation_failed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  deleteInvoice(int invid) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {
      "id": invid,
    };
    var response = await invoicedata.deleteinvoice(data);
    print("==================================================$response");
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Get.back();
      showInvoice();
      showSnackbar("success".tr, "delete_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  showInvoice() async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {'transaction_id': id};
    var response = await invoicedata.Shwoinvoice(data);
    print("==================================================$response");
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final model = invoice_Model.fromJson(response);
        invoice = model.data;
        if (invoice == null) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  switchtransactions(int idtrn) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {'id': id};
    var response = await invoicedata.switchStatus(data);
    print("==================================================$response");
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        showSnackbar("success".tr, "switchSuccess".tr, Colors.green);
        showInvoice();
      } else {
        showSnackbar("error".tr, "switchFailed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  Future<void> gotoShowInvoice(int id) async {
    final result =
        await Get.toNamed(Approutes.shwoinvoice, arguments: {"id": id});
    if (result == true) {
      showInvoice();
    }
  }

  Future<void> gotoShowInvoiceDealer(int id) async {
    final result =
        await Get.toNamed(Approutes.shwoinvoicedealer, arguments: {"id": id});
    if (result == true) {
      showInvoice();
    }
  }

  @override
  void onInit() {
    dateController = TextEditingController();
    id = Get.arguments["id"];
    showInvoice();
    super.onInit();
  }

  String getRemainingAmount() {
    final sum = double.tryParse(invoice?.sumPrice.toString() ?? '0') ?? 0.0;
    final paid =
        double.tryParse(invoice?.sumpaymentPrice.toString() ?? '0') ?? 0.0;
    return (sum - paid).toStringAsFixed(2);
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
