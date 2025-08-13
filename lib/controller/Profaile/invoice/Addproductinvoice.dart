import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/functions/Snacpar.dart';

class AddProductInvoiceController extends GetxController {
  int? selectedCategoryId = 1;
  int? invoiceId;
  String? selectedCategory;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final pricePurchaseController = TextEditingController();
  final quantityController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  double totalSalePrice = 0.0;
  double totalPurchasePrice = 0.0;

  final ProdactData prodactData = ProdactData(Get.find());
  Statusrequest statusRequest = Statusrequest.none;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map) {
      selectedCategoryId = args["catid"];
      invoiceId = args["id"];
    }

    quantityController.addListener(_calculateTotals);
    priceController.addListener(_calculateTotals);
    pricePurchaseController.addListener(_calculateTotals);

    super.onInit();
  }

  Future<void> addProduct() async {
    if (!formKey.currentState!.validate()) return;

    statusRequest = Statusrequest.loadeng;
    update();

    final quantity = int.tryParse(quantityController.text) ?? 0;
    final salePrice = double.tryParse(priceController.text) ?? 0.0;
    final purchasePrice = double.tryParse(pricePurchaseController.text) ?? 0.0;

    final data = {
      'product_name': nameController.text.trim(),
      'product_quantity': quantity.toString(),
      'product_price': salePrice.toStringAsFixed(2),
      'product_price_purchase': purchasePrice.toStringAsFixed(2),
      'product_price_total': totalSalePrice.toStringAsFixed(2),
      'product_price_total_purchase': totalPurchasePrice.toStringAsFixed(2),
      'categorie_id': selectedCategoryId.toString(),
      'invoies_id': invoiceId.toString(),
    };

    final response = await prodactData.addProdact(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
      Get.back(result: true);
      showSnackbar("success".tr, "add_success".tr, Colors.green);
    } else {
      statusRequest = Statusrequest.failure;
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }

    update();
  }

  void _calculateTotals() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final purchasePrice = double.tryParse(pricePurchaseController.text) ?? 0.0;

    totalSalePrice = quantity * price;
    totalPurchasePrice = quantity * purchasePrice;

    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  void onQuantityChanged(int value) {
    quantityController.text = value.toString();
    _calculateTotals();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    pricePurchaseController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
