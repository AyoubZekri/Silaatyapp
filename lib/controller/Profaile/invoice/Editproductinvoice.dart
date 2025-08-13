import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/invoice_Shwo_Model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/functions/Snacpar.dart';

class EditProductInvoiceController extends GetxController {
  int? id;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final quantityController = TextEditingController();

  double priceTotal = 0.0;
  double priceTotalPurchase = 0.0;

  final formKey = GlobalKey<FormState>();

  final ProdactData prodactData = ProdactData(Get.find());

  Statusrequest statusRequest = Statusrequest.none;

  @override
  void onInit() {
    super.onInit();
    quantityController.addListener(calculateTotalPrice);
    priceController.addListener(calculateTotalPrice);
    purchasePriceController.addListener(calculateTotalPrice);
  }

  void initData(Product product) {
    id = product.id;
    nameController.text = product.productName ?? "";
    priceController.text = product.productPrice ?? "";
    purchasePriceController.text = product.productPricePurchase ?? "";
    quantityController.text = product.productQuantity ?? "";
  }

  Future<void> editProduct() async {
    if (!formKey.currentState!.validate()) return;

    statusRequest = Statusrequest.loadeng;
    update();

    final data = {
      "id": id,
      'product_name': nameController.text.trim(),
      'product_quantity': quantityController.text.trim(),
      'product_price': priceController.text.trim(),
      'product_price_purchase': purchasePriceController.text.trim(),
      'product_price_total': priceTotal.toString(),
      'product_price_total_purchase': priceTotalPurchase.toString(),
    };

    final response = await prodactData.UpdateProdact(data);
              if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
      Get.back(result: true);
      showSnackbar("success".tr, "update_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusRequest = Statusrequest.failure;
    }

    update();
  }




  void calculateTotalPrice() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final purchasePrice = double.tryParse(purchasePriceController.text) ?? 0.0;

    priceTotal = quantity * price;
    priceTotalPurchase = quantity * purchasePrice;

    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  void onQuantityChanged(int value) {
    quantityController.text = value.toString();
    calculateTotalPrice();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    purchasePriceController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
