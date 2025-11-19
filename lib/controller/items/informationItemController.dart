import 'package:Silaaty/controller/items/Edititemcontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:uuid/uuid.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class Informationitemcontroller extends GetxController {
  late String uuid;
  final quantityController = TextEditingController();
  Myservices myservices = Get.find();
  late int? id = myservices.sharedPreferences?.getInt("id");

  ProdactData prodactData = ProdactData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Data> InfoProduct = [];
  Future<void> GotoEdititem() async {
    final product = InfoProduct[0];
    final controller = Get.put(Edititemcontroller());
    controller.initData(product);
    await Get.toNamed(
      Approutes.edititemcontroller,
    );
  }

  getProdact() async {
    Map<String, Object?> data = {'uuid': uuid};
    var result = await prodactData.ShwoProdact(data);

    print("============================================== $result");
    print("User ID: $uuid");

    if (result.isNotEmpty) {
      InfoProduct =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  deleteProdact(String uid) async {
    update();
    Map<String, Object?> data = {'uuid': uid};
    var result = await prodactData.deleteProdact(data);

    print("============================================== $result");
    print("$uid");
    if (result == true) {
      Get.back(result: true);
      showSnackbar(
          "success".tr, "product_deleted_successfully".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "error_deleting_product".tr, Colors.red);

      statusrequest = Statusrequest.failure;
    }
    update();
  }

  Future<void> editquantityProduct() async {
    if (int.parse(quantityController.text) < 1) {
      showSnackbar(
          "error".tr, "لا يمكن أن تكون الكمية أقل من 1".tr, Colors.red);
      return;
    }
    final int quantity = int.parse(InfoProduct.first.productQuantity ?? "0") +
        int.parse(quantityController.text);
    final data = {
      "uuid": uuid,
      'product_quantity': quantity,
      'updated_at': DateTime.now().toIso8601String(),
    };

    Map<String, Object?> dataSale = {
      "uuid": Uuid().v4(),
      "product_uuid": uuid,
      "quantity": int.parse(quantityController.text),
      "unit_price": InfoProduct.first.productPricePurchase ?? "0",
      "subtotal": int.parse(quantityController.text) *
          double.parse(InfoProduct.first.productPricePurchase.toString()),
      "type_sales": 3, // 1 = in 2 = out 3
      "user_id": id,
      "created_at": DateTime.now().toIso8601String(),
    };

    final result = await prodactData.updateQuantityProduct(data, dataSale);
    print("========================================$result");
    if (result) {
      Get.back();
      quantityController.clear();
      showSnackbar("success".tr, "updateSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Future<void> printProductTicket({
    required String name,
    required String barcode,
    required double price,
  }) async {
    try {
      // ✅ تحقق من الاتصال بشكل صحيح
      bool? status = await PrintBluetoothThermal.connectionStatus;
      if (status != true) {
        print("❌ لم يتم الاتصال بالطابعة");
        showSnackbar("error".tr, "لم يتم الاتصال بالطابعة".tr, Colors.red);
        return;
      }

      // تحضير النص للطباعة
      List<String> lines = [
        "-----------------------------",
        "           $name             ",
        "                             ",
        "          $barcode           ",
        "                             ",
        " ${price.toStringAsFixed(2)} دج",
        "-----------------------------",
        "\n\n",
      ];

      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 2,
          text: lines.join("\n"),
        ),
      );

      print("✅ تم إرسال الطباعة بنجاح");
    } catch (e) {
      showSnackbar("error".tr, "حدث خطأ".tr, Colors.red);
    }
  }

  void onQuantityChanged(int value) {
    quantityController.text = value.toString();
  }

  @override
  void onInit() {
    super.onInit();
    uuid = Get.arguments['uuid'];

    getProdact();
  }
}
