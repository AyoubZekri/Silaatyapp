import 'dart:io';

import 'package:Silaaty/controller/items/informationItemController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import 'package:Silaaty/view/widget/Iformationitem/iconButton.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';
import '../../widget/addItem/CustomAddquntetyproductdialog.dart';
import 'package:Silaaty/core/services/Services.dart';

class Informationitem extends StatefulWidget {
  const Informationitem({super.key});

  @override
  State<Informationitem> createState() => _InformationitemState();
}

class _InformationitemState extends State<Informationitem> {
  @override
  Widget build(BuildContext context) {
    int accountType = Get.find<Myservices>().sharedPreferences?.getInt("account_type") ?? 1;
    Informationitemcontroller controller = Get.put(Informationitemcontroller());
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'تفاصيل المنتج'.tr,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColor.backgroundcolor,
                fontSize: 24,
              ),
        ),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: GetBuilder<Informationitemcontroller>(
        builder: (_) {
          if (controller.InfoProduct.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = controller.InfoProduct[0];
          
          double totalQty = double.tryParse(product.productQuantity?.toString() ?? "0") ?? 0.0;
          double price = double.tryParse(product.productPrice?.toString() ?? "0") ?? 0.0;
          double pricePurchase = double.tryParse(product.productPricePurchase?.toString() ?? "0") ?? 0.0;
          
          double realTotalSale = totalQty * price;
          double realTotalPurchase = totalQty * pricePurchase;

          String remainingCartons = product.quantityPerCarton?.toString() ?? "0";
          if (product.itemsPerCarton != null && product.itemsPerCarton.toString() != "0") {
            double itemsPerCarton = double.tryParse(product.itemsPerCarton.toString()) ?? 1.0;
            if (itemsPerCarton > 0) {
              double cartons = totalQty / itemsPerCarton;
              if (cartons == cartons.toInt()) {
                remainingCartons = cartons.toInt().toString();
              } else {
                remainingCartons = cartons.toStringAsFixed(3).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
              }
            }
          }

          return Handlingview(
            statusrequest: controller.statusrequest,
            widget: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (product.productImage?.isNotEmpty ?? false)
                        ? Image.file(
                            File(product.productImage!),
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            Appimageassets.test2,
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  color: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.productName ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.backgroundcolor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Iconbutton(
                              iconData: Icons.print,
                              onTap: () {
                                showPrintPreview(
                                    context,
                                    product.productName.toString(),
                                    product.codepar.toString(),
                                    product.productPrice ?? 0.0,
                                    controller);
                              },
                            ),
                            const SizedBox(width: 10),
                            Iconbutton(
                              iconData: Icons.edit,
                              onTap: () async {
                                await controller.GotoEdititem();
                                controller.getProdact();
                              },
                            ),
                            const SizedBox(width: 10),
                            Iconbutton(
                              iconData: Icons.playlist_add,
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return GetBuilder<Informationitemcontroller>(
                                      builder: (controller) => Customaddquntetyproductdialog(
                                        isDecimal: controller.InfoProduct.first.type == 2,
                                        Mycontroller: controller.quantityController,
                                        value: double.tryParse(controller.quantityController.text) ?? 1,
                                        onPressed: () {
                                          controller.editquantityProduct();
                                        },
                                        onback: () {
                                          Get.back();
                                          controller.quantityController.clear();
                                          controller.numberOfCartonsController.clear();
                                          controller.isByCarton = false;
                                          controller.update();
                                        },
                                        title: 'إضافة كمية جديدة'.tr,
                                        onChanged: (double p1) {
                                          controller.onQuantityChanged(p1);
                                        },
                                        cartonWidget: (controller.InfoProduct.first.itemsPerCarton != null && controller.InfoProduct.first.itemsPerCarton.toString() != "0")
                                            ? Column(
                                                children: [
                                                  CheckboxListTile(
                                                    title: Text("إضافة بالكرتون".tr, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.backgroundcolor)),
                                                    value: controller.isByCarton,
                                                    activeColor: AppColor.backgroundcolor,
                                                    onChanged: controller.toggleByCarton,
                                                  ),
                                                  if (controller.isByCarton)
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      child: TextFormField(
                                                        controller: controller.numberOfCartonsController,
                                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                        decoration: InputDecoration(
                                                          labelText: "عدد الكراتين".tr,
                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Iconbutton(
                              iconData: Icons.delete,
                              onTap: () {
                                Get.defaultDialog(
                                  backgroundColor: AppColor.white,
                                  title: "Alert".tr,
                                  titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.backgroundcolor,
                                  ),
                                  middleText: "هل تريد حذف المنتج؟".tr,
                                  onConfirm: () {
                                    controller.deleteProdact(product.uuid!);
                                    Get.back(result: true);
                                  },
                                  onCancel: () {},
                                  buttonColor: AppColor.backgroundcolor,
                                  confirmTextColor: AppColor.primarycolor,
                                  cancelTextColor: AppColor.backgroundcolor,
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        _infoRow("المنتج ميزان؟".tr, product.type == 2 ? "ميزان".tr : "غير ميزان".tr),
                        _infoRow("كود المنتج".tr, product.productCode?.toString() ?? '-'),
                        _infoRow("Barcode".tr, product.codepar.toString()),
                        const Divider(height: 30),
                        _infoRow(
                          "سعر الشراء".tr,
                          "${product.productPricePurchase != null ? formavalue(product.productPricePurchase!) : ''} ${'دينار'.tr}",
                        ),
                        _infoRow(
                          "سعر التجزئة".tr,
                          "${product.productPrice != null ? formavalue(product.productPrice!) : ''} ${'دينار'.tr}",
                        ),
                        if (controller.sellType >= 2)
                          _infoRow(
                            "سعر النصف جملة".tr,
                            "${product.productPriceHalfWholesale != null ? formavalue(product.productPriceHalfWholesale!) : ''} ${'دينار'.tr}",
                          ),
                        if (controller.sellType >= 3)
                          _infoRow(
                            "سعر الجملة".tr,
                            "${product.productPriceWholesale != null ? formavalue(product.productPriceWholesale!) : ''} ${'دينار'.tr}",
                          ),
                        const Divider(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text("الكمية".tr, style: const TextStyle(fontSize: 16))),
                              Text("${product.productQuantity}${product.type == 2 ? "Kg" : ""}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (accountType == 2) ...[
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    controller.showStockLocationsDialog(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColor.backgroundcolor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16, color: AppColor.backgroundcolor),
                                        const SizedBox(width: 4),
                                        Text("أماكن التواجد".tr, style: const TextStyle(color: AppColor.backgroundcolor, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (product.itemsPerCarton != null && product.quantityPerCarton != null && product.itemsPerCarton.toString() != "0") ...[
                          _infoRow("الكمية في الكرتون".tr, product.itemsPerCarton.toString()),
                          _infoRow("عدد الكراتين المتبقية".tr, remainingCartons),
                        ],
                        _infoRow(
                          "الإجمالي بيع".tr,
                          "${formavalue(realTotalSale)}",
                        ),
                        _infoRow(
                          "الإجمالي شراء".tr,
                          "${formavalue(realTotalPurchase)}",
                        ),
                        const Divider(height: 30),
                        _infoRow(
                          "تاريخ الإضافة".tr,
                          product.createdAt?.substring(0, 10) ?? '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void showPrintPreview(BuildContext context, String name, String barcode,
      double price, controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("معاينة التذكرة", textAlign: TextAlign.center),
        content: RepaintBoundary(
          key: controller.ticketKey,
          child: buildPrintableTicket(name, barcode, price, false),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white, // خلفية بيضاء
              side: const BorderSide(
                  width: 2, color: AppColor.backgroundcolor), // إطار بنفسجي
            ),
            child: Text(
              "Cansel".tr,
              style: TextStyle(color: AppColor.backgroundcolor), // نص بنفسجي
            ),
          ),
          GetBuilder<Informationitemcontroller>(
            builder: (controller) => ElevatedButton(
              onPressed: controller.isPrinting
                  ? null
                  : () {
                      controller.printUniversalTicket(
                        name: name,
                        barcode: barcode,
                        price: price,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.backgroundcolor,
                foregroundColor: AppColor.white,
              ),
              child: controller.isPrinting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text("طباعة".tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPrintableTicket(
      String name, String barcode, double price, bool border) {
    return Container(
      width: 380,
      height: 115,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(border ? 15 : 0),
        border: border
            ? Border.all(color: AppColor.backgroundcolor, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Cairo'),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
          BarcodeWidget(
            barcode: Barcode.code128(),
            data: barcode,
            width: 180,
            height: 45,
            drawText: true,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Cairo',
              color: Colors.black,
            ),
          ),
          Text("${formavalue(price)} ${"DA".tr}",
              style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
