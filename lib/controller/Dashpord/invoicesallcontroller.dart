import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class Invoicesallcontroller extends GetxController {
  int selectedIndex = 1;

  Invoicedata invoicedata = Invoicedata(Get.find());

  Statusrequest statusrequest = Statusrequest.none;
  List<InvoiceItem> invoices = [];
  List<InvoiceItem> filteredInvoices = [];
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  showInvoice() async {
    var result = await invoicedata.allinvoise();
    print("==================================================$result");

    if (result.isNotEmpty) {
      final invoicesJson = result['data']['invoices'] as List<dynamic>;
      invoices =
          invoicesJson.map((json) => InvoiceItem.fromJson(json)).toList();
      filteredInvoices = invoices;
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void searchInvoices(String query) {
    if (query.isEmpty) {
      filteredInvoices = invoices;
    } else {
      final lowerQuery = query.toLowerCase();

      filteredInvoices = invoices.where((invoiceData) {
        final name = invoiceData.name?.toLowerCase() ?? '';
        final family = invoiceData.familyName?.toLowerCase() ?? '';
        final data = invoiceData.date?.toLowerCase() ?? '';

        return name.contains(lowerQuery) ||
            family.contains(lowerQuery) ||
            data.contains(lowerQuery);
      }).toList();
    }
    update();
  }

  deleteInvoice(String invuuid) async {
    Map<String, Object?> data = {
      "uuid": invuuid,
    };
    var result = await invoicedata.deleteinvoice(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      showSnackbar("✅ ${"success".tr}", "delete_success".tr, Colors.green);
      Get.find<RefreshService>().fire();
      showInvoice();
    } else {
      showSnackbar("❌ ${"error".tr}", "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  void gotoSaleNew() {
    Get.toNamed(Approutes.newSale);
  }

  void gotoShowInvoice(InvoiceItem invoice) {
    Get.toNamed(
      Approutes.shwoinvoice,
      arguments: {"invoice": invoice},
    );
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

  @override
  void onInit() {
    showInvoice();
    super.onInit();
  }
}
