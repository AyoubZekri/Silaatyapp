import 'dart:io';

import 'package:Silaaty/controller/items/informationItemController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/view/widget/Iformationitem/iconButton.dart';
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
        title: Text('تفاصيل المنتج'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: GetBuilder<Informationitemcontroller>(builder: (_) {
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
                    borderRadius: BorderRadius.circular(16)),
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
                          )),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                color: AppColor.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
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
                                  color: AppColor.backgroundcolor),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Iconbutton(
                              iconData: Icons.print,
                              onTap: () async {
                                await controller.printProductTicket(
                                    name: product.productName.toString(),
                                    barcode: product.codepar.toString(),
                                    price: product.productPrice ?? 0);
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          Iconbutton(
                              iconData: Icons.edit,
                              onTap: () async {
                                await controller.GotoEdititem();
                                controller.getProdact();
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          Iconbutton(
                              iconData: Icons.playlist_add,
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Customaddquntetyproductdialog(
                                        Mycontroller:
                                            controller.quantityController,
                                        value: int.tryParse(controller
                                                .quantityController.text) ??
                                            1,
                                        onPressed: () {
                                          controller.editquantityProduct();
                                        },
                                        onback: () {
                                          Get.back();
                                        },
                                        title: 'إضافة كمية جديدة'.tr,
                                        onChanged: (int p1) {
                                          controller.onQuantityChanged(p1);
                                        },
                                      );
                                    });
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          Iconbutton(
                              iconData: Icons.delete,
                              onTap: () {
                                Get.defaultDialog(
                                  backgroundColor: AppColor.white,
                                  title: "Alert".tr,
                                  titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.backgroundcolor),
                                  middleText: "هل تريد حذف المنتج؟".tr,
                                  onConfirm: () {
                                    controller.deleteProdact(product.uuid!);
                                    Get.back(result: true);
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                  buttonColor: AppColor.backgroundcolor,
                                  confirmTextColor: AppColor.primarycolor,
                                  cancelTextColor: AppColor.backgroundcolor,
                                );
                              }),
                        ],
                      ),
                      const Divider(height: 30),
                      _infoRow("سعر البيع".tr,
                          "${product.productPrice ?? "0.00"} ${'دينار'.tr}"),
                      _infoRow("سعر الشراء".tr,
                          "${product.productPricePurchase ?? "0.00"} ${'دينار'.tr}"),
                      _infoRow("الكمية".tr, "${product.productQuantity}"),
                      _infoRow(
                          "الإجمالي بيع".tr, "${product.productPriceTotal}"),
                      _infoRow("الإجمالي شراء".tr,
                          "${product.productPriceTotalPurchase}"),
                      _infoRow("تاريخ الإضافة".tr,
                          product.createdAt?.substring(0, 10) ?? ''),
                      _infoRow("Barcode".tr, product.codepar.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
}
