import 'dart:io';
import 'dart:convert';
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
import 'package:pos_universal_printer/pos_universal_printer.dart';

import '../../../core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import '../../../core/functions/Snacpar.dart';
import '../../../data/model/InvoiceModel.dart';
import '../../../data/model/InvoiceSalesModel.dart';

class Shwoinvoicecontroller extends GetxController {
  String? uuid;
  bool isPrinting = false;

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
    print("========================$result");
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
    if ((double.tryParse(paymentPrice.text) ?? 0.0) > getRemainingAmount()) {
      return showSnackbar(
          "تنبيه".tr, "مبلغ الدفع اكثر من المستحق".tr, Colors.orange);
    }
    paymentpriceinvoise = double.parse(paymentPrice.text) + paymentpriceinvoise;
    Map<String, Object?> data = {
      "uuid": invuuid,
      'Payment_price': paymentpriceinvoise,
    };
    var result = await invoicedata.Editinvoise(data);
    if (result) {
      paymentPrice.clear();
      Get.back();
      Get.find<RefreshService>().fire();
      Shwoinvoice();
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
    if (result) {
      discount.clear();
      Get.back();
      Get.find<RefreshService>().fire();
      Shwoinvoice();
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
    if (result["status"] == 1) {
      Get.back();
      Get.find<RefreshService>().fire();
      Get.back();
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }
  }

  Future<void> editProduct(String uuidSale, double quantity) async {
    final result = await saledata.updateSaleQuantity(
        uuidSale, quantity, getRemainingAmount());
    if (result["status"] == 1) {
      Get.back(result: true);
      qtyController.clear();
      Get.find<RefreshService>().fire();
      Shwoinvoice();
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
      Get.back(result: true);
      Get.find<RefreshService>().fire();
      Shwoinvoice();
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
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  double getRemainingAmount() {
    final total = double.tryParse(productSale?.sumPrice.toString() ?? "0") ?? 0;
    final paid =
        double.tryParse(productSale?.paymentprice.toString() ?? "0") ?? 0;
    final discount =
        double.tryParse(productSale?.discount.toString() ?? "0") ?? 0;
    double remaining = total - (paid + discount);
    
    // Fix floating point precision
    remaining = double.parse(remaining.toStringAsFixed(3));
    
    return remaining <= 0 ? 0 : remaining;
  }

  @override
  void onInit() {
    final args = Get.arguments;
    bool autoPrint = false;
    if (args != null) {
      invoices = args["invoice"];
      uuid = invoices?.uuid;
      paymentpriceinvoise = invoices?.paymentPrice ?? 0;
      autoPrint = args["autoPrint"] ?? false;
    }
    
    if (uuid != null) {
      Shwoinvoice().then((_) {
        if (autoPrint) {
          Future.delayed(const Duration(milliseconds: 500), () {
            printThermalInvoice();
          });
        }
      });
    }
    super.onInit();
  }

  @override
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
              if (invoices!.saleType != null) ...[
                pw.SizedBox(height: 5),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "${'نوع البيع'.tr}: ${invoices!.saleType == 3 ? 'جملة'.tr : (invoices!.saleType == 2 ? 'نصف جملة'.tr : 'تجزئة'.tr)}",
                    style: pw.TextStyle(
                      font: Get.locale?.languageCode == "ar" ? arabicFont : englishFont,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              pw.SizedBox(height: 15),
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColor.fromHex("#4F46E5"),
                  width: 0.7,
                ),
                children: [
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
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Column(
                  children: [
                    _buildPdfRow(arabicFont, englishFont, "المجموع الفرعي".tr,
                        "${invoices!.totalSales} ${'DA'.tr}"),
                    if (invoices!.discount != 0)
                      _buildPdfRow(arabicFont, englishFont, "الخصم".tr,
                          "${invoices!.discount} ${'DA'.tr}"),
                    _buildPdfRow(arabicFont, englishFont, "المدفوع".tr,
                        "${double.tryParse(productSale?.paymentprice.toString() ?? "0") ?? 0} ${'DA'.tr}"),
                    pw.Divider(color: PdfColor.fromHex("#4F46E5")),
                    _buildPdfRow(arabicFont, englishFont, "الباقي".tr,
                        "${getRemainingAmount()} ${'DA'.tr}",
                        isBold: true),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
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

  pw.Widget _buildPdfRow(
      pw.Font arabicFont, pw.Font englishFont, String label, String value,
      {bool isBold = false}) {
    bool isArabicText(String text) {
      final arabicRegex = RegExp(r'[\u0600-\u06FF]');
      return arabicRegex.hasMatch(text);
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: isArabicText(label) ? arabicFont : englishFont,
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: isArabicText(value) ? arabicFont : englishFont,
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  final ScreenshotController screenshotController = ScreenshotController();
  int get printerWidth =>
      myServices.sharedPreferences?.getInt("printer_width") ?? 460;
  set printerWidth(int value) =>
      myServices.sharedPreferences?.setInt("printer_width", value);

  void showWidthSelectionDialog() {
    Get.defaultDialog(
      title: "مقاس الورق".tr,
      middleText: "يرجى اختيار مقاس ورق الفواتير (سيتم حفظه دائماً)".tr,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          myServices.sharedPreferences?.setInt("printer_width", 460);
          Get.back();
          printThermalInvoice();
        },
        child: Text("58mm".tr, style: const TextStyle(color: Colors.white)),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          myServices.sharedPreferences?.setInt("printer_width", 576);
          Get.back();
          printThermalInvoice();
        },
        child: Text("80mm".tr, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> printThermalInvoice() async {
    if (isPrinting) return;

    isPrinting = true;
    update();

    try {
      int? savedWidth = myServices.sharedPreferences?.getInt("printer_width");

      if (savedWidth == null) {
        isPrinting = false;
        update();
        showWidthSelectionDialog();
        return;
      }

      int printerWidth = savedWidth;

      bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;

      if (!bluetoothEnabled) {
        showSnackbar(
          "تنبيه".tr,
          "الرجاء تفعيل البلوتوث أولاً".tr,
          Colors.orange,
        );

        return;
      }

      bool isConnected = await PrintBluetoothThermal.connectionStatus;

      if (!isConnected) {
        final List<BluetoothInfo> pairedDevices =
            await PrintBluetoothThermal.pairedBluetooths;

        if (pairedDevices.isEmpty) {
          showSnackbar(
            "تنبيه".tr,
            "لا توجد طابعات مقترنة".tr,
            Colors.orange,
          );

          isPrinting = false;
          update();
          return;
        }

        BluetoothInfo? selectedPrinter = await Get.dialog<BluetoothInfo>(
          AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "اختر الطابعة".tr,
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pairedDevices.length,
                itemBuilder: (context, index) {
                  final device = pairedDevices[index];

                  return ListTile(
                    leading: const Icon(
                      Icons.print,
                      color: AppColor.backgroundcolor,
                    ),
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

        bool connectionStatus = await PrintBluetoothThermal.connect(
          macPrinterAddress: selectedPrinter.macAdress,
        ).timeout(
          const Duration(seconds: 5),
        );

        if (!connectionStatus) {
          showSnackbar(
            "خطأ".tr,
            "فشل الاتصال بالطابعة".tr,
            Colors.red,
          );

          isPrinting = false;
          update();
          return;
        }
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

      Widget receiptWidget = _buildThermalReceiptWidget(
        nameSaler: nameSaler,
        address: address,
        phoneNumber: phoneNumber,
        invoices: invoices!,
        safeCustomerName: safeCustomerName,
        productsList: productsList,
        isArabic: isArabic,
        width: printerWidth.toDouble(),
      );

      final Uint8List? imageBytes =
          await screenshotController.captureFromWidget(
        receiptWidget,
        delay: Duration.zero,
        pixelRatio: 3.0,
      );

      if (imageBytes != null) {
        img.Image? decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          decodedImage = img.copyResize(
            decodedImage,
            width: printerWidth,
            interpolation: img.Interpolation.cubic,
          );

          List<int> bytes;

          String? printerMode = myServices.sharedPreferences?.getString(
            "printer_mode",
          );

          if (printerMode == "label") {
            bytes = convertImageToTSPL(decodedImage);
          } else {
            bytes = _convertImageToEscPos(decodedImage);
          }

          await PrintBluetoothThermal.writeBytes(bytes);
        }
      }
    } catch (e) {
      showSnackbar(
        "error".tr,
        "حدث خطأ أثناء الطباعة".tr,
        Colors.red,
      );
    } finally {
      isPrinting = false;
      update();
    }
  }

  Widget _buildAmountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ", style: const TextStyle(fontSize: 14, fontFamily: 'Cairo', color: Colors.black)),
          Text(value,
              textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontFamily: 'Cairo', color: Colors.black)),
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
                  width: printerWidth.toDouble(),
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
    double width = 460.0,
  }) {
    return Container(
        color: Colors.white,
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Material(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: width,
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
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black, fontFamily: 'Cairo'),
                          textAlign: TextAlign.center,
                        ),
                        if (phoneNumber.isNotEmpty)
                          Text(
                            phoneNumber,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black, fontFamily: 'Cairo'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${'التاريخ'.tr}: ${invoices.date!.substring(0, 10)}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        invoices.date!.length > 16
                            ? invoices.date!.substring(11, 19)
                            : "",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${'رقم الفتورة'.tr}: ${invoices.number}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${'الزبون'.tr}: $safeCustomerName",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (invoices.saleType != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          "${'نوع البيع'.tr}: ${invoices.saleType == 3 ? 'جملة'.tr : (invoices.saleType == 2 ? 'نصف جملة'.tr : 'تجزئة'.tr)}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text("المنتج".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo', color: Colors.black))),
                      Expanded(
                          flex: 1,
                          child: Text('QTY'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo', color: Colors.black))),
                      Expanded(
                          flex: 2,
                          child: Text("سعر الوحدة".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo', color: Colors.black),
                              textAlign:
                                  isArabic ? TextAlign.left : TextAlign.right)),
                      Expanded(
                          flex: 2,
                          child: Text('السعر الإجمالي'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo', color: Colors.black),
                              textAlign:
                                  isArabic ? TextAlign.left : TextAlign.right)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1.5,
                    color: Colors.black,
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
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Cairo', color: Colors.black))),
                            Expanded(
                                flex: 1,
                                child: Text("${p.quantity}",
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Cairo', color: Colors.black))),
                            Expanded(
                                flex: 2,
                                child: Text("${p.unitPrice != null ? formavalue(p.unitPrice!) : ""}",
                                    textAlign: isArabic
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Cairo', color: Colors.black))),
                            Expanded(
                                flex: 2,
                                child: Text("${p.subtotal != null ? formavalue(p.subtotal!) : ""}",
                                    textAlign: isArabic
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Cairo', color: Colors.black))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  _buildAmountRow(
                      "المجموع الفرعي".tr, "${invoices.totalSales} ${'DA'.tr}"),
                  if (double.tryParse(invoices.discount.toString()) != 0)
                    _buildAmountRow(
                        "الخصم".tr, "${invoices.discount!} ${'DA'.tr}"),
                  _buildAmountRow("المدفوع".tr,
                      "${double.tryParse(productSale?.paymentprice.toString() ?? "0") ?? 0} ${'DA'.tr}"),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الباقي".tr,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Colors.black),
                      ),
                      Text(
                        "${formavalue(getRemainingAmount())} ${'DA'.tr}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "*** ${'THANK YOU'.tr} ***",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Colors.black),
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
        ));
  }

  List<int> convertImageToTSPL(img.Image image) {
    // 1. جعل العرض يقبل القسمة على 8 (Padding)
    int width = (image.width / 8).ceil() * 8;
    int widthBytes = width ~/ 8;

    List<int> bytes = [];

    // الفواتير دائماً تستخدم ورق متصل بغض النظر عن إعدادات الباركود

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
      // الفواتير دائماً ورق متصل، نجعل الهامش 120 (حوالي 1.5 سم)
      int margin = 120;
      topMargin = (firstContentRow - margin).clamp(0, image.height);
      contentHeight = (lastContentRow - topMargin + margin)
          .clamp(1, image.height - topMargin);
    }
    int topPadding = 50;
    int bottomPadding = 0;
    // تحديد عرض الورق الفعلي بالمليمتر بناءً على حجم الصورة
    int paperWidthMm = (image.width <= 460) ? 57 : 80;
    double totalHeight = ((contentHeight + topPadding + bottomPadding) / 8 + 2);
    // الإعدادات الأساسية - SIZE يعكس الارتفاع الفعلي للمحتوى فقط
    bytes.addAll(ascii.encode(
        "SIZE $paperWidthMm mm, ${totalHeight.toStringAsFixed(1)} mm\r\n"));
    // ورق فواتير (متصل) - بدون فجوات دائماً
    bytes.addAll(ascii.encode("GAP 0,0\r\n"));

    // تسريع الطباعة للحد الأقصى
    bytes.addAll(ascii.encode("SPEED 4\r\n"));
    bytes.addAll(ascii.encode("DENSITY 8\r\n"));

    bytes.addAll(ascii.encode("DIRECTION 1\r\n"));
    bytes.addAll(ascii.encode("CLS\r\n"));

    // حساب الإزاحة لتوسيط الفاتورة أفقياً
    // عرض الورق الفعلي 57 مم = 464 نقطة، بينما الصورة 460 نقطة (أو 640 لـ 80مم)
    int physicalWidthDots = (image.width == 460) ? (57 * 8) : (80 * 8);
    int imageWidthDots = widthBytes * 8;
    int offsetX = ((physicalWidthDots - imageWidthDots) / 2)
        .clamp(0, physicalWidthDots)
        .toInt();

    // إضافة معايرة يدوية (نفس التي استخدمتها للباركود) لدفع الفاتورة لليمين أكثر

    bytes.addAll(ascii
        .encode("BITMAP $offsetX,$topPadding,$widthBytes,$contentHeight,0,"));

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
    // =========================
    // قص الفراغ الأبيض الزائد
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
      topMargin = (firstContentRow).clamp(0, image.height);
      contentHeight =
          (lastContentRow - topMargin + 1).clamp(1, image.height - topMargin);
    }

    int topPadding = 50;
    int bottomPadding = 0;

    Myservices myServices = Get.find();
    int settingsWidth =
        myServices.sharedPreferences?.getInt("printer_width") ?? 460;

    // حساب عرض الورق الفيزيائي بناءً على إعدادات المستخدم مباشرة لتفادي الإزاحة
    int physicalWidthDots = settingsWidth;

    // =========================
    // إنشاء Canvas بعرض الورق وتوسيط الصورة فيه
    // =========================
    
    // حساب الإزاحة لتوسيط الفاتورة أفقياً داخل الكانفاس
    int offsetX = ((physicalWidthDots - image.width) / 2)
        .clamp(0, physicalWidthDots)
        .toInt();

    img.Image centeredImage = img.Image(
      width: physicalWidthDots,
      height: contentHeight,
    );

    // ملء الخلفية باللون الأبيض
    img.fill(
      centeredImage,
      color: img.ColorRgb8(255, 255, 255),
    );

    // لصق الفاتورة الأصلية في منتصف الـ Canvas
    img.compositeImage(
      centeredImage,
      image,
      dstX: offsetX,
      dstY: -topMargin, // نلغي الهامش العلوي الزائد هنا
    );

    int widthBytes = (centeredImage.width + 7) ~/ 8;

    // =========================
    // تحويل الـ Canvas إلى أوامر ESC/POS
    // =========================

    List<int> bytes = [];
    bytes.addAll([0x1B, 0x40]); // Initialize
    bytes.addAll([0x1B, 0x61, 0x01]); // Center alignment

    // إضافة الهامش العلوي للفاتورة
    if (topPadding > 0) {
      bytes.addAll([0x1B, 0x4A, topPadding]);
    }

    for (int y = 0; y < centeredImage.height; y += 24) {
      bytes.addAll([0x1D, 0x76, 0x30, 0x00]);
      bytes.add(widthBytes % 256);
      bytes.add(widthBytes ~/ 256);
      
      int chunkHeight = (y + 24 > centeredImage.height)
          ? centeredImage.height - y
          : 24;
          
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

    // إضافة الهامش السفلي للفاتورة
    if (bottomPadding > 0) {
      bytes.addAll([0x1B, 0x4A, bottomPadding]);
    }

    bytes.addAll([0x1B, 0x64, 0x05]); // Feed 5 lines at the end
    bytes.addAll([0x1D, 0x56, 0x41, 0x00]); // Cut
    return bytes;
  }

}
