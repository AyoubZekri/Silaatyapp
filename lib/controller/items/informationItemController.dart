import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Silaaty/controller/items/Edititemcontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:uuid/uuid.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';
import 'package:image/image.dart' as img;

import '../../view/screen/Prodact/informationItem.dart';

class Informationitemcontroller extends GetxController {
  late String uuid;
  final quantityController = TextEditingController();
  Myservices myservices = Get.find();
  final GlobalKey ticketKey = GlobalKey();
  OverlayEntry? ticketOverlay;

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

  // Future<void> printProductTicket({
  //   required String name,
  //   required String barcode,
  //   required double price,
  // }) async {
  //   try {
  //     bool? status = await PrintBluetoothThermal.connectionStatus;
  //     if (status != true) {
  //       showSnackbar("error".tr, "لم يتم الاتصال بالطابعة".tr, Colors.red);
  //       return;
  //     }

  //     await PrintBluetoothThermal.writeBytes([27, 97, 1]);

  //     await PrintBluetoothThermal.writeString(
  //       printText: PrintTextSize(
  //         size: 2,
  //         text: "$name\n",
  //       ),
  //     );

  //     List<int> barcodeSetup = [
  //       29, 72, 2,
  //       29, 119, 3,
  //       29, 107, 73,
  //       barcode.length,
  //     ];

  //     List<int> barcodeBytes = barcode.codeUnits;
  //     await PrintBluetoothThermal.writeBytes(
  //         [...barcodeSetup, ...barcodeBytes]);

  //     await PrintBluetoothThermal.writeString(
  //         printText: PrintTextSize(text: "\n", size: 1));

  //     await PrintBluetoothThermal.writeString(
  //       printText: PrintTextSize(
  //         size: 2,
  //         text: "${price.toStringAsFixed(2)} ${"DA".tr}\n\n",
  //       ),
  //     );

  //     await PrintBluetoothThermal.writeBytes([10, 10, 10]);

  //     print("✅ تم إرسال الطباعة بنجاح");
  //   } catch (e) {
  //     showSnackbar("error".tr, "حدث خطأ أثناء الطباعة".tr, Colors.red);
  //   }
  // }

  Future<void> printUniversalTicket({
    required String name,
    required String barcode,
    required double price,
  }) async {
    try {
      await showTicketOverlay(name, barcode, price);

      final boundary =
          ticketKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final bytes = byteData!.buffer.asUint8List();

      ticketOverlay?.remove();
      ticketOverlay = null;

      // نزيد نكبّر العرض لـ 384px
      img.Image? decoded = img.decodeImage(bytes);
      decoded = img.copyResize(decoded!, width: 384);

      // نرسل للطابعة
      final rasterBytes = _convertImageToRaster(decoded);
      await PrintBluetoothThermal.writeBytes(rasterBytes);
    } catch (e) {
      print("❌ ERROR PRINT: $e");
    }
  }

  List<int> _convertImageToRaster(img.Image image) {
    List<int> bytes = [];
    int width = image.width;
    int height = image.height;
    int widthBytes = (width + 7) ~/ 8;

    bytes.addAll([
      29,
      118,
      48,
      0,
      widthBytes % 256,
      widthBytes ~/ 256,
      height % 256,
      height ~/ 256
    ]);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < widthBytes; x++) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          int px = x * 8 + bit;
          if (px < width) {
            var pixel = image.getPixel(px, y);
            if (pixel.luminance < 0.5 * 255) {
              byte |= (128 >> bit);
            }
          }
        }
        bytes.add(byte);
      }
    }
    return bytes;
  }

  void onQuantityChanged(int value) {
    quantityController.text = value.toString();
  }

  Future<void> showTicketOverlay(
      String name, String barcode, double price) async {
    ticketOverlay = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: -5000,
          left: -5000,
          child: Material(
            color: Colors.transparent,
            child: RepaintBoundary(
              key: ticketKey,
              child: buildPrintableTicket(name, barcode, price),
            ),
          ),
        );
      },
    );

    Overlay.of(Get.context!).insert(ticketOverlay!);

    // ننتظر حتى Flutter يكمل الرسم
    await Future.delayed(const Duration(milliseconds: 120));
  }

  @override
  void onInit() {
    super.onInit();
    uuid = Get.arguments['uuid'];

    getProdact();
  }
}
