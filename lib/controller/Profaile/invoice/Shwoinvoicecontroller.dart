import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/datasource/Remote/SaleData.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:screenshot/screenshot.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/functions/Snacpar.dart';
import '../../../core/services/Services.dart';
import '../../../data/model/InvoiceModel.dart';
import '../../../data/model/InvoiceSalesModel.dart';

class Shwoinvoicecontroller extends GetxController {
  String? uuid;

  List<Map<String, dynamic>> products = [];

  Invoicedata invoicedata = Invoicedata(Get.find());
  Saledata saledata = Saledata();

  InvoiceSalesData? productSale;
  InvoiceItem? invoices;
  Myservices myServices = Get.find();

  Statusrequest statusrequest = Statusrequest.none;
  TextEditingController paymentPrice = TextEditingController();
  TextEditingController discount = TextEditingController();

  late double paymentpriceinvoise;
  TextEditingController qtyController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  ProdactData prodactData = ProdactData(Get.find());

  Shwoinvoice() async {
    update();
    Map<String, Object?> data = {"uuid": uuid};
    var result = await invoicedata.showInvoice(data);
    print("==================================================$result");
    if (result["status"] == 1) {
      final modele = InvoiceSalesData.fromJson(result["data"]);
      productSale = modele;
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Editinvoise(String invuuid) async {
    if (int.parse(paymentPrice.text) > getRemainingAmount()) {
      return showSnackbar(
          "تنبيه".tr, "مبلغ الدفع اكثر من المستحق".tr, Colors.orange);
    }
    paymentpriceinvoise = double.parse(paymentPrice.text) + paymentpriceinvoise;
    Map<String, Object?> data = {
      "uuid": invuuid,
      'Payment_price': paymentpriceinvoise,
    };
    print("=================================${paymentPrice.text}");
    var result = await invoicedata.Editinvoise(data);

    print("==================================================$result");
    if (result) {
      paymentPrice.clear();
      Get.back();
      Get.find<RefreshService>().fire();
      paymentPrice.addListener(() {
        update();
      });
      Shwoinvoice();
      // showSnackbar("success".tr, "operation_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "error_editing_product".tr, Colors.red);
    }
    update();
  }

  Future<void> Editdiscount(String invuuid) async {
    if (double.parse(discount.text) < 0) {
      return showSnackbar(
          "تنبيه".tr, "لا يمكن أن يكون الخصم أقل من 0".tr, Colors.orange);
    }
    if (double.parse(discount.text) > getRemainingAmount()) {
      return showSnackbar("تنبيه".tr,
          "لا يمكن أن يكون الخصم أكبر من المبلغ الإجمالي".tr, Colors.orange);
    }
    Map<String, Object?> data = {
      "uuid": invuuid,
      'discount': discount.text,
    };
    var result = await invoicedata.Editinvoise(data);

    print("==================================================$result");
    if (result) {
      discount.clear();
      Get.back();
      Get.find<RefreshService>().fire();
      Shwoinvoice();
      // showSnackbar("success".tr, "operation_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "error_editing_product".tr, Colors.red);
    }
    update();
  }

  deleteInvoice(String invuuid) async {
    Map<String, Object?> data = {
      "uuid": invuuid,
    };
    var result = await invoicedata.deleteinvoice(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      Get.back();
      Get.find<RefreshService>().fire();
      Get.back();
      // showSnackbar("success".tr, "delete_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }
  }

  Future<void> editProduct(String uuidSale, int quantity) async {
    final result = await saledata.updateSaleQuantity(
        uuidSale, int.parse(qtyController.text), getRemainingAmount());

    if (result["status"] == 1) {
      Get.back(result: true);
      qtyController.clear();
      Get.find<RefreshService>().fire();
      Shwoinvoice();
      getRemainingAmount();
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else if (result["status"] == 2) {
      showSnackbar("error".tr, "المخزون لا يكفي".tr, Colors.red);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Future<void> returnProduct(String uuidSale) async {
    final result = await saledata.returnSaleProduct(uuidSale);

    if (result["status"] == 1) {
      print(result["msg"]);
      print("===============0");

      if (result["msg"] == "true") {
        print("===============1");
        Get.back(result: true);
      }
      Get.back(result: true);
      Get.find<RefreshService>().fire();
      Shwoinvoice();
      getRemainingAmount();
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Future<void> returnFullInvoice(String uuidinvois) async {
    final result = await saledata.returnFullInvoice(uuidinvois);

    if (result["status"] == 1) {
      Get.back();
      Get.back(result: true);
      Get.find<RefreshService>().fire();
      Shwoinvoice();
      getRemainingAmount();
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  // void gotoaddproductNewSale() async {
  //   final result = await Get.toNamed(Approutes.addProductSale);
  //   if (result != null && result is List) {
  //     // addProducts(List<Map<String, dynamic>>.from(result));
  //   }
  // }

  double getRemainingAmount() {
    final total = double.tryParse(productSale?.sumPrice.toString() ?? "0") ?? 0;
    final paid =
        double.tryParse(productSale?.paymentprice.toString() ?? "0") ?? 0;
    ;
    final discount =
        double.tryParse(productSale?.discount.toString() ?? "0") ?? 0;

    final remaining = total - (paid + discount);
    return remaining < 0 ? 0 : remaining;
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null) {
      invoices = args["invoice"];
      uuid = invoices?.uuid;
      paymentpriceinvoise = invoices!.paymentPrice!;
    }

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

  Future<void> generateArabicPdf() async {
    final pdf = pw.Document();
    final arabicFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/static/Amiri-Regular.ttf"));
    final englishFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/static/Wittgenstein-Regular.ttf"));
    final productsList = productSale?.products ?? [];
    final address = myServices.sharedPreferences!.getString("adresse");
    final phoneNumber = myServices.sharedPreferences!.getString("phone");
    final nameSaler = myServices.sharedPreferences!.getString("family_name");
    final logoPath = myServices.sharedPreferences!.getString("logo_stor");
    final logoFile = File(logoPath ?? "");
    pw.MemoryImage? logo;

    if (await logoFile.exists()) {
      final imageBytes = await logoFile.readAsBytes();
      logo = pw.MemoryImage(imageBytes);
    }
    final customerName = [
      invoices?.familyName,
      invoices?.name,
    ].where((e) => e != null && e.trim().isNotEmpty).join(" ");
    final safeCustomerName =
        customerName.isEmpty ? "غير معروف".tr : customerName;

    bool isArabicText(String text) {
      final arabicRegex = RegExp(r'[\u0600-\u06FF]');
      return arabicRegex.hasMatch(text);
    }

    final isArabicName = isArabicText(safeCustomerName);

    final List<List<String>> tableData = [
      [
        "رقم".tr,
        "المنتج".tr,
        "الكمية".tr,
        "سعر الوحدة".tr,
        "السعر الإجمالي".tr
      ],
      ...List.generate(productsList.length, (index) {
        final p = productsList[index];
        return [
          (index + 1).toString(),
          p.productName,
          p.quantity.toString(),
          p.productPrice.toString(),
          p.subtotal.toString(),
        ];
      }),
    ];
    pdf.addPage(
      pw.Page(
        textDirection: Get.locale?.languageCode == "ar"
            ? pw.TextDirection.rtl
            : pw.TextDirection.ltr,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ====== Header ======
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(10),
                    border: pw.Border.all(
                        width: 2, color: PdfColor.fromHex("#4F46E5"))),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Directionality(
                          textDirection:
                              nameSaler != null && isArabicText(nameSaler)
                                  ? pw.TextDirection.rtl
                                  : pw.TextDirection.ltr,
                          child: pw.Text(
                            nameSaler ?? "",
                            style: pw.TextStyle(
                              font: nameSaler != null && isArabicText(nameSaler)
                                  ? arabicFont
                                  : englishFont,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Directionality(
                          textDirection:
                              address != null && isArabicText(address)
                                  ? pw.TextDirection.rtl
                                  : pw.TextDirection.ltr,
                          child: pw.Text("${address ?? ""}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                font: address != null && isArabicText(address)
                                    ? arabicFont
                                    : englishFont,
                              )),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(phoneNumber ?? "",
                            style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                    if (logo != null) pw.Image(logo, width: 80, height: 80),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // ====== Invoice title ======
              pw.Center(
                child: pw.Text(
                  "فاتورة بيع".tr,
                  style: pw.TextStyle(
                      font: Get.locale?.languageCode == "ar"
                          ? arabicFont
                          : englishFont,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),

              // ====== Client Info ======
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      "${'التاريخ'.tr}: ${invoices!.date!.substring(0, 10)}",
                      style: pw.TextStyle(
                          font: Get.locale?.languageCode == "ar"
                              ? arabicFont
                              : englishFont,
                          fontSize: 12)),
                  pw.Text("${'رقم الفتورة'.tr}: ${invoices!.number ?? ''}",
                      style: pw.TextStyle(
                          font: Get.locale?.languageCode == "ar"
                              ? arabicFont
                              : englishFont,
                          fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Directionality(
                textDirection:
                    isArabicName ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                child: pw.Text(
                  "${'الزبون'.tr}: $safeCustomerName",
                  style: pw.TextStyle(
                    font: isArabicName ? arabicFont : englishFont,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.SizedBox(height: 15),

              // ====== Table ======
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColor.fromHex("#4F46E5"),
                  width: 0.7,
                ),
                children: [
                  // Header
                  pw.TableRow(
                    decoration:
                        pw.BoxDecoration(color: PdfColor.fromHex("#C7C4F9")),
                    children: tableData.first.map((text) {
                      final font =
                          isArabicText(text) ? arabicFont : englishFont;
                      return pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: pw.Text(
                          text,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Rows
                  ...tableData.skip(1).map((row) {
                    return pw.TableRow(
                      children: row.map((cell) {
                        final font =
                            isArabicText(cell) ? arabicFont : englishFont;
                        return pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Directionality(
                              textDirection: isArabicText(cell)
                                  ? pw.TextDirection.rtl
                                  : pw.TextDirection.ltr,
                              child: pw.Text(
                                cell,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(font: font, fontSize: 11),
                              ),
                            ));
                      }).toList(),
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 10),

              // ====== Total ======
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "${'الإجمالي'.tr}: ${invoices!.totalSales} ${'DA'.tr} ",
                  style: pw.TextStyle(
                      font: isArabicText('الإجمالي'.tr) && isArabicText('DA'.tr)
                          ? arabicFont
                          : englishFont,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // ====== Footer ======
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                      "نشكركم على التعامل معنا، ونتطلع إلى خدمتكم مجددًا.".tr,
                      style: pw.TextStyle(
                          font: Get.locale?.languageCode == "ar"
                              ? arabicFont
                              : englishFont,
                          fontSize: 12)),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> printThermalInvoice() async {
    try {
      bool? status = await PrintBluetoothThermal.connectionStatus;
      if (status != true) {
        showSnackbar("error".tr, "لم يتم الاتصال بالطابعة".tr, Colors.red);
        return;
      }

      final productsList = productSale?.products ?? [];
      final address = myServices.sharedPreferences!.getString("adresse") ?? "";
      final phoneNumber =
          myServices.sharedPreferences!.getString("phone") ?? "";
      final nameSaler =
          myServices.sharedPreferences!.getString("family_name") ?? "";

      final customerName = [
        invoices?.familyName,
        invoices?.name,
      ].where((e) => e != null && e.trim().isNotEmpty).join(" ");
      final safeCustomerName =
          customerName.isEmpty ? "غير معروف".tr : customerName;

      final isArabic = Get.locale?.languageCode == "ar";

      // Build the receipt design as a widget
      Widget receiptWidget = _buildThermalReceiptWidget(
        nameSaler: nameSaler,
        address: address,
        phoneNumber: phoneNumber,
        invoices: invoices!,
        safeCustomerName: safeCustomerName,
        productsList: productsList,
        isArabic: isArabic,
      );

      final Uint8List? imageBytes =
          await screenshotController.captureFromWidget(
        receiptWidget,
        delay: const Duration(milliseconds: 100),
      );

      if (imageBytes != null) {
        img.Image? decodedImage = img.decodeImage(imageBytes);
        if (decodedImage != null) {
          decodedImage = img.copyResize(decodedImage, width: 384);
          final bytes = _convertImageToRaster(decodedImage);
          await PrintBluetoothThermal.writeBytes(bytes);
          await PrintBluetoothThermal.writeBytes([10, 10, 10, 10, 10]);
        }
      }
    } catch (e) {
      print("Error during thermal printing: $e");
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }
  }

  Widget _buildAmountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ", style: const TextStyle(fontSize: 14)),
          SizedBox(
            width: 120,
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void showThermalInvoicePreview() {
    final productsList = productSale?.products ?? [];
    final address = myServices.sharedPreferences!.getString("adresse") ?? "";
    final phoneNumber = myServices.sharedPreferences!.getString("phone") ?? "";
    final nameSaler =
        myServices.sharedPreferences!.getString("family_name") ?? "";

    final customerName = [
      invoices?.familyName,
      invoices?.name,
    ].where((e) => e != null && e.trim().isNotEmpty).join(" ");
    final safeCustomerName =
        customerName.isEmpty ? "غير معروف".tr : customerName;

    final isArabic = Get.locale?.languageCode == "ar";

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text("Preview".tr),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.print, color: Colors.black),
                  onPressed: () {
                    Get.back();
                    printThermalInvoice();
                  },
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: _buildThermalReceiptWidget(
                  nameSaler: nameSaler,
                  address: address,
                  phoneNumber: phoneNumber,
                  invoices: invoices!,
                  safeCustomerName: safeCustomerName,
                  productsList: productsList,
                  isArabic: isArabic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThermalReceiptWidget({
    required String nameSaler,
    required String address,
    required String phoneNumber,
    required InvoiceItem invoices,
    required String safeCustomerName,
    required List<dynamic> productsList,
    required bool isArabic,
  }) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 400, // Standard width for 58mm capture
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      nameSaler.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      address,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    if (phoneNumber.isNotEmpty)
                      Text(
                        phoneNumber,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "-------------------------------------------------------------------------",
                maxLines: 1,
                style: TextStyle(color: Colors.black, letterSpacing: -1),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${'التاريخ'.tr}: ${invoices.date!.substring(0, 10)}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(width: 5),
                  Text(
                    invoices.date!.length > 16
                        ? invoices.date!.substring(11, 19)
                        : "",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${'رقم الفتورة'.tr}: ${invoices.number}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${'الزبون'.tr}: $safeCustomerName",
                    style: const TextStyle(
                        fontSize: 14, color: Color.fromRGBO(0, 0, 0, 1)),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "-------------------------------------------------------------------------",
                maxLines: 1,
                style: TextStyle(color: Colors.black, letterSpacing: -1),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text("المنتج".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('QTY'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text("سعر الوحدة".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                          textAlign:
                              isArabic ? TextAlign.left : TextAlign.right)),
                  Expanded(
                      flex: 2,
                      child: Text('السعر الإجمالي'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                          textAlign:
                              isArabic ? TextAlign.left : TextAlign.right)),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                "-------------------------------------------------------------------------",
                maxLines: 1,
                style: TextStyle(color: Colors.black, letterSpacing: -1),
              ),
              const SizedBox(height: 10),
              ...productsList.map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(p.productName,
                                style: const TextStyle(fontSize: 13))),
                        Expanded(
                            flex: 2,
                            child: Text("${p.quantity}",
                                style: const TextStyle(fontSize: 13))),
                        Expanded(
                            flex: 2,
                            child: Text("${p.subtotal}",
                                textAlign:
                                    isArabic ? TextAlign.left : TextAlign.right,
                                style: const TextStyle(fontSize: 13))),
                        Expanded(
                            flex: 2,
                            child: Text("${p.unitPrice}",
                                textAlign:
                                    isArabic ? TextAlign.left : TextAlign.right,
                                style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
              const SizedBox(height: 15),
              const Text(
                "-------------------------------------------------------------------------",
                maxLines: 1,
                style: TextStyle(color: Colors.black, letterSpacing: -1),
              ),
              const SizedBox(height: 10),
              _buildAmountRow("SUBTOTAL".tr, "${invoices.totalSales}"),
              if (double.tryParse(invoices.discount.toString()) != 0)
                _buildAmountRow("Discount".tr, "${invoices.discount!}"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "AMOUNT".tr,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${invoices.totalSales! - invoices.discount!} ${'DA'.tr}",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "-------------------------------------------------------------------------",
                maxLines: 1,
                style: TextStyle(color: Colors.black, letterSpacing: -1),
              ),
              const SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    Text(
                      "*** ${'THANK YOU'.tr} ***",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (invoices.uuid != null)
                      SizedBox(
                        height: 60,
                        width: 200,
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: invoices.uuid!,
                          drawText: false,
                          width: 200,
                          height: 60,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
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
            if (pixel.luminance < 128) {
              byte |= (128 >> bit);
            }
          }
        }
        bytes.add(byte);
      }
    }
    return bytes;
  }

  // Future<void> printInvoiceBluetooth() async {
  //   try {
  //     // تحقق من حالة الاتصال الحالية
  //     bool isConnected = await PrintBluetoothThermal.connectionStatus;

  //     if (!isConnected) {
  //       // جلب الأجهزة المقترنة
  //       final devices = await PrintBluetoothThermal.pairedBluetooths;

  //       if (devices.isEmpty) {
  //         Get.snackbar("error".tr, "لا يوجد أي طابعة بلوتوث مقترنة".tr,
  //             backgroundColor: Colors.red, colorText: Colors.white);
  //         return;
  //       }

  //       // عرض حوار لاختيار الطابعة
  //       final selected = await Get.dialog(
  //         AlertDialog(
  //           backgroundColor: AppColor.white,
  //           title: Center(child: Text("اختر الطابعة".tr)),
  //           content: SizedBox(
  //             width: double.maxFinite,
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: devices.length,
  //               itemBuilder: (context, index) {
  //                 final device = devices[index];
  //                 return ListTile(
  //                   leading: const Icon(Icons.print),
  //                   title: Text(device.name),
  //                   subtitle: Text(device.macAdress),
  //                   onTap: () {
  //                     Get.back(result: device.macAdress);
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       );

  //       if (selected == null) {
  //         Get.snackbar("إلغاء".tr, "لم يتم اختيار أي طابعة".tr);
  //         return;
  //       }

  //       // الاتصال بالطابعة المختارة
  //       await PrintBluetoothThermal.connect(macPrinterAddress: selected);
  //     }

  //     // بناء نص الفاتورة للطباعة
  //     StringBuffer buffer = StringBuffer();
  //     buffer.writeln("فاتورة مبيعات".tr);
  //     buffer.writeln("===========================");
  //     buffer.writeln("${'الزبون'.tr}: ${invoices!.familyName ?? ''}");
  //     buffer.writeln(
  //         "${'التاريخ'.tr}: ${invoices?.date?.substring(0, 10) ?? ''}");
  //     buffer.writeln("---------------------------");

  //     for (var p in productSale?.products ?? []) {
  //       buffer.writeln(
  //           "${p.productName}  x${p.quantity}  = ${p.subtotal.toStringAsFixed(2)}");
  //     }

  //     buffer.writeln("---------------------------");
  //     buffer.writeln("الإجمالي: ${invoices?.totalSales ?? 0} دج");
  //     buffer.writeln("المدفوع: ${invoices?.paymentPrice ?? 0} دج");
  //     buffer.writeln("الباقي: ${getRemainingAmount().toStringAsFixed(2)} دج");
  //     buffer.writeln("===========================");
  //     buffer.writeln("شكراً لتعاملكم معنا ❤️");

  //     await PrintBluetoothThermal.writeString(
  //       printText: PrintTextSize(
  //         size: 2,
  //         text: buffer.toString(),
  //       ),
  //     );

  //     Get.snackbar("تم".tr, "تم إرسال الفاتورة للطابعة بنجاح".tr,
  //         backgroundColor: Colors.green, colorText: Colors.white);
  //   } catch (e) {
  //     print("❌ خطأ أثناء الطباعة: $e");
  //     Get.snackbar("error".tr, "${'حدث خطأ أثناء الطباعة'.tr}$e".tr,
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //   }
  // }

  // Future<pw.Document> buildInvoicePdf() async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(
  //               "فاتورة مبيعات",
  //               style:
  //                   pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Divider(),
  //             pw.Text("الزبون: ${invoices?.familyName ?? ''}"),
  //             pw.Text("التاريخ: ${invoices?.date?.substring(0, 10) ?? ''}"),
  //             pw.SizedBox(height: 15),
  //             pw.Divider(),
  //             pw.Column(
  //               children: [
  //                 for (var p in productSale?.products ?? [])
  //                   pw.Row(
  //                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       pw.Text(p.productName),
  //                       pw.Text("x${p.quantity}"),
  //                       pw.Text(p.subtotal.toStringAsFixed(2)),
  //                     ],
  //                   )
  //               ],
  //             ),
  //             pw.Divider(),
  //             pw.SizedBox(height: 10),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text("الإجمالي"),
  //                 pw.Text("${invoices?.totalSales ?? 0} دج"),
  //               ],
  //             ),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text("المدفوع"),
  //                 pw.Text("${invoices?.paymentPrice ?? 0} دج"),
  //               ],
  //             ),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text("الباقي"),
  //                 pw.Text("${getRemainingAmount().toStringAsFixed(2)} دج"),
  //               ],
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Center(child: pw.Text("شكراً لتعاملكم معنا ❤️")),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   return pdf;
  // }

  // Future<void> previewInvoicePdf() async {
  //   final pdf = await buildInvoicePdf();

  //   await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdf.save(),
  //   );
  // }
}
