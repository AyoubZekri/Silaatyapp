import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/SaleData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class PaymentController extends GetxController {
  late Map<String, dynamic> args;

  List products = [];
  String trn_uuid = '';
  String name = '';
  String familyName = '';
  String totalprice = '';
  String currentDate = '';
  String selectedCustomer = '';
  int type = 0;

  late TextEditingController paymentController;
  late TextEditingController discountController;

  double finalAmount = 0.0;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Saledata saledata = Saledata();
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");
  Statusrequest statusrequest = Statusrequest.none;

  Future<void> addSale() async {
    final String uuidinvoice = Uuid().v4();

    update();
    Map<String, Object?> data = {
      "uuid": uuidinvoice,
      'Transaction_uuid': trn_uuid,
      "user_id": id,
      "invoies_numper":
          DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10),
      "invoies_date": DateTime.now().toIso8601String(),
      "discount": discountController.text,
      "invoies_payment_date": DateTime.now().toIso8601String(),
      "created_at": DateTime.now().toIso8601String(),
      "Payment_price": paymentController.text
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
        "created_at": DateTime.now().toIso8601String(),
      };
    }).toList();
    print(data);
    print(dataSale);

    var result = await saledata.addSale(data, dataSale);

    print("==================================================$result");

    if (result["status"] == 1) {
      Get.back(result: true);
      Get.find<RefreshService>().fire();
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
    totalprice = args['totalprice']?.toString() ?? '0';
    selectedCustomer = args['selectedCustomer']?.toString() ?? '0';

    if (args['type'] != null) type = args['type'];

    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    discountController = TextEditingController(text: "0");
    paymentController = TextEditingController(text: "0");

    recalculateFinalAmount();

    discountController.addListener(recalculateFinalAmount);
    paymentController.addListener(recalculateFinalAmount);



    if (selectedCustomer == "virtualCustomer".tr) {
      paymentController =
          TextEditingController(text: finalAmount.toStringAsFixed(2));
    } else {
      paymentController = TextEditingController(text: "0");
    }
  }

  void recalculateFinalAmount() {
    double total = double.tryParse(totalprice) ?? 0.0;
    double discount = double.tryParse(discountController.text) ?? 0.0;

    finalAmount = total - discount;
    if (selectedCustomer == "virtualCustomer".tr) {
      paymentController.text = finalAmount.toStringAsFixed(2);
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
