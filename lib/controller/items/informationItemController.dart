import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:Silaaty/controller/items/Edititemcontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/datasource/Remote/SellerData.dart';
import 'package:Silaaty/core/class/Crud.dart';
import 'package:Silaaty/core/class/Sqldb.dart';
import 'package:Silaaty/data/model/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:uuid/uuid.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';
import 'package:image/image.dart' as img;

class Informationitemcontroller extends GetxController {
  late String uuid;
  final quantityController = TextEditingController();
  Myservices myservices = Get.find();
  final GlobalKey ticketKey = GlobalKey();

  late int? id = myservices.sharedPreferences?.getInt("id");
  int get sellType => myservices.sharedPreferences?.getInt("sell_type") ?? 3;
  int get accountType => myservices.sharedPreferences?.getInt("account_type") ?? 1;

  ProdactData prodactData = ProdactData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  bool isPrinting = false;
  int get printerWidth => 384; // Fixed 384 for labels (58mm)
  List<Data> InfoProduct = [];
  Future<void> GotoEdititem() async {
    final product = InfoProduct[0];
    final controller = Get.put(Edititemcontroller());
    controller.initData(product);
    await Get.toNamed(
      Approutes.edititemcontroller,
    );
  }

  bool isByCarton = false;
  final numberOfCartonsController = TextEditingController();

  void toggleByCarton(bool? value) {
    isByCarton = value ?? false;
    update();
  }

  void calculateCartonQuantity() {
    if (isByCarton && InfoProduct.isNotEmpty) {
      final itemsPerCarton = double.tryParse(InfoProduct.first.itemsPerCarton.toString()) ?? 1.0;
      final numberOfCartons = double.tryParse(numberOfCartonsController.text) ?? 0.0;
      final total = itemsPerCarton * numberOfCartons;
      quantityController.text = InfoProduct.first.type == 2 ? total.toString() : total.toInt().toString();
      update();
    }
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
    SQLDB sqldb = SQLDB();
    var stockData = await sqldb.readData('''
      SELECT SUM(quantity) as total_qty FROM seller_stocks WHERE product_uuid = ? AND quantity > 0
    ''', [uid]);

    double sellerQty = 0;
    if (accountType == 2 && stockData.isNotEmpty && stockData[0]['total_qty'] != null) {
      sellerQty = double.tryParse(stockData[0]['total_qty'].toString()) ?? 0.0;
    }

    if (sellerQty > 0) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
              const SizedBox(width: 10),
              Text("تنبيه".tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          content: Text(
            "لا يمكن حذف هذا المنتج لوجود كمية منه ( $sellerQty ) لدى البائعين. الرجاء استرجاع الكمية من البائعين أولاً.".tr,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.backgroundcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(),
              child: Text("حسناً".tr, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    update();
    Map<String, Object?> data = {'uuid': uid};
    var result = await prodactData.deleteProdact(data);

    print("============================================== $result");
    print("$uid");
    if (result == true) {
      Get.find<RefreshService>().fire();
      Get.back(result: true);
    } else {
      showSnackbar("error".tr, "error_deleting_product".tr, Colors.red);

      statusrequest = Statusrequest.failure;
    }
    update();
  }

  Future<void> editquantityProduct() async {
    if (double.parse(quantityController.text) <= 0) {
      showSnackbar("error".tr, "الكمية يجب أن تكون أكبر من 0".tr, Colors.red);
      return;
    }
    final double oldQty =
        double.parse(InfoProduct.first.productQuantity ?? "0");
    final double addedQty = double.parse(quantityController.text);
    final double newQty = oldQty + addedQty;

    final data = {
      "uuid": uuid,
      'product_quantity': newQty,
      'product_name': InfoProduct.first.productName ?? "",
      'product_price_purchase': InfoProduct.first.productPricePurchase ?? 0.0,
      'updated_at': DateTime.now().toIso8601String(),
    };

    var result = await prodactData.updateProduct(data, oldQty, newQty);

    print("============================================== $result");

    if (result == true) {
      Get.back();
      quantityController.clear();
      numberOfCartonsController.clear();
      isByCarton = false;
      getProdact();
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void showStockLocationsDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: const SizedBox(
          height: 100,
          child: Center(
              child:
                  CircularProgressIndicator(color: AppColor.backgroundcolor)),
        ),
      ),
    );

    List<Map<String, dynamic>> locations = [];
    double totalQuantity = 0.0;

    if (InfoProduct.isNotEmpty) {
      double warehouseQty =
          double.tryParse(InfoProduct.first.productQuantity ?? "0") ?? 0.0;
      totalQuantity += warehouseQty;
      locations.add({
        'name': 'المستودع الرئيسي'.tr,
        'quantity': InfoProduct.first.productQuantity ?? "0",
        'icon': Icons.warehouse_rounded,
        'color': Colors.blue,
      });
    }

    try {
      SellerData sellerData = SellerData(Get.find<Crud>());
      var response = await sellerData.getSellers();
      List sellers = [];
      if (response != null && response['status'] == 1) {
        sellers = response['data']['sellers'] ?? [];
      }

      SQLDB sqldb = SQLDB();
      var stockData = await sqldb.readData('''
        SELECT seller_id, quantity FROM seller_stocks WHERE product_uuid = ? AND user_id = ? AND quantity > 0
      ''', [uuid, id]);

      for (var stock in stockData) {
        String sellerId = stock['seller_id'].toString();
        String quantity = stock['quantity'].toString();
        double sellerQty = double.tryParse(quantity) ?? 0.0;
        totalQuantity += sellerQty;

        String sellerName = "بائع غير معروف".tr;
        for (var seller in sellers) {
          if (seller['id'].toString() == sellerId) {
            sellerName = seller['name'];
            break;
          }
        }

        locations.add({
          'name': sellerName,
          'quantity': quantity,
          'icon': Icons.storefront_rounded,
          'color': Colors.orange,
        });
      }
    } catch (e) {
      print("Error fetching stock locations: $e");
    }

    Get.back(); // Close loading dialog

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: AppColor.backgroundcolor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          "أماكن تواجد المنتج".tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${'الإجمالي'.tr}: ${totalQuantity == totalQuantity.truncateToDouble() ? totalQuantity.truncate() : totalQuantity.toStringAsFixed(2)} ${InfoProduct.isNotEmpty && InfoProduct.first.type == 2 ? "Kg" : ""}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: locations.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final loc = locations[index];
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: loc['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(loc['icon'], color: loc['color'], size: 24),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            loc['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: loc['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: loc['color'].withOpacity(0.3)),
                          ),
                          child: Text(
                            "${loc['quantity']} ${InfoProduct.first.type == 2 ? "Kg" : ""}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: loc['color'],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("إغلاق".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showWidthSelectionDialog({
    required String name,
    required String barcode,
    required double price,
  }) {
    Get.defaultDialog(
      title: "مقاس الورق".tr,
      middleText: "يرجى اختيار مقاس ورق الطباعة (سيتم حفظه دائماً)".tr,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          myservices.sharedPreferences?.setInt("printer_width", 384);
          Get.back();
          printUniversalTicket(name: name, barcode: barcode, price: price);
        },
        child: Text("58mm".tr, style: const TextStyle(color: Colors.white)),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          myservices.sharedPreferences?.setInt("printer_width", 576);
          Get.back();
          printUniversalTicket(name: name, barcode: barcode, price: price);
        },
        child: Text("80mm".tr, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> printUniversalTicket({
    required String name,
    required String barcode,
    required double price,
  }) async {
    if (isPrinting) return;
    isPrinting = true;
    update();
    try {
      int printerWidth = 384; // Fixed width for labels

      bool isLabelMode =
          myservices.sharedPreferences?.getString("printer_mode") == "label";

      bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!bluetoothEnabled) {
        showSnackbar(
            "تنبيه".tr, "الرجاء تفعيل البلوتوث أولاً".tr, Colors.orange);
        return;
      }

      bool isConnected = await PrintBluetoothThermal.connectionStatus;

      if (!isConnected) {
        final List<BluetoothInfo> pairedDevices =
            await PrintBluetoothThermal.pairedBluetooths;

        if (pairedDevices.isEmpty) {
          showSnackbar("تنبيه".tr, "لا توجد طابعات مقترنة".tr, Colors.orange);
          isPrinting = false;
          update();
          return;
        }

        BluetoothInfo? selectedPrinter = await Get.dialog<BluetoothInfo>(
          AlertDialog(
            backgroundColor: Colors.white,
            title: Text("اختر الطابعة".tr, textAlign: TextAlign.center),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pairedDevices.length,
                itemBuilder: (context, index) {
                  final device = pairedDevices[index];
                  return ListTile(
                    leading: const Icon(Icons.print,
                        color: AppColor.backgroundcolor),
                    title: Text(device.name),
                    subtitle: Text(device.macAdress),
                    onTap: () => Get.back(result: device),
                  );
                },
              ),
            ),
          ),
        );

        if (selectedPrinter == null) {
          isPrinting = false;
          update();
          return;
        }

        await PrintBluetoothThermal.isPermissionBluetoothGranted;
        await PrintBluetoothThermal.disconnect;
        await Future.delayed(const Duration(seconds: 1));

        bool connectionStatus = await PrintBluetoothThermal.connect(
                macPrinterAddress: selectedPrinter.macAdress)
            .timeout(const Duration(seconds: 10));

        if (!connectionStatus) {
          showSnackbar("خطأ".tr, "فشل الاتصال بالطابعة".tr, Colors.red);
          isPrinting = false;
          update();
          return;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      final boundary = ticketKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        showSnackbar("error".tr, "خطأ في تحديد مساحة الطباعة".tr, Colors.red);
        return;
      }

      final image = await boundary
          .toImage(pixelRatio: 3.0)
          .timeout(const Duration(seconds: 5));
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        showSnackbar("error".tr, "خطأ في معالجة بيانات الصورة".tr, Colors.red);
        return;
      }

      Uint8List imageBytes = byteData.buffer.asUint8List();

      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        showSnackbar("error".tr, "خطأ في فك تشفير الصورة".tr, Colors.red);
        return;
      }

      decodedImage = img.copyResize(decodedImage,
          width: printerWidth, interpolation: img.Interpolation.cubic);

      List<int> bytes;
      if (isLabelMode) {
        bytes = convertImageToTSPL(decodedImage);
      } else {
        bytes = _convertImageToEscPos(decodedImage);
      }

      // إرسال البيانات كدفعة واحدة (بدون تقسيم أو تأخير)
      // تقسيم البيانات يسبب تأخير يخدع الطابعة ويجعلها تظن أن الأمر انتهى مما يسبب التشوه
      await PrintBluetoothThermal.writeBytes(bytes);

      // showSnackbar("نجاح".tr, "تمت الطباعة بنجاح".tr, Colors.green);
    } catch (e) {
      showSnackbar("error".tr, "حدث خطأ أثناء الطباعة".tr, Colors.red);
    } finally {
      isPrinting = false;
      update();
    }
  }

  void onQuantityChanged(double value) {
    update();
  }

  @override
  void onInit() {
    super.onInit();
    uuid = Get.arguments['uuid'];
    getProdact();
    numberOfCartonsController.addListener(calculateCartonQuantity);
  }

  @override
  void onClose() {
    quantityController.dispose();
    numberOfCartonsController.dispose();
    super.onClose();
  }

  List<int> convertImageToTSPL(img.Image image) {
    // 1. جعل العرض يقبل القسمة على 8 (Padding)
    int width = (image.width / 8).ceil() * 8;
    int widthBytes = width ~/ 8;

    List<int> bytes = [];

    // قراءة نوع الورق من الإعدادات
    Myservices myServices = Get.find();
    String paperType =
        myServices.sharedPreferences?.getString("barcode_paper_type") ??
            "receipt";

    int contentHeight = image.height;
    int topMargin = 0;

    // نبحث عن أول وآخر سطر فيه محتوى (غير أبيض)
    // لقص الفراغ الزائد - يعمل على كلا نوعي الورق
    int lastContentRow = 0;
    int firstContentRow = image.height;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);
        double val = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;
        if (val < 128) {
          if (y < firstContentRow) firstContentRow = y;
          if (y > lastContentRow) lastContentRow = y;
          break;
        }
      }
    }

    if (lastContentRow > 0) {
      // قص الصورة بحيث نأخذ المحتوى الفعلي فقط
      topMargin = (firstContentRow).clamp(0, image.height);
      contentHeight =
          (lastContentRow - topMargin).clamp(1, image.height - topMargin);
    }

    int marginDots = 0;
    if (paperType == "receipt") {
      marginDots = 80;
    }

    if (paperType == "label") {
      bytes.addAll(ascii.encode("SIZE 47.5 mm, 20 mm\r\n"));
      bytes.addAll(ascii.encode("GAP 3 mm,0\r\n"));
    } else {
      // ورق فواتير: المقاس الفعلي للمحتوى + الهامش من الأعلى والأسفل
      double totalHeightMm = (contentHeight + (marginDots * 2)) / 8;
      bytes.addAll(ascii
          .encode("SIZE 57 mm, ${totalHeightMm.toStringAsFixed(1)} mm\r\n"));
      bytes.addAll(ascii.encode("GAP 0,0\r\n"));
    }

    bytes.addAll(ascii.encode("REFERENCE 0,0\r\n"));
    // تسريع الطباعة للحد الأقصى مع الحفاظ على وضوح الحبر
    bytes.addAll(ascii.encode("SPEED 4\r\n"));
    bytes.addAll(ascii.encode("DENSITY 8\r\n"));
    bytes.addAll(ascii.encode("DIRECTION 1\r\n"));
    bytes.addAll(ascii.encode("CLS\r\n"));

    // حساب الإزاحة لتوسيط الباركود أفقياً
    // حساب عرض الورق الحقيقي بالنقاط حسب النوع
    int paperWidthDots;

    if (paperType == "label") {
      // 40mm
      paperWidthDots = 40 * 8;
    } else {
      // 58mm
      paperWidthDots = 58 * 8;
    }
    int imageWidthDots = widthBytes * 8;
    int offsetX = ((paperWidthDots - imageWidthDots) / 2)
        .clamp(0, paperWidthDots)
        .toInt();

    int offsetY = 0;
    if (paperType == "label") {
      // الارتفاع الفعلي للتيكي هو 20 ملم = 160 نقطة (20 * 8)
      int labelHeightDots = 20 * 8;
      // توسيط المحتوى عمودياً تماماً داخل مساحة التيكي
      offsetY = ((labelHeightDots - contentHeight) / 2)
          .clamp(0, labelHeightDots)
          .toInt();
    } else if (paperType == "receipt") {
      // في حالة الورق المتصل، نبدأ الطباعة بعد الهامش العلوي
      offsetY = marginDots;
    }

    // أرسل BITMAP للمحتوى فقط
    bytes.addAll(
        ascii.encode("BITMAP $offsetX,$offsetY,$widthBytes,$contentHeight,0,"));

    for (int y = topMargin; y < topMargin + contentHeight; y++) {
      for (int x = 0; x < widthBytes; x++) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          int px = x * 8 + bit;
          if (px < image.width && y < image.height) {
            var pixel = image.getPixel(px, y);
            double val = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b);
            if (val > 128) {
              byte |= (0x80 >> bit);
            }
          } else {
            byte |= (0x80 >> bit);
          }
        }
        bytes.add(byte);
      }
    }

    bytes.addAll(ascii.encode("\r\nPRINT 1,1\r\n"));
    return bytes;
  }

  List<int> _convertImageToEscPos(img.Image image) {
    Myservices myServices = Get.find();

    String paperType =
        myServices.sharedPreferences?.getString("barcode_paper_type") ??
            "receipt";

    // =========================
    // إعدادات الورق
    // =========================

    int paperWidthDots;
    int topBottomMargin;

    if (paperType == "label") {
      paperWidthDots = 320; // 40mm
      topBottomMargin = 0;
    } else {
      paperWidthDots = 464; // 58mm
      topBottomMargin = 80;
    }

    // =========================
    // قص الفراغ الأبيض
    // =========================

    int lastContentRow = 0;
    int firstContentRow = image.height;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);

        double val = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;

        if (val < 128) {
          if (y < firstContentRow) firstContentRow = y;
          if (y > lastContentRow) lastContentRow = y;
          break;
        }
      }
    }

    int topMargin = 0;
    int contentHeight = image.height;

    if (lastContentRow > 0) {
      topMargin = firstContentRow.clamp(0, image.height);

      contentHeight =
          (lastContentRow - topMargin + 1).clamp(1, image.height - topMargin);
    }

    // =========================
    // توسيط أفقي (داخل الكانفاس برمجياً)
    // =========================

    int offsetX =
        ((paperWidthDots - image.width) / 2).clamp(0, paperWidthDots).toInt();

    List<int> bytes = [];

    // Initialize
    bytes.addAll([0x1B, 0x40]);

    // Center alignment (ESC a 1)
    bytes.addAll([0x1B, 0x61, 0x01]);

    // هامش علوي للفواتير (لورق الاستلام فقط)
    if (topBottomMargin > 0) {
      bytes.addAll([0x1B, 0x4A, topBottomMargin]);
    }

    // =========================
    // إنشاء Canvas بعرض الورق
    // =========================

    img.Image centeredImage = img.Image(
      width: paperWidthDots,
      height: contentHeight,
    );

    // تلوين الخلفية باللون الأبيض تماماً
    img.fill(
      centeredImage,
      color: img.ColorRgb8(255, 255, 255),
    );

    // لصق الباركود في منتصف الورقة برمجياً
    img.compositeImage(
      centeredImage,
      image,
      dstX: offsetX,
      dstY: -topMargin, // إزالة الهامش العلوي الزائد
    );

    int widthBytes = (centeredImage.width + 7) ~/ 8;

    // =========================
    // طباعة الصورة
    // =========================

    for (int y = 0; y < centeredImage.height; y += 24) {
      bytes.addAll([0x1D, 0x76, 0x30, 0x00]);

      bytes.add(widthBytes % 256);
      bytes.add(widthBytes ~/ 256);

      int chunkHeight =
          (y + 24 > centeredImage.height) ? centeredImage.height - y : 24;

      bytes.add(chunkHeight % 256);
      bytes.add(chunkHeight ~/ 256);

      for (int row = 0; row < chunkHeight; row++) {
        for (int x = 0; x < widthBytes; x++) {
          int byte = 0;

          for (int bit = 0; bit < 8; bit++) {
            int px = x * 8 + bit;

            if (px < centeredImage.width && y + row < centeredImage.height) {
              var pixel = centeredImage.getPixel(px, y + row);

              double val = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;

              if (val < 128) {
                byte |= (0x80 >> bit);
              }
            }
          }

          bytes.add(byte);
        }
      }
    }

    // هامش سفلي للورق المتصل (لورق الاستلام فقط)
    if (topBottomMargin > 0) {
      bytes.addAll([0x1B, 0x4A, topBottomMargin]);
    }

    // Feed
    bytes.addAll([0x1B, 0x64, 0x05]);

    // Cut
    bytes.addAll([0x1D, 0x56, 0x41, 0x00]);

    return bytes;
  }
}
