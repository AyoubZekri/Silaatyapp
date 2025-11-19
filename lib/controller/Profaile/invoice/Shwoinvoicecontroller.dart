import 'dart:io';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:printing/printing.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/datasource/Remote/SaleData.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';

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
      showSnackbar("success".tr, "operation_success".tr, Colors.green);
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
      showSnackbar("success".tr, "operation_success".tr, Colors.green);
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
      showSnackbar("success".tr, "delete_success".tr, Colors.green);
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
      showSnackbar("success".tr, "update_success".tr, Colors.green);
    } else if (result["status"] == 2) {
      showSnackbar("error".tr, "المخزون لا يكفي".tr, Colors.red);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  deleteProduct(String invuuid) async {
    Map<String, Object?> data = {
      "uuid": invuuid,
      "RemainingAmount": getRemainingAmount(),
    };
    var result = await saledata.deleteProdact(data);
    print("================================deleteProdact$result");

    if (result) {
      Get.back(result: true);
      Get.find<RefreshService>().fire();
      Shwoinvoice();
      getRemainingAmount();
      showSnackbar("success".tr, "delete_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }
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
    final font = await PdfGoogleFonts.cairoRegular();
    final productsList = productSale?.products ?? [];
    final address = myServices.sharedPreferences!.getString("adresse");
    final logoPath = myServices.sharedPreferences!.getString("logo_stor");
    final logoFile = File(logoPath ?? "");
    pw.MemoryImage? logo;

    if (await logoFile.exists()) {
      final imageBytes = await logoFile.readAsBytes();
      logo = pw.MemoryImage(imageBytes);
    }

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
        textDirection: pw.TextDirection.rtl,
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
                      children: [
                        pw.Text("${invoices?.familyName} ${invoices?.name}",
                            style: pw.TextStyle(
                                font: font,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(address.toString(),
                            style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text(invoices?.phoneNumber ?? "",
                            style: pw.TextStyle(font: font, fontSize: 12)),
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
                      font: font, fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),

              // ====== Client Info ======
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      "${'التاريخ'.tr}: ${invoices!.date!.substring(0, 10)}",
                      style: pw.TextStyle(font: font, fontSize: 12)),
                  pw.Text("${'رقم الفتورة'.tr}: ${invoices!.number ?? ''}",
                      style: pw.TextStyle(font: font, fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                  "${'الزبون'.tr}: ${invoices!.familyName} ${invoices!.name}",
                  style: pw.TextStyle(font: font, fontSize: 12)),
              pw.SizedBox(height: 15),

              // ====== Table ======
              pw.Table.fromTextArray(
                data: tableData,
                headerDecoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#C7C4F9"),
                ),
                headerStyle: pw.TextStyle(
                    font: font, fontWeight: pw.FontWeight.bold, fontSize: 12),
                cellStyle: pw.TextStyle(font: font, fontSize: 11),
                cellAlignment: pw.Alignment.center,
                border: pw.TableBorder.all(
                    color: PdfColor.fromHex("#4F46E5"), width: 0.7),
                headerAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                },
              ),

              pw.SizedBox(height: 10),

              // ====== Total ======
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "${'الإجمالي'.tr}: ${invoices!.totalSales} ${'DA'.tr} ",
                  style: pw.TextStyle(
                      font: font, fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // ====== Footer ======
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                      "نشكركم على التعامل معنا، ونتطلع إلى خدمتكم مجددًا.".tr,
                      style: pw.TextStyle(font: font, fontSize: 12)),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> printInvoiceBluetooth() async {
    try {
      // تحقق من حالة الاتصال الحالية
      bool isConnected = await PrintBluetoothThermal.connectionStatus;

      if (!isConnected) {
        // جلب الأجهزة المقترنة
        final devices = await PrintBluetoothThermal.pairedBluetooths;

        if (devices.isEmpty) {
          Get.snackbar("error".tr, "لا يوجد أي طابعة بلوتوث مقترنة".tr,
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // عرض حوار لاختيار الطابعة
        final selected = await Get.dialog(
          AlertDialog(
            backgroundColor: AppColor.white,
            title: Center(child: Text("اختر الطابعة".tr)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(device.name),
                    subtitle: Text(device.macAdress),
                    onTap: () {
                      Get.back(result: device.macAdress);
                    },
                  );
                },
              ),
            ),
          ),
        );

        if (selected == null) {
          Get.snackbar("إلغاء".tr, "لم يتم اختيار أي طابعة".tr);
          return;
        }

        // الاتصال بالطابعة المختارة
        await PrintBluetoothThermal.connect(macPrinterAddress: selected);
      }

      // بناء نص الفاتورة للطباعة
      StringBuffer buffer = StringBuffer();
      buffer.writeln("فاتورة مبيعات".tr);
      buffer.writeln("===========================");
      buffer.writeln("${'الزبون'.tr}: ${invoices!.familyName ?? ''}");
      buffer.writeln(
          "${'التاريخ'.tr}: ${invoices?.date?.substring(0, 10) ?? ''}");
      buffer.writeln("---------------------------");

      for (var p in productSale?.products ?? []) {
        buffer.writeln(
            "${p.productName}  x${p.quantity}  = ${p.subtotal.toStringAsFixed(2)}");
      }

      buffer.writeln("---------------------------");
      buffer.writeln("الإجمالي: ${invoices?.totalSales ?? 0} دج");
      buffer.writeln("المدفوع: ${invoices?.paymentPrice ?? 0} دج");
      buffer.writeln("الباقي: ${getRemainingAmount().toStringAsFixed(2)} دج");
      buffer.writeln("===========================");
      buffer.writeln("شكراً لتعاملكم معنا ❤️");

      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 2,
          text: buffer.toString(),
        ),
      );

      Get.snackbar("تم".tr, "تم إرسال الفاتورة للطابعة بنجاح".tr,
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print("❌ خطأ أثناء الطباعة: $e");
      Get.snackbar("error".tr, "${'حدث خطأ أثناء الطباعة'.tr}$e".tr,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
