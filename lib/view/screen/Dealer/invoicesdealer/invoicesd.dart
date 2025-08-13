import 'package:Silaaty/controller/Profaile/invoice/InvoiceController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Bills/CustemCartinvoice.dart';
import 'package:Silaaty/view/widget/Bills/CustemTypeinvoice.dart';
import 'package:Silaaty/view/widget/Bills/Custemaddinvoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/class/handlingview.dart';

class Invoicesd extends StatefulWidget {
  const Invoicesd({super.key});

  @override
  State<Invoicesd> createState() => _InvoicesdState();
}

class _InvoicesdState extends State<Invoicesd> {
  InvoicesController controller = Get.put(InvoicesController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoicesController>(builder: (controller) {
      return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            iconTheme: const IconThemeData(
              color: AppColor.backgroundcolor,
            ),
            title: Text(
              'invoices'.tr,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColor.backgroundcolor,
                    fontSize: 24,
                  ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => CustemInvoiceDialog(
                        title: "Add".tr,
                        onPressed: () {
                          controller.addInvoice();
                        },
                        onback: () {
                          Get.back();
                        },
                        Mycontroller: controller.dateController,
                        form: controller.formstate,
                      ));
            },
            backgroundColor: AppColor.backgroundcolor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: SingleChildScrollView(
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(180),
                                border: Border.all(
                                    width: 0.4, color: AppColor.grey),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 70,
                                color: AppColor.backgroundcolor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.invoice?.transaction?.name ?? ''} ${controller.invoice?.transaction?.familyName ?? ''}",
                                  style: const TextStyle(
                                      fontSize: 18, color: AppColor.black),
                                ),
                                Text(
                                  controller
                                          .invoice?.transaction?.phoneNumber ??
                                      '',
                                  style: const TextStyle(
                                      fontSize: 16, color: AppColor.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (controller.invoice != null)
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // ignore: deprecated_member_use
                              color: AppColor.backgroundcolor.withOpacity(0.1),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: AppColor.backgroundcolor,
                                size: 24,
                              ),
                              onPressed: () async {
                                final Uri phoneUri = Uri(
                                    scheme: 'tel',
                                    path: controller
                                        .invoice?.transaction?.phoneNumber!);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  Get.snackbar("Error".tr,
                                      "No connection can be made".tr);
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " Account details:".tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Price Total".tr,
                                  style: TextStyle(color: Colors.grey[700])),
                              Text(
                                "${controller.invoice?.sumPrice ?? 0},00 DA",
                                style: const TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Paid-for".tr,
                                  style: TextStyle(color: Colors.grey[700])),
                              Text(
                                "${controller.invoice?.sumpaymentPrice ?? 0},00 DA",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("The rest".tr,
                                  style: TextStyle(color: Colors.grey[700])),
                              Text(
                                "${controller.getRemainingAmount()} DA",
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Wrap(
                        runSpacing: 10,
                        children: [
                          Custemtypeinvoices(
                            onPressed: () {
                              controller.changeSelectedIndex(1);
                            },
                            activte: controller.selectedIndex == 1,
                            iconData: Icons.check_circle_outline,
                          ),
                          Custemtypeinvoices(
                            onPressed: () {
                              controller.changeSelectedIndex(2);
                            },
                            activte: controller.selectedIndex == 2,
                            iconData: Icons.warning_amber_rounded,
                          ),
                          Custemtypeinvoices(
                            onPressed: () {
                              controller.changeSelectedIndex(3);
                            },
                            activte: controller.selectedIndex == 3,
                            iconData: Icons.all_inclusive,
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Handlingview(
                  statusrequest: controller.statusrequest,
                  widget: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.invoice?.invoices?.where((inv) {
                            final isPaid =
                                double.parse(inv.invoicesum!.toString()) <=
                                    double.parse(inv.paymentPrice!.toString());
                            if (controller.selectedIndex == 1) return isPaid;
                            if (controller.selectedIndex == 2) return !isPaid;
                            return true;
                          }).length ??
                          0,
                      itemBuilder: (context, index) {
                        final filteredInvoices =
                            controller.invoice!.invoices!.where((inv) {
                          final isPaid =
                              double.parse(inv.invoicesum!.toString()) <=
                                  double.parse(inv.paymentPrice!.toString());
                          if (controller.selectedIndex == 1) return isPaid;
                          if (controller.selectedIndex == 2) return !isPaid;
                          return true;
                        }).toList();

                        final inv = filteredInvoices[index];
                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 300 + (index * 200)),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(50 * (1 - value), 0),
                                child: child,
                              ),
                            );
                          },
                          child: Custemcartinvoice(
                            day: inv.invoiesDate?.substring(8, 10) ?? "",
                            Mon: controller
                                .getMonthAbbreviation(inv.invoiesDate),
                            Title: inv.invoiesNumper ?? "",
                            Status: double.parse(inv.invoicesum!.toString()) <=
                                    inv.paymentPrice!
                                ? "Sincere".tr
                                : 'Not Sincere'.tr,
                            Price:
                                "${((double.parse(inv.invoicesum.toString())) - (inv.paymentPrice ?? 0)) < 0 ? 0 : (double.parse(inv.invoicesum.toString())) - (inv.paymentPrice ?? 0)}",
                            onTap: () {
                              controller.gotoShowInvoiceDealer(inv.id!);
                            },
                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustemInvoiceDialog(
                                  title: "Edit invoices".tr,
                                  onPressed: () {
                                    controller.EditInvoice(inv.id!);
                                  },
                                  onback: () {
                                    Get.back();
                                  },
                                  Mycontroller: controller.dateController,
                                  form: controller.formstate,
                                ),
                              );
                            },
                            onDelete: () {
                              Get.defaultDialog(
                                backgroundColor: AppColor.white,
                                title: "Alert".tr,
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.backgroundcolor),
                                middleText:
                                    "Do you want to delete the invoice?".tr,
                                onConfirm: () {
                                  controller.deleteInvoice(inv.id!);
                                },
                                onCancel: () {},
                                buttonColor: AppColor.backgroundcolor,
                                confirmTextColor: AppColor.primarycolor,
                                cancelTextColor: AppColor.backgroundcolor,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}
