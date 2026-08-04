import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:Silaaty/controller/Profaile/invoice/Shwoinvoicecontroller.dart';
import 'package:Silaaty/data/datasource/Remote/SaleData.dart';
import 'package:Silaaty/data/datasource/Remote/transactiondata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class PaymentController extends GetxController {
  late Map<String, dynamic> args;

  List products = [];
  String trn_uuid = '';
  String name = '';
  String familyName = '';
  double totalprice = 0.0;
  String currentDate = '';
  String selectedCustomer = '';
  int type = 0;
  int saleType = 1;

  late TextEditingController paymentController;
  late TextEditingController discountController;
  late TextEditingController oldDebtPaymentController;

  double oldDebtTotal = 0.0;
  List<Map<String, dynamic>> unpaidInvoices = [];
  double finalAmount = 0.0;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Saledata saledata = Saledata();
  Transactiondata transactiondata = Transactiondata(Get.find());
  ProdactData prodactData = ProdactData(Get.find());
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");
  int? sellerid = Get.find<Myservices>().sharedPreferences?.getInt("sellerid");
  String? loginType =
      Get.find<Myservices>().sharedPreferences?.getString("loginType");
  Statusrequest statusrequest = Statusrequest.none;

  Future<void> addSale({bool printInvoice = false}) async {
    for (var item in products) {
      if (item is Map<String, dynamic> && item.containsKey('draft_data')) {
        var draftPayload = item['draft_data'];
        var draftData = draftPayload['draft_data'];
        var draftDataSale = draftPayload['draft_data_sale'];
        var file = draftPayload['file'];

        final insertResult =
            await prodactData.addProduct(draftData, draftDataSale, file);
        if (insertResult != true) {
          showSnackbar("error".tr, "فشل في حفظ المنتج الجديد: ${item['name']}",
              Colors.red);
          statusrequest = Statusrequest.failure;
          update();
          return;
        }

        // IMPORTANT: prodactData.addProduct generates a new UUID and mutates draftData.
        // We must update the item's uuid so the final sale points to the inserted product in the database.
        item['uuid'] = draftData['uuid'];
      }
    }

    print("===============${paymentController.text}============");
    final String uuidinvoice = Uuid().v4();
    print(
        "========================================${DateTime.now().toIso8601String()}");
    update();
    Map<String, Object?> data = {
      "uuid": uuidinvoice,
      'Transaction_uuid': trn_uuid,
      "user_id": id,
      "invoies_numper":
          DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10),
      "invoies_date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "discount": discountController.text,
      "invoies_payment_date": DateTime.now().toIso8601String(),
      "created_at": DateTime.now().toIso8601String(),
      "Payment_price": paymentController.text,
      "sale_type": saleType,
      "seller_id": loginType == "saller" ? sellerid : id,
    };

    List<Map<String, Object?>> dataSale = products.map((item) {
      final unitPrice = type == 1 ? item["price_Purchase"] : item["price"];
      return {
        "uuid": Uuid().v4(),
        "product_uuid": item["uuid"],
        "quantity": item["quantity"],
        "unit_price": unitPrice,
        "subtotal": (item["quantity"] *
            (type == 1 ? item["price_Purchase"] : item["price"])),
        "invoie_uuid": uuidinvoice,
        "type_sales": (type == 1 ? 1 : 2), // 1 = in 2 = on 3
        "user_id": id,
        "seller_id": loginType == "saller" ? sellerid : id,
        "created_at": DateTime.now().toIso8601String(),
        "product_price_purchase": item["price_Purchase"],
        "product_name": item["name"],
      };
    }).toList();
    print(data);
    print(dataSale);

    var result = await saledata.addSale(data, dataSale);

    print("==================================================$result");

    if (result["status"] == 1) {
      double additionalPayment = double.tryParse(oldDebtPaymentController.text) ?? 0.0;
      if (additionalPayment > 0) {
        for (var inv in unpaidInvoices) {
          if (additionalPayment <= 0) break;

          double remaining = (inv['remaining_debt'] as num?)?.toDouble() ?? 0;
          if (remaining > 0) {
            double amountToPay = (additionalPayment > remaining) ? remaining : additionalPayment;
            await transactiondata.payOldDebt(inv['uuid'], amountToPay);
            additionalPayment -= amountToPay;
          }
        }
      }

      Get.back(result: true);
      Get.find<RefreshService>().fire();

      if (printInvoice) {
        InvoiceItem invoice = InvoiceItem(
          uuid: uuidinvoice,
          name: name,
          familyName: familyName,
          paymentPrice: (double.tryParse(paymentController.text) ?? 0) + (double.tryParse(oldDebtPaymentController.text) ?? 0),
          discount: double.tryParse(discountController.text) ?? 0,
          invoiceSum: totalprice,
          debt: oldDebtTotal,
          number: data["invoies_numper"].toString(),
          date: data["invoies_date"].toString(),
        );

        // Put the controller in memory to handle printing without navigating
        Get.delete<Shwoinvoicecontroller>();
        final printCtrl = Get.put(Shwoinvoicecontroller());
        printCtrl.uuid = uuidinvoice;
        printCtrl.invoices = invoice;

        printCtrl.Shwoinvoice().then((_) {
          printCtrl.printThermalInvoice(); // Trigger the background print
        }).catchError((e) {
          print("Background print error: $e");
        });
      }

      // showSnackbar("success".tr, "add_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments ?? {};

    products = args['products'] ?? [];
    trn_uuid = args['uuid'] ?? '';
    name = args['name'] ?? '';
    familyName = args['famlyname'] ?? '';
    totalprice = double.tryParse(args['totalprice']?.toString() ?? '0') ?? 0.0;
    selectedCustomer = args['selectedCustomer']?.toString() ?? '0';

    if (args['type'] != null) type = args['type'];
    if (args['sale_type'] != null) saleType = args['sale_type'];

    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    discountController = TextEditingController(text: "0");
    paymentController = TextEditingController(text: "0");
    oldDebtPaymentController = TextEditingController(text: "0");

    recalculateFinalAmount();

    discountController.addListener(recalculateFinalAmount);
    paymentController.addListener(handlePaymentChange);
    oldDebtPaymentController.addListener(handleOldDebtPaymentChange);

    if (selectedCustomer == "virtualCustomer".tr) {
      paymentController = TextEditingController(text: formavalue(finalAmount));
    } else {
      paymentController = TextEditingController(text: formavalue(finalAmount));
      fetchOldDebts();
    }
  }

  void fetchOldDebts() async {
    if (trn_uuid.isNotEmpty) {
      unpaidInvoices = await transactiondata.getCustomerUnpaidInvoices(trn_uuid);
      oldDebtTotal = 0.0;
      for (var inv in unpaidInvoices) {
        oldDebtTotal += (inv['remaining_debt'] as num?)?.toDouble() ?? 0;
      }
      
      String oldDebtText = formavalue(oldDebtTotal);
      if (oldDebtText != "0") {
          oldDebtPaymentController.text = oldDebtText;
      }
      
      recalculateFinalAmount();
    }
  }

  bool _isDistributing = false;

  void handlePaymentChange() {
    if (_isDistributing) return;
    
    double payment = double.tryParse(paymentController.text) ?? 0.0;
    double currentInvoiceTotal = totalprice - (double.tryParse(discountController.text) ?? 0.0);
    
    if (payment > currentInvoiceTotal && currentInvoiceTotal > 0) {
      _isDistributing = true;
      double excess = payment - currentInvoiceTotal;
      
      String newText = currentInvoiceTotal.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (newText.endsWith('.')) newText = newText.substring(0, newText.length - 1);
      
      paymentController.text = newText;
      paymentController.selection = TextSelection.collapsed(offset: newText.length);
      
      String oldDebtText = excess.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (oldDebtText.endsWith('.')) oldDebtText = oldDebtText.substring(0, oldDebtText.length - 1);
      oldDebtPaymentController.text = oldDebtText;
      
      _isDistributing = false;
    }
    recalculateFinalAmount();
  }

  void handleOldDebtPaymentChange() {
    if (_isDistributing) return;
    
    double oldDebtPayment = double.tryParse(oldDebtPaymentController.text) ?? 0.0;
    
    if (oldDebtPayment > oldDebtTotal && oldDebtTotal > 0) {
      _isDistributing = true;
      double excess = oldDebtPayment - oldDebtTotal;
      
      String newText = oldDebtTotal.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (newText.endsWith('.')) newText = newText.substring(0, newText.length - 1);
      
      oldDebtPaymentController.text = newText;
      oldDebtPaymentController.selection = TextSelection.collapsed(offset: newText.length);
      
      double currentPayment = double.tryParse(paymentController.text) ?? 0.0;
      double totalPayment = currentPayment + excess;
      
      String payText = totalPayment.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (payText.endsWith('.')) payText = payText.substring(0, payText.length - 1);
      
      paymentController.text = payText;
      
      _isDistributing = false;
    }
    recalculateFinalAmount();
  }

  void recalculateFinalAmount() {
    double total = totalprice;
    double discount = double.tryParse(discountController.text) ?? 0.0;

    finalAmount = total + oldDebtTotal - discount;
    if (selectedCustomer == "virtualCustomer".tr) {
      paymentController.text = formavalue(finalAmount);
    }

    update();
  }

  @override
  void onClose() {
    paymentController.dispose();
    discountController.dispose();
    oldDebtPaymentController.dispose();
    super.onClose();
  }
}
