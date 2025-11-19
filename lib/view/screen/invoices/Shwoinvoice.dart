import 'package:Silaaty/controller/Profaile/invoice/ShwoinvoiCecontroller.dart';
import 'package:Silaaty/view/widget/Bills/CustemEditpayment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingviewShimmer.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../../widget/Bills/CostumCartdetails.dart';
import '../../widget/Bills/CostumCartdetailsPayment.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Home/CustemTitle.dart';
import '../../widget/Home/CustemcartAbbreviation.dart';
import '../../widget/Zacat/CustemRowProdact.dart';
import '../../widget/sale/CostumDealogEditProduct.dart';

class Shwoinvoice extends StatefulWidget {
  const Shwoinvoice({super.key});

  @override
  State<Shwoinvoice> createState() => _PaymentState();
}

class _PaymentState extends State<Shwoinvoice> {
  final controller = Get.put(Shwoinvoicecontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Shwoinvoicecontroller>(builder: (_) {
      return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(left: 20),
            //     child: IconButton(
            //       onPressed: () {
            //         controller.gotoaddproductNewSale();
            //       },
            //       icon: const Icon(
            //         Icons.add,
            //         size: 30,
            //       ),
            //     ),
            //   ),
            // ],
            title: Text('#${controller.invoices!.number}'.tr,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
            backgroundColor: AppColor.white,
            iconTheme: const IconThemeData(
              color: AppColor.backgroundcolor,
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 40),
            child: ListView(
              children: [
                Costumtitlepayment(
                  iconData: Icons.person_outline,
                  title: "معلومات العميل".tr,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: controller.getRemainingAmount() == 0
                          ? const Color.fromARGB(94, 151, 215, 153)
                          : const Color.fromARGB(94, 246, 157, 150),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(
                        controller.getRemainingAmount() == 0
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        color: controller.getRemainingAmount() == 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(controller.getRemainingAmount() == 0
                          ? "مدفوع".tr
                          : "غير مدفوع".tr),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Costumcartdetails(
                  iconData: Icons.person_2_outlined,
                  title: "العميل".tr,
                  body: controller.invoices?.familyName == null
                      ? "virtualCustomer".tr
                      : "${controller.invoices?.familyName} ${controller.invoices?.name}",
                ),
                Costumcartdetails(
                  iconData: Icons.date_range,
                  title: "التاريخ".tr,
                  body: controller.invoices!.date.toString().substring(0, 10),
                ),
                Container(
                  height: 50,
                ),
                Costumtitlepayment(
                  iconData: Icons.receipt_long,
                  title: "تفاصيل الطلب".tr,
                ),

                const SizedBox(height: 15),
                SizedBox(
                  height: 250,
                  child: HandlingviewShimmer(
                      statusrequest: controller.statusrequest,
                      widget: ListView.builder(
                        itemCount: controller.productSale?.products.length,
                        itemBuilder: (Context, index) {
                          final pro = controller.productSale?.products[index];
                          return Custemrowprodact(
                            onTap: () {
                              controller.qtyController.text =
                                  pro.quantity.toString();
                              Get.dialog(
                                CustemQuantityDialog(
                                  controller: controller.qtyController,
                                  title: "تعديل الكمية",
                                  onCancel: () => Get.back(),
                                  onConfirm: () {
                                    if (!validInputsnak(
                                        controller.qtyController.text,
                                        1,
                                        20,
                                        "Name".tr)) {
                                      return;
                                    }
                                    controller.editProduct(
                                        pro.uuid, pro.quantity);
                                  },
                                ),
                              );
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
                                  controller.deleteProduct(pro.uuid);
                                },
                                onCancel: () {},
                                buttonColor: AppColor.backgroundcolor,
                                confirmTextColor: AppColor.primarycolor,
                                cancelTextColor: AppColor.backgroundcolor,
                              );
                            },
                            title: pro?.productName ?? "",
                            price: pro?.unitPrice.toString() ?? "",
                            fontSize: 17,
                            color: AppColor.grey,
                            colorp: AppColor.grey,
                            da: "DA".tr,
                            q: pro!.quantity.toString(),
                            value: pro.subtotal.toString(),
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
                // Costumtextfildpatment(
                //   MyController: controller.paymentController,
                //   hintText: "Payment",
                //   label: "Payment",
                //   iconData: Icons.payment_outlined,
                //   valid: (Val) {
                //     return validInput(Val!, 100, 5, "Email");
                //   },
                //   keyboardType: TextInputType.number,
                // ),
                // Costumtextfildpatment(
                //   onTap: () {
                //     controller.update();
                //   },
                //   MyController: controller.discountController,
                //   hintText: "Discount",
                //   label: "Payment",
                //   iconData: Icons.discount_outlined,
                //   valid: (Val) {
                //     return validInput(Val!, 100, 5, "Email");
                //   },
                //   keyboardType: TextInputType.number,
                // ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Costumcartdetailspayment(
                        title: "المجموع الفرعي".tr,
                        body: controller.productSale == null
                            ? ""
                            : controller.productSale!.sumPrice.toString(),
                      ),
                      Costumcartdetailspayment(
                        title: "الخصم".tr,
                        body: controller.productSale?.discount.toString() ?? "",
                      ),
                      Costumcartdetailspayment(
                        title: "Paid".tr,
                        body: controller.productSale?.paymentprice.toString() ??
                            "",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("الإجمالي".tr,
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            controller.getRemainingAmount().toString(),
                            style: TextStyle(
                                color: AppColor.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Custemtitle(title: "الإدارة والتحكم".tr),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Custemcartabbreviation(
                        width: Get.width / 4,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustemEditInvoiceDialog(
                                    lableText: "المبلغ المدفوع".tr,
                                    Mycontroller: controller.paymentPrice,
                                    onPressed: () {
                                      controller.Editinvoise(controller.uuid!);
                                    },
                                    onback: () {
                                      Get.back();
                                    },
                                    title: "دفع مستحقات الفاتورة".tr);
                              });
                        },
                        iconData: Icons.payment,
                        title: "الدفع".tr,
                      ),
                      const SizedBox(width: 15),
                      Custemcartabbreviation(
                        width: Get.width / 4,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustemEditInvoiceDialog(
                                    lableText: "Discount".tr,
                                    Mycontroller: controller.discount,
                                    onPressed: () {
                                      controller.Editdiscount(controller.uuid!);
                                    },
                                    onback: () {
                                      Get.back();
                                    },
                                    title: "Edit Discount".tr);
                              });
                        },
                        iconData: Icons.discount,
                        title: "Discount".tr,
                      ),
                      const SizedBox(width: 15),
                      Custemcartabbreviation(
                        width: Get.width / 4,
                        onTap: () {
                          controller.printInvoiceBluetooth();
                        },
                        iconData: Icons.print_outlined,
                        title: "طباعة".tr,
                      ),
                      const SizedBox(width: 15),
                      Custemcartabbreviation(
                        width: Get.width / 4,
                        onTap: () {
                          controller.generateArabicPdf();
                        },
                        iconData: Icons.picture_as_pdf,
                        title: "عرض PDF".tr,
                      ),
                      const SizedBox(width: 15),
                      Custemcartabbreviation(
                        height: 50,
                        width: Get.width / 4,
                        onTap: () {
                          Get.defaultDialog(
                            backgroundColor: AppColor.white,
                            title: "Alert".tr,
                            titleStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.backgroundcolor,
                            ),
                            middleText: "deleteInvoiceWarning".tr,
                            onConfirm: () {
                              controller.deleteInvoice(controller.uuid!);
                            },
                            onCancel: () {},
                            buttonColor: AppColor.backgroundcolor,
                            confirmTextColor: AppColor.primarycolor,
                            cancelTextColor: AppColor.backgroundcolor,
                          );
                        },
                        iconData: Icons.delete_sharp,
                        title: "حذف".tr,
                      ),
                    ],
                  ),
                ),

                // Custembutton(
                //   text: "Add".tr,
                //   onPressed: () {
                //     if (!validInputsnak(
                //         controller.paymentController.text, 1, 20, "Name".tr)) {
                //       return;
                //     }

                //     controller.addSale();
                //   },
                //   vertical: 30,
                //   horizontal: 10,
                //   paddingvertical: 10,
                // )
              ],
            ),
          ));
    });
  }
}
