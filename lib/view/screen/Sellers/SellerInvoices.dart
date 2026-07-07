import 'package:Silaaty/controller/SellerInvoicesController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:Silaaty/view/widget/Bills/CustemCartinvoice.dart';
import 'package:Silaaty/view/widget/Bills/CustemTypeinvoice.dart';
import 'package:Silaaty/view/widget/Bills/Custemaddinvoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class SellerInvoices extends StatefulWidget {
  const SellerInvoices({super.key});

  @override
  State<SellerInvoices> createState() => _SellerInvoicesState();
}

class _SellerInvoicesState extends State<SellerInvoices> with RouteAware {
  SellerInvoicesController controller = Get.put(SellerInvoicesController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    controller.showInvoice();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellerInvoicesController>(builder: (controller) {
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
            controller.gotoNewSale();
          },
          backgroundColor: AppColor.backgroundcolor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColor.backgroundcolor,
                              AppColor.primarycolor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.backgroundcolor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.seller['name'] ?? 'بائع'.tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          controller.seller['email'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
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
                          setState(() {
                            controller.selectedIndex = 1;
                          });
                        },
                        activte: controller.selectedIndex == 1,
                        iconData: Icons.check_circle_outline,
                      ),
                      Custemtypeinvoices(
                        onPressed: () {
                          setState(() {
                            controller.selectedIndex = 2;
                          });
                        },
                        activte: controller.selectedIndex == 2,
                        iconData: Icons.warning_amber_rounded,
                      ),
                      Custemtypeinvoices(
                        onPressed: () {
                          setState(() {
                            controller.selectedIndex = 3;
                          });
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
              iconData: Icons.receipt_long,
              title: "لا يوجد فواتير".tr,
              widget: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: controller.invoice?.invoices?.where((inv) {
                        if (controller.selectedIndex == 1) return inv.isPaid;
                        if (controller.selectedIndex == 2) return !inv.isPaid;
                        return true;
                      }).length ??
                      0,
                  itemBuilder: (context, index) {
                    final filteredInvoices =
                        controller.invoice!.invoices!.where((inv) {
                      if (controller.selectedIndex == 1) return inv.isPaid;
                      if (controller.selectedIndex == 2) return !inv.isPaid;
                      return true;
                    }).toList();

                    final inv = filteredInvoices[index];
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 2)),
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
                        day: inv.date?.substring(8, 10) ?? "",
                        Mon: controller.getMonthAbbreviation(inv.date),
                        Title: "#${inv.number ?? ''}",
                        Status: inv.isPaid ? "Sincere".tr : 'Not Sincere'.tr,
                        Price:
                            "${(((double.parse(inv.invoiceSum.toString())) - (inv.paymentPrice ?? 0) - (inv.discount ?? 0)) < 0 ? 0 : (double.parse(inv.invoiceSum!.toString())) - (inv.paymentPrice ?? 0) - (inv.discount ?? 0)).toStringAsFixed(2)}",
                        onTap: () {
                          final selectedInvoiceData = InvoiceItem(
                            id: inv.id,
                            uuid: inv.uuid,
                            transactionuuId: inv.transactionuuId,
                            userId: inv.userId,
                            number: inv.number,
                            date: inv.date,
                            paymentDate: inv.paymentDate,
                            paymentPrice: inv.paymentPrice,
                            discount: inv.discount,
                            saleType: inv.saleType,
                            totalSales: inv.totalSales,
                            debt: inv.debt,
                            invoiceSum: inv.invoiceSum,
                            name: 'N/A',
                            familyName: 'N/A',
                            phoneNumber: 'N/A',
                          );

                          controller.gotoShowInvoice(selectedInvoiceData);
                        },
                        onDelete: () {
                          Get.defaultDialog(
                            backgroundColor: AppColor.white,
                            title: "Alert".tr,
                            titleStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.backgroundcolor),
                            middleText: "deleteInvoiceWarning".tr,
                            onConfirm: () {
                              controller.deleteInvoice(inv.uuid!);
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
      );
    });
  }
}
