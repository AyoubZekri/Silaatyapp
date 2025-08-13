import 'dart:convert';
import 'dart:io';

import 'package:Silaaty/controller/Profaile/invoice/Editproductinvoice.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/extractProductsFromImage.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/model/invoice_Shwo_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';

import '../../../core/functions/Snacpar.dart';

class Shwoinvoicecontroller extends GetxController {
  int? id;
  List<Map<String, dynamic>> products = [];

  Invoicedata invoicedata = Invoicedata(Get.find());
  Data? invoice;
  Statusrequest statusrequest = Statusrequest.none;
  late TextEditingController paymentPrice;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  ProdactData prodactData = ProdactData(Get.find());

  addProducts() async {
    statusrequest = Statusrequest.loadeng;
    update();
    List<Map<String, dynamic>> cleanedProducts = products.where((product) {
      final name = product['name']?.toString().trim();
      final quantityStr = product['quantity']?.toString().trim();
      final priceStr =
          product['price']?.toString().replaceAll(RegExp(r'[^\d.]'), '').trim();

      return name != null &&
          name.isNotEmpty &&
          quantityStr != null &&
          quantityStr.isNotEmpty &&
          double.tryParse(quantityStr) != null &&
          priceStr!.isNotEmpty &&
          double.tryParse(priceStr) != null;
    }).toList();

    print("${'cleanedProducts'.tr}\n$cleanedProducts");

    if (cleanedProducts.isEmpty) {
      showSnackbar("warning".tr, "no_valid_products".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
      update();
      return;
    }

    List<Map<String, dynamic>> formattedProducts =
        cleanedProducts.map((product) {
      final quantity = int.tryParse(product['quantity'].toString()) ?? 0;
      final price = double.tryParse(product['price'].toString()) ?? 0;

      return {
        'product_name': product['name'],
        'product_quantity': quantity,
        'categorie_id': 3,
        'product_price_total_purchase': price * quantity,
        'product_price_purchase': price,
        "invoies_id": invoice!.invoice!.id,
      };
    }).toList();
    print(jsonEncode({'products': formattedProducts}));

    var response =
        await prodactData.addProdact({'products': formattedProducts});
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("============== invoice_id: ${invoice!.invoice!.id}");
    print("============== response: $response");

    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Shwoinvoice();
      showSnackbar("success".tr, "products_added_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "error_adding_products".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
    }
  }

  deleteProdact(int iditem) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {'id': iditem};
    var response = await prodactData.deleteProdact(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("============================================== $response");
    print("$id");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Shwoinvoice();
      showSnackbar(
          "success".tr, "product_deleted_successfully".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "error_deleting_product".tr, Colors.red);

      statusrequest = Statusrequest.failure;
    }
    update();
  }

  Shwoinvoice() async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {"id": id};
    var response = await invoicedata.Shwoinfoinvoice(data);
    print("==================================================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final modele = invoice_Shwo_Model.fromJson(response);
        invoice = modele.data;
        if (invoice == null) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  Editinvoise(int invid) async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": invid,
        'Payment_price': paymentPrice.text,
      };
      print("=======$invid");
      var response = await invoicedata.Editinvoise(data);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        paymentPrice.clear();
        Get.back();
        Shwoinvoice();
        showSnackbar("success".tr, "operation_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "error_editing_product".tr, Colors.red);

        statusrequest = Statusrequest.failure;
      }
    }
  }

  Future<void> GotoEdititem(int proid) async {
    final product = invoice?.product?.firstWhereOrNull(
      (element) => element.id == proid,
    );

    if (product == null) {
      Get.snackbar(
        "error".tr,
        "product_not_found".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    final controller = Get.put(EditProductInvoiceController());
    controller.initData(product);

    final result = await Get.toNamed(Approutes.Editproductinvoice);
    if (result == true) {
      Shwoinvoice();
    }
  }

  Future<void> GotoEdititemdealer(int proid) async {
    final product = invoice?.product?.firstWhereOrNull(
      (element) => element.id == proid,
    );

    if (product == null) {
      Get.snackbar(
        "error".tr,
        "product_not_found".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    final controller = Get.put(EditProductInvoiceController());
    controller.initData(product);

    final result = await Get.toNamed(Approutes.Editproductinvoicedealer);
    if (result == true) {
      Shwoinvoice();
    }
  }

  Future<void> gotoAddProductdealer(int catid, int idinv) async {
    final result = await Get.toNamed(Approutes.addproductinvoicedealer,
        arguments: {"catid": catid, "id": idinv});
    if (result == true) {
      Shwoinvoice();
    }
  }

  Future<void> gotoAddProduct(int catid, int idinv) async {
    final result = await Get.toNamed(Approutes.Addproductinvoice,
        arguments: {"catid": catid, "id": idinv});
    if (result == true) {
      Shwoinvoice();
    }
  }

  void Addproduct(int catid, int idinv) {
    showBottomAddProductOrScanner(
      catid,
      idinv,
      gotoAddProductdealer,
      scanAndExtractProducts,
      scanAndExtractProductsfile,
    );
  }

  Future<void> scanAndExtractProducts() async {
    try {
      statusrequest = Statusrequest.loadeng;
      update();

      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.camera);

      if (picked == null) {
        statusrequest = Statusrequest.none;
        update();
        return;
      }

      final image = File(picked.path);
      final rawResult = await extractProductsFromImage(image);

      print("${'extracted_products'.tr}\n$rawResult");

      final cleanedResult = rawResult
          .replaceAll(RegExp(r'```json'), '')
          .replaceAll(RegExp(r'```'), '')
          .trim();

      final decoded = jsonDecode(cleanedResult);
      if (decoded is List) {
        products = List<Map<String, dynamic>>.from(decoded);
        update();
        await addProducts();
      }

      statusrequest = Statusrequest.success;
      update();
    } catch (e) {
      print("${'error_extracting_products'.tr}: $e");
      statusrequest = Statusrequest.failure;
      update();
    }
  }

  Future<void> scanAndExtractProductsfile() async {
    try {
      statusrequest = Statusrequest.loadeng;
      update();

      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) {
        statusrequest = Statusrequest.none;
        update();
        return;
      }

      final image = File(picked.path);
      final rawResult = await extractProductsFromImage(image);

      print("${'extracted_products'.tr}\n$rawResult");

      final cleanedResult = rawResult
          .replaceAll(RegExp(r'```json'), '')
          .replaceAll(RegExp(r'```'), '')
          .trim();

      final decoded = jsonDecode(cleanedResult);
      if (decoded is List) {
        products = List<Map<String, dynamic>>.from(decoded);
        update();
        await addProducts();
      }

      statusrequest = Statusrequest.success;
      update();
    } catch (e) {
      print("${'error_extracting_products'.tr}: $e");
      statusrequest = Statusrequest.failure;
      update();
    }
  }

  double getRemainingAmount() {
    final total = double.tryParse(invoice?.sumPrice?.toString() ?? "0") ?? 0;
    final paid =
        double.tryParse(invoice?.invoice?.paymentPrice?.toString() ?? "0") ?? 0;
    if (total - paid < 0) {
      return 0;
    }
    return total - paid;
  }

  @override
  void onInit() {
    paymentPrice = TextEditingController();

    id = Get.arguments["id"];
    Shwoinvoice();
    super.onInit();
  }

  void dispose() {
    paymentPrice.dispose();
    super.dispose();
  }

  refreshData() async {
    await Shwoinvoice();
  }
}
