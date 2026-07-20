import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:Silaaty/controller/Profaile/invoice/Shwoinvoicecontroller.dart';
import 'package:Silaaty/data/datasource/Remote/SaleData.dart';
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

  double finalAmount = 0.0;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Saledata saledata = Saledata();
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");
  Statusrequest statusrequest = Statusrequest.none;

  Future<void> addSale({bool printInvoice = false}) async {
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
      "seller_id": id,
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
        "seller_id": id,
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
      Get.back(result: true);
      Get.find<RefreshService>().fire();

      if (printInvoice) {
        InvoiceItem invoice = InvoiceItem(
          uuid: uuidinvoice,
          name: name,
          familyName: familyName,
          paymentPrice: double.tryParse(paymentController.text) ?? 0,
          discount: double.tryParse(discountController.text) ?? 0,
          invoiceSum: totalprice,
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

    recalculateFinalAmount();

    discountController.addListener(recalculateFinalAmount);
    paymentController.addListener(recalculateFinalAmount);

    if (selectedCustomer == "virtualCustomer".tr) {
      paymentController = TextEditingController(text: formavalue(finalAmount));
    } else {
      paymentController = TextEditingController(text: "0");
    }
  }

  void recalculateFinalAmount() {
    double total = totalprice;
    double discount = double.tryParse(discountController.text) ?? 0.0;

    finalAmount = total - discount;
    if (selectedCustomer == "virtualCustomer".tr) {
      paymentController.text = formavalue(finalAmount);
    }

    update();
  }

  @override
  void onClose() {
    paymentController.dispose();
    discountController.dispose();
    super.onClose();
  }
}
