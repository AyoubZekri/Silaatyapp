import 'dart:io';

import 'package:Silaaty/controller/items/informationItemController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/view/widget/Iformationitem/iconButton.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';
import '../../widget/addItem/CustomAddquntetyproductdialog.dart';

class Informationitem extends StatefulWidget {
  const Informationitem({super.key});

  @override
  State<Informationitem> createState() => _InformationitemState();
}

class _InformationitemState extends State<Informationitem> {
  @override
  Widget build(BuildContext context) {
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

          return HandlingviewAuth(
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
                                    return Customaddquntetyproductdialog(
                                      isDecimal:
                                          controller.InfoProduct.first.type ==
                                              2,
                                      Mycontroller:
                                          controller.quantityController,
                                      value: double.tryParse(
                                            controller.quantityController.text,
                                          ) ??
                                          1,
                                      onPressed: () {
                                        controller.editquantityProduct();
                                      },
                                      onback: () {
                                        Get.back();
                                      },
                                      title: 'إضافة كمية جديدة'.tr,
                                      onChanged: (double p1) {
                                        controller.onQuantityChanged(p1);
                                      },
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
                        _infoRow(
                          "سعر البيع".tr,
                          "${product.productPrice!.toStringAsFixed(2)} ${'دينار'.tr}",
                        ),
                        _infoRow(
                          "سعر الشراء".tr,
                          "${product.productPricePurchase!.toStringAsFixed(2)} ${'دينار'.tr}",
                        ),
                        _infoRow("الكمية".tr,
                            "${product.productQuantity}${product.type == 2 ? "Kg" : ""}"),
                        _infoRow(
                          "الإجمالي بيع".tr,
                          "${product.productPriceTotal!.toStringAsFixed(2)}",
                        ),
                        _infoRow(
                          "الإجمالي شراء".tr,
                          "${product.productPriceTotalPurchase!.toStringAsFixed(2)}",
                        ),
                        _infoRow(
                          "تاريخ الإضافة".tr,
                          product.createdAt?.substring(0, 10) ?? '',
                        ),
                        _infoRow("Barcode".tr, product.codepar.toString()),
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
      padding: EdgeInsets.symmetric(horizontal: 20),
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
                  color: Colors.black),
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
          ),
          Text("${price.toStringAsFixed(2)} ${"DA".tr}",
              style: const TextStyle(fontSize: 20, color: Colors.black)),
        ],
      ),
    );
  }
}
