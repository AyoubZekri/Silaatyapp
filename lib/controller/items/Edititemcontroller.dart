import 'dart:io';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';
import 'package:uuid/uuid.dart';

import '../../core/functions/Snacpar.dart';

class Edititemcontroller extends GetxController {
  File? file;
  String? imageUrl;
  bool? isManualBarcode = false;
  int? selectedCategoryId = 1;
  String? oldquantity;
  String? selectedCategory;
  String? selectedtypeuuId;
  String? selectedtype;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priseController = TextEditingController();
  final barcodeController = TextEditingController();
  final pricePurchaseController = TextEditingController();
  final quantityController = TextEditingController();

  double priceTotal = 0.0;
  double priceTotalPurchase = 0.0;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());

  // Myservices myServices = Get.find();
  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;
  String? uuid;

  Myservices myservices = Get.find();
  late int? id = myservices.sharedPreferences?.getInt("id");

  void toggleBarcodeMode(bool manual) {
    isManualBarcode = manual;
    update();
  }

  getCategoris() async {
    try {
      update();

      var response = await categorisData.viewdata();

      print("============================================== $response");

      if (response.isNotEmpty) {
        categories = (response as List)
            .map((e) => Catdata.fromJson(e as Map<String, dynamic>))
            .toList();
        statusrequest = Statusrequest.success;
      } else {
        statusrequest = Statusrequest.failure;
      }
    } catch (e) {
      print("❌ getcat error: $e");
      statusrequest = Statusrequest.serverfailure;
    }
    update();
  }

  EditProduct() async {
    if (formstate.currentState!.validate()) {
      final quantity =
          int.parse(quantityController.text) - int.parse(oldquantity!);

      if (quantity > 0) {
        showSnackbar(
            "error".tr, "لا يمكن أن تكون الكميةأقل من الموجودة".tr, Colors.red);
      }

      Map<String, Object?> data = {
        "uuid": uuid,
        'product_name': nameController.text,
        'product_description': descriptionController.text,
        'product_quantity': quantityController.text,
        'product_price': priseController.text,
        'categorie_id': selectedCategoryId.toString(),
        'categoris_uuid': selectedtypeuuId.toString(),
        'product_price_total': priceTotal.toString(),
        'product_price_total_purchase': priceTotalPurchase.toString(),
        'product_price_purchase': pricePurchaseController.text,
        "codepar": barcodeController.text,
        'updated_at': DateTime.now().toIso8601String(),
      };

      Map<String, Object?> dataSale = {
        "uuid": Uuid().v4(),
        "product_uuid": uuid,
        "quantity": quantity,
        "unit_price": pricePurchaseController.text,
        "subtotal": quantity * double.parse(pricePurchaseController.text),
        "type_sales": 3, // 1 = in 2 = out 3
        "user_id": id,
        "created_at": DateTime.now().toIso8601String(),
      };

      var result = await prodactData.updateProduct(data, dataSale, file);

      print("==================================================$result");
      if (result == true) {
        Get.back(result: true);
        showSnackbar(
            "success".tr, "product_updated_successfully".tr, Colors.green);
      } else {
        print(result);
        showSnackbar("error".tr, "error_updating_product".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategoris();
    });
    super.onInit();
    quantityController.addListener(calculateTotalPrice);
    priseController.addListener(calculateTotalPrice);
  }

  void calculateTotalPrice() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priseController.text) ?? 0.0;
    final pricePurchase = double.tryParse(pricePurchaseController.text) ?? 0.0;

    priceTotal = quantity * price;
    priceTotalPurchase = quantity * pricePurchase;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void onQuantityChanged(int value) {
    quantityController.text = value.toString();
    calculateTotalPrice();
  }

  void imageupload() {
    showbottom(uploadimagecamera, uploadimagefile);
  }

  Future<void> uploadimagecamera() async {
    file = await imageuploadcamera();
    update();
  }

  Future<void> uploadimagefile() async {
    file = await fileuploadGallery(false);
    update();
  }

  void initData(Prodact.Data product) {
    nameController.text = product.productName ?? "";
    descriptionController.text = product.productDescription ?? "";
    priseController.text = product.productPrice.toString();
    pricePurchaseController.text = product.productPricePurchase.toString();
    barcodeController.text = product.codepar.toString();
    selectedCategoryId = product.categorieId;
    quantityController.text = product.productQuantity ?? "";
    selectedtypeuuId = product.categorisuuId;
    uuid = product.uuid;
    imageUrl = product.productImage ?? "";
    oldquantity = product.productQuantity ?? "";

    print("============================$selectedtypeuuId");
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priseController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
