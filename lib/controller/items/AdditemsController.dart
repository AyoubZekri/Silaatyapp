import 'dart:io';
import 'package:Silaaty/controller/HomeScreen/HomeController.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:flutter/material.dart';

import '../../core/functions/Snacpar.dart';

class Additemscontroller extends GetxController {
  File? file;
  int? selectedCategoryId = 1;
  String? selectedCategory;
  int? selectedtypeId;
  String? selectedtype;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priseController = TextEditingController();
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

  addProduct() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        'product_name': nameController.text,
        'product_description': descriptionController.text,
        'product_quantity': quantityController.text,
        'product_price': priseController.text,
        'categorie_id': selectedCategoryId.toString(),
        'categoris_id': selectedtypeId.toString(),
        'product_price_total': priceTotal.toString(),
        'product_price_total_purchase': priceTotalPurchase.toString(),
        'product_price_purchase': pricePurchaseController.text,
      };
      var response = await prodactData.addProdact(data, file);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("=======================$selectedCategoryId");
      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        showSnackbar(
            "success".tr, "product_added_successfully".tr, Colors.green);

        if (selectedCategoryId == 1) {
          Get.offAllNamed(Approutes.HomeScreen);
          Future.delayed(Duration(milliseconds: 300), () {
            Get.find<Homecontroller>().getCategoris();
            Get.find<Homecontroller>().getProdactnotcat();
          });
        } else {
          Get.back(result: true);
        }
      } else {
        showSnackbar("error".tr, "error_adding_product".tr, Colors.green);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  getCategoris() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await categorisData.viewdata();
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Categoris_Model.fromJson(response);
      categories = model.data?.catdata ?? [];
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
    selectedtypeId = null;
    file = null;

    priceTotal = 0.0;
    priceTotalPurchase = 0.0;

    update();
  }
}
