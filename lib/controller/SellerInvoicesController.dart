import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../core/functions/Snacpar.dart';
import '../core/services/Services.dart';

class SellerInvoicesController extends GetxController {
  int selectedIndex = 3;
  late Map seller;

  Statusrequest statusrequest = Statusrequest.none;
  Invoicedata invoicedata = Invoicedata(Get.find());
  InvoiceData? invoice;

  @override
  void onInit() {
    seller = Get.arguments ?? {};
    showInvoice();
    super.onInit();
  }

  showInvoice() async {
    statusrequest = Statusrequest.loadeng;
    update();

    // Here you would fetch invoices created by the seller (user_id = seller['id']).
    // For now, we simulate an empty response because the query for seller invoices isn't fully set up.
    
    // Create an empty InvoiceData model to prevent null errors in the UI
    invoice = InvoiceData(
      transaction: null,
      invoices: [],
      sumPrice: 0.0,
      sumPaymentPrice: 0.0,
    );

    statusrequest = Statusrequest.success;
    update();
  }

  String getRemainingAmount() {
    final total = invoice?.sumPrice ?? 0.0;
    final paid = invoice?.sumPaymentPrice ?? 0.0;
    final remaining = total - paid;
    return remaining.toStringAsFixed(2);
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  String getMonthAbbreviation(String? date) {
    if (date == null || date.length < 7) return '';
    final month = date.substring(5, 7);
    const months = {
      '01': 'Jan', '02': 'Feb', '03': 'Mar', '04': 'Apr',
      '05': 'May', '06': 'Jun', '07': 'Jul', '08': 'Aug',
      '09': 'Sep', '10': 'Oct', '11': 'Nov', '12': 'Dec',
    };
    return months[month] ?? '';
  }

  refreshData() async {
    await showInvoice();
    update();
  }

  gotoNewSale() {
    // Navigate to create a new sale.
  }

  deleteInvoice(String uuid) {
    // Implement delete logic here
  }
  
  gotoShowInvoice(InvoiceItem invoice) {
    // Navigate to invoice details
  }
}
