import 'package:Silaaty/controller/Profaile/invoice/Shwoinvoicecontroller.dart';
import 'package:Silaaty/core/class/handlingviewShimmer.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Bills/CustemEditpayment.dart';
import 'package:Silaaty/view/widget/Bills/CustemStatusinvoice.dart';
import 'package:Silaaty/view/widget/Iformationitem/CustemBody.dart';
import 'package:Silaaty/view/widget/Zacat/CustemRow.dart';
import 'package:Silaaty/view/widget/Zacat/CustemRowProdact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/class/Statusrequest.dart';

class Shwoinvoice extends StatefulWidget {
  const Shwoinvoice({super.key});

  @override
  State<Shwoinvoice> createState() => _ShwoinvoiceState();
}

class _ShwoinvoiceState extends State<Shwoinvoice> {
  Shwoinvoicecontroller controller = Get.put(Shwoinvoicecontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Shwoinvoicecontroller>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'invoices'.tr,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColor.backgroundcolor,
                      fontSize: 24,
                    ),
              ),
              if (controller.statusrequest != Statusrequest.loadeng)
                InkWell(
                  onTap: () {
                    final catid = 4;
                    final invoiceId = controller.invoice?.invoice?.id;
                    if (invoiceId != null) {
                      controller.gotoAddProduct(
                          catid, controller.invoice!.invoice!.id!);
                    } else {
                      Get.snackbar("خطأ", "لم يتم تحميل الفاتورة بعد");
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundcolor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_box,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Add'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColor.white,
                                fontSize: 20,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Custembody(
                            body:
                                "Date of Add : ${controller.invoice?.invoice?.createdAt?.substring(0, 10) ?? ""}",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Custemstatusinvoice(
                        status: (int.tryParse(controller.invoice?.sumPrice
                                            ?.toString() ??
                                        '0') ??
                                    0) <=
                                (int.tryParse(controller
                                            .invoice?.invoice?.paymentPrice
                                            ?.toString() ??
                                        '0') ??
                                    0)
                            ? "paid"
                            : "unpaid",
                      ),
                      const SizedBox(height: 10),
                      Custembody(
                        body:
                            "Payment Date : ${controller.invoice?.invoice?.invoiesPaymentDate ?? ""}",
                      ),
                      const SizedBox(height: 20),
                      Custemrowprodact(
                        title: "Product".tr,
                        price: "Price".tr,
                        fontSize: 17,
                        color: AppColor.backgroundcolor,
                        colorp: AppColor.backgroundcolor,
                        q: "Quantity".tr,
                        value: "Value".tr,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        color: Colors.grey[400],
                        height: 1,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 300,
                        child: HandlingviewShimmer(
                            statusrequest: controller.statusrequest,
                            widget: ListView.builder(
                              itemCount: controller.invoice?.product?.length,
                              itemBuilder: (Context, index) {
                                final pro = controller.invoice?.product?[index];
                                return Custemrowprodact(
                                  onTap: () {
                                    controller.GotoEdititem(pro!.id!);
                                  },
                                  onLongPress: () {
                                    Get.defaultDialog(
                                      backgroundColor: AppColor.white,
                                      title: "Alert".tr,
                                      titleStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.backgroundcolor),
                                      middleText: "هل تريد حذف المنتج؟".tr,
                                      onConfirm: () {
                                        controller.deleteProdact(pro!.id!);
                                        Get.back();
                                      },
                                      onCancel: () {},
                                      buttonColor: AppColor.backgroundcolor,
                                      confirmTextColor: AppColor.primarycolor,
                                      cancelTextColor: AppColor.backgroundcolor,
                                    );
                                  },
                                  title: pro?.productName ?? "",
                                  price: pro?.productPrice ?? "",
                                  fontSize: 17,
                                  color: AppColor.grey,
                                  colorp: AppColor.grey,
                                  da: "DA".tr,
                                  q: pro?.productQuantity ?? "",
                                  value: pro?.productPriceTotal ?? "",
                                );
                              },
                            )),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        color: Colors.grey[400],
                        height: 1,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 15),
                      Custemrow(
                        Title: "Total".tr,
                        Prise:
                            controller.invoice?.sumPrice?.toString() ?? "0.00",
                        DA: "DA".tr,
                        fontSize: 24,
                        color: AppColor.grey,
                        colorp: AppColor.grey,
                      ),
                      const SizedBox(height: 10),
                      Custemrow(
                        Title: "Paid-for".tr,
                        Prise: controller.invoice?.invoice?.paymentPrice
                                ?.toString() ??
                            "0.00",
                        DA: "DA".tr,
                        fontSize: 24,
                        color: Colors.green[800]!,
                        colorp: Colors.green[800]!,
                        onDoubleTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => CustemEditInvoiceDialog(
                                    title: "Edit invoices".tr,
                                    onPressed: () {
                                      // final value =
                                      //     controller.paymentPrice.text.trim();

                                      // if (value.isEmpty) {
                                      //   Get.snackbar("Error".tr,
                                      //       "Please enter the amount paid".tr,
                                      //       backgroundColor: Colors.red,
                                      //       colorText: Colors.white);
                                      //   return;
                                      // }

                                      // final amount = double.tryParse(value);
                                      // if (amount == null || amount < 0) {
                                      //   Get.snackbar("Error".tr,
                                      //       "Enter the Correct amount".tr,
                                      //       backgroundColor: Colors.red,
                                      //       colorText: Colors.white);
                                      //   return;
                                      // }

                                      // final total = double.tryParse(controller
                                      //             .invoice?.sumPrice
                                      //             ?.toString() ??
                                      //         '0') ??
                                      //     0;
                                      // final paid = double.tryParse(controller
                                      //             .invoice
                                      //             ?.invoice
                                      //             ?.paymentPrice
                                      //             ?.toString() ??
                                      //         '0') ??
                                      //     0;
                                      // final remaining = total - paid;

                                      // if (amount > remaining) {
                                      //   Get.snackbar(
                                      //       "Error".tr,
                                      //       "Th amount paid is greater than the remaining amount"
                                      //           .tr,
                                      //       backgroundColor: Colors.red,
                                      //       colorText: Colors.white);
                                      //   return;
                                      // }

                                      controller.Editinvoise(
                                          controller.invoice!.invoice!.id!);
                                    },
                                    onback: () {
                                      Get.back();
                                    },
                                    Mycontroller: controller.paymentPrice,
                                    form: controller.formstate,
                                  ));
                        },
                      ),
                      const SizedBox(height: 5),
                      Custemrow(
                        Title: "Remaining".tr,
                        Prise:
                            controller.getRemainingAmount().toStringAsFixed(2),
                        DA: "DA".tr,
                        fontSize: 24,
                        color: Colors.red[800]!,
                        colorp: Colors.red[800]!,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
