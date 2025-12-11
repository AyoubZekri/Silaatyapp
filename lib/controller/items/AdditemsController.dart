import 'dart:io';
import 'dart:math';
import 'package:Silaaty/controller/items/ItemsController.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class Additemscontroller extends GetxController {
  File? file;
  bool? isManualBarcode;
  int? selectedCategoryId = 1;
  String? selectedCategory;
  String? selectedtypeuuid;
  String? selectedtype;
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final descriptionController = TextEditingController();
  final priseController = TextEditingController();
  final pricePurchaseController = TextEditingController();
  final quantityController = TextEditingController();

  double priceTotal = 0.0;
  double priceTotalPurchase = 0.0;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  // Myservices myServices = Get.find();
  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;

  void toggleBarcodeMode(bool manual) {
    isManualBarcode = manual;
    if (!manual) {
      barcodeController.text = generateBarcode();
    } else {
      barcodeController.clear();
    }
    update();
  }

  String generateBarcode() {
    final random = Random();
    return List.generate(10, (_) => random.nextInt(10)).join();
  }

  addProduct() async {
    if (formstate.currentState!.validate()) {
      if (int.parse(quantityController.text) > 0) {
        showSnackbar(
            "error".tr, "لا يمكن أن تكون الكمية أقل من 1".tr, Colors.red);
      }

      Map<String, Object?> data = {
        "user_id": id,
        'product_name': nameController.text,
        'product_description': descriptionController.text,
        'product_quantity': quantityController.text,
        'product_price': priseController.text,
        'categorie_id': selectedCategoryId.toString(),
        'categoris_uuid': selectedtypeuuid,
        'product_price_total': priceTotal.toString(),
        'product_price_total_purchase': priceTotalPurchase.toString(),
        'product_price_purchase': pricePurchaseController.text,
        'codepar': barcodeController.text,
        "created_at": DateTime.now().toIso8601String(),
      };

      Map<String, Object?> dataSale = {
        "uuid": Uuid().v4(),
        "quantity": quantityController.text,
        "unit_price": pricePurchaseController.text,
        "subtotal": double.parse(quantityController.text) *
            double.parse(pricePurchaseController.text),
        "type_sales": 3, // 1 = in 2 = out 3
        "user_id": id,
        "created_at": DateTime.now().toIso8601String(),
      };

      try {
        print("========================$selectedtypeuuid");

        /// ندخل المنتج في SQLite مع الصورة + uuid + sync_queue
        final result = await prodactData.addProduct(data, dataSale, file);

        if (result == true) {
          showSnackbar(
              "success".tr, "product_added_successfully".tr, Colors.green);

          if (selectedCategoryId == 1) {
            Get.toNamed(Approutes.item);
            Future.delayed(Duration(milliseconds: 300), () {
              Get.find<Itemscontroller>().getCategoris();
              Get.find<Itemscontroller>().getProdactnotcat();
            });
          } else {
            Get.back(result: true);
          }
        } else {
          showSnackbar("error".tr, "error_adding_product".tr, Colors.red);
          statusrequest = Statusrequest.failure;
        }
      } catch (e) {
        showSnackbar("error".tr, "db_error".tr, Colors.red);
        print("DB Error: $e");
        statusrequest = Statusrequest.failure;
      }
    }
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

  @override
  void onInit() {
    getCategoris();
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      selectedCategoryId = args["catid"];
    }
    super.onInit();
    quantityController.addListener(calculateTotalPrice);
    priseController.addListener(calculateTotalPrice);
    pricePurchaseController.addListener(calculateTotalPrice);
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

  void resetForm() {
    nameController.clear();
    priseController.clear();
    pricePurchaseController.clear();
    quantityController.text = "1";
    getCategoris();
    selectedtypeuuid = null;
    file = null;

    priceTotal = 0.0;
    priceTotalPurchase = 0.0;

    update();
  }
}
