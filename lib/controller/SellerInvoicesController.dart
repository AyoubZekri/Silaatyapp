import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:get/get.dart';

import '../core/constant/routes.dart';

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

    try {
      final sellerId = seller['id'];
      if (sellerId != null) {
        final result = await invoicedata.getSellerInvoices(sellerId);
        if (result['data'] != null) {
          final data = result['data'];
          
          List<InvoiceItem> invoiceList = [];
          if (data['invoices'] != null) {
            invoiceList = (data['invoices'] as List).map((i) => InvoiceItem.fromJson(i)).toList();
          }

          invoice = InvoiceData(
            transaction: null, // Since these aren't bound to one transaction
            invoices: invoiceList,
            sumPrice: (data['sum_price'] ?? 0.0).toDouble(),
            sumPaymentPrice: (data['sum_payment_Price'] ?? 0.0).toDouble(),
          );
        }
      }
    } catch (e) {
      print("Error fetching seller invoices: $e");
    }

    statusrequest = Statusrequest.success;
    update();
  }

  String getRemainingAmount() {
    final total = invoice?.sumPrice ?? 0.0;
    final paid = invoice?.sumPaymentPrice ?? 0.0;
    double remaining = total - paid;
    
    remaining = double.parse(remaining.toStringAsFixed(3));
    
    return formavalue(remaining <= 0 ? 0 : remaining);
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
    Get.toNamed(
      Approutes.shwoinvoice,
      arguments: {"invoice": invoice},
    );
  }
}
