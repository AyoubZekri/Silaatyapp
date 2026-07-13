import 'dart:io';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';

import '../../core/constant/Colorapp.dart';
import '../../core/functions/Snacpar.dart';

class Edititemcontroller extends GetxController {
  File? file;
  String? imageUrl;
  int? barcodeMode; // 0: Auto, 1: Manual, 2: Scan
  int? selectedCategoryId = 1;
  String? oldquantity;
  String? selectedCategory;
  String? selectedtypeuuId;
  String? selectedtype;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priseController = TextEditingController();
  final priseHalfWholesaleController = TextEditingController();
  final priseWholesaleController = TextEditingController();
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
  int? type;

  Myservices myservices = Get.find();
  late int? id = myservices.sharedPreferences?.getInt("id");
  late int sellType = myservices.sharedPreferences?.getInt("sell_type") ?? 3;

  void toggleBarcodeMode(int mode, BuildContext context) {
    barcodeMode = mode;
    if (mode == 2) {
      scanBarcode(context);
    }
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
    if (!formstate.currentState!.validate()) return;

    final newQty = double.tryParse(quantityController.text) ?? 0;
    final oldQty = double.tryParse(oldquantity!) ?? 0.0;

    if (newQty < 0) {
      showSnackbar("error".tr, "كمية غير صالحة".tr, Colors.red);
      return;
    }

    final data = {
      "uuid": uuid,
      'product_name': nameController.text,
      'product_description': descriptionController.text,
      'product_quantity': newQty,
      'product_price': priseController.text,
      'product_price_half_wholesale': sellType >= 2 ? (priseHalfWholesaleController.text.isNotEmpty ? priseHalfWholesaleController.text : "0") : "0",
      'product_price_wholesale': sellType >= 3 ? (priseWholesaleController.text.isNotEmpty ? priseWholesaleController.text : "0") : "0",
      'categorie_id': selectedCategoryId.toString(),
      'categoris_uuid': selectedtypeuuId.toString(),
      'product_price_total': priceTotal.toString(),
      'product_price_total_purchase': priceTotalPurchase.toString(),
      'product_price_purchase': pricePurchaseController.text,
      "codepar": barcodeController.text,
      'updated_at': DateTime.now().toString().substring(0, 19),
    };

    final result = await prodactData.updateProduct(
      data,
      oldQty,
      newQty,
      file,
    );
    if (result) {
      Get.find<RefreshService>().fire();
      Get.back(result: true);
    } else {
      showSnackbar("error".tr, "error_updating_product".tr, Colors.red);
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
    final quantity = type == 2
        ? double.tryParse(quantityController.text) ?? 0.0
        : int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priseController.text) ?? 0.0;
    final pricePurchase = double.tryParse(pricePurchaseController.text) ?? 0.0;

    priceTotal = quantity * price;
    priceTotalPurchase = quantity * pricePurchase;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void onQuantityChanged(num value) {
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
    priseHalfWholesaleController.text = product.productPriceHalfWholesale?.toString() ?? "0";
    priseWholesaleController.text = product.productPriceWholesale?.toString() ?? "0";
    pricePurchaseController.text = product.productPricePurchase.toString();
    barcodeController.text = product.codepar.toString();
    selectedCategoryId = product.categorieId;
    quantityController.text = product.productQuantity ?? "";
    selectedtypeuuId = product.categorisuuId;
    uuid = product.uuid;
    imageUrl = product.productImage ?? "";
    oldquantity = product.productQuantity ?? "";
    type = product.type ?? 1;

    print("============================$selectedtypeuuId");
  }

  bool _isScanning = false;
  void scanBarcode(BuildContext context) {
    if (_isScanning) return;
    _isScanning = true;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              AppBar(
                title: Text(
                  "امسح الباركود".tr,
                  style: const TextStyle(color: AppColor.backgroundcolor),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: AppColor.primarycolor,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColor.backgroundcolor),
                    onPressed: () {
                      _isScanning = false;
                      Get.back();
                    },
                  ),
                ],
              ),
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && _isScanning) {
                      final scannedCode = barcodes.first.rawValue;
                      if (scannedCode != null) {
                        _isScanning = false;
                        barcodeController.text = scannedCode;
                        update();
                        if (Get.isDialogOpen!) {
                          Get.back();
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      _isScanning = false;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priseController.dispose();
    priseHalfWholesaleController.dispose();
    priseWholesaleController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
