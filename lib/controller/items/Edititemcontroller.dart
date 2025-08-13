import 'dart:io';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';

import '../../core/functions/Snacpar.dart';

class Edititemcontroller extends GetxController {
  File? file;
  String? imageUrl;
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
  int? id;

  Myservices myservices = Get.find();

  getCategoris() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await categorisData.viewdata();
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Categoris_Model.fromJson(response);
      categories = model.data?.catdata ?? [];
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  EditProduct() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": id,
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
      var response = await prodactData.UpdateProdact(data, file);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        Get.back(result: true);
        showSnackbar(
            "success".tr, "product_updated_successfully".tr, Colors.green);
      } else {
        print(response);
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
    priseController.text = product.productPrice ?? "";
    pricePurchaseController.text = product.productPricePurchase ?? "";
    selectedCategoryId = product.categorieId;
    quantityController.text = product.productQuantity ?? "";
    selectedtypeId = product.categorisId;
    id = product.id;
    imageUrl = product.productImage??"";
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
