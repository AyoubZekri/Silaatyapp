import 'package:Silaaty/controller/Profaile/invoice/InvoiceController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:Silaaty/view/widget/Bills/CustemCartinvoice.dart';
import 'package:Silaaty/view/widget/Bills/CustemTypeinvoice.dart';
import 'package:Silaaty/view/widget/Bills/Custemaddinvoice.dart';
import 'package:Silaaty/view/widget/Bills/CustemEditpayment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> with RouteAware {
  InvoicesController controller = Get.put(InvoicesController());

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

  Widget _buildStatCard(String title, String amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  "DA".tr,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoicesController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.white,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
          title: Text(
            'invoices'.tr,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColor.backgroundcolor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.gotoNewSale();
          },
          backgroundColor: AppColor.backgroundcolor,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          color: AppColor.backgroundcolor,
          child: Column(
            children: [
              // --- Header Profile Card ---
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.backgroundcolor.withOpacity(0.1),
                            border: Border.all(
                                width: 2,
                                color:
                                    AppColor.backgroundcolor.withOpacity(0.3)),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: AppColor.backgroundcolor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Main Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.invoice?.transaction?.name ?? ''} ${controller.invoice?.transaction?.familyName ?? ''}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.invoice?.transaction?.transactions ==
                                        2
                                    ? "Account_clint".tr
                                    : "Account_Supplier".tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColor.backgroundcolor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Sale Type Chip
                              if (controller.invoice?.transaction
                                          ?.customerSaleType !=
                                      null &&
                                  controller.invoice!.transaction!
                                      .customerSaleType!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    controller.invoice!.transaction!
                                                .customerSaleType ==
                                            "1"
                                        ? "نوع البيع: تجزئة".tr
                                        : controller.invoice!.transaction!
                                                    .customerSaleType ==
                                                "2"
                                            ? "نوع البيع: نصف جملة".tr
                                            : "نوع البيع: جملة".tr,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Actions
                        Column(
                          children: [
                            if (controller.invoice != null &&
                                controller.invoice?.transaction?.transactions ==
                                    2)
                              InkWell(
                                onTap: () {
                                  controller.switchtransactions(
                                      controller.invoice!.transaction!.id!);
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller
                                                .invoice?.transaction?.status ==
                                            1
                                        ? Colors.red.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    controller.invoice?.transaction?.status == 1
                                        ? Icons.warning_amber_rounded
                                        : Icons.check_circle_outline,
                                    color: controller
                                                .invoice?.transaction?.status ==
                                            1
                                        ? Colors.red
                                        : Colors.green,
                                    size: 22,
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () async {
                                final Uri phoneUri = Uri(
                                  scheme: 'tel',
                                  path: controller
                                          .invoice?.transaction?.phoneNumber ??
                                      '',
                                );
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  Get.snackbar("Error".tr,
                                      "No connection can be made".tr);
                                }
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppColor.backgroundcolor.withOpacity(0.1),
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: AppColor.backgroundcolor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    // Extra Details
                    if (controller.invoice?.transaction?.phoneNumber != null &&
                        controller
                            .invoice!.transaction!.phoneNumber!.isNotEmpty)
                      _buildInfoRow(Icons.phone_outlined,
                          controller.invoice!.transaction!.phoneNumber!),
                    if (controller.invoice?.transaction?.address != null &&
                        controller.invoice!.transaction!.address!.isNotEmpty)
                      _buildInfoRow(Icons.location_on_outlined,
                          controller.invoice!.transaction!.address!),
                    if (controller.invoice?.transaction?.supplierProducts !=
                            null &&
                        controller
                            .invoice!.transaction!.supplierProducts!.isNotEmpty)
                      _buildInfoRow(Icons.inventory_2_outlined,
                          "${'يبيع:'.tr} ${controller.invoice!.transaction!.supplierProducts}"),
                    if (controller.invoice?.transaction?.notes != null &&
                        controller.invoice!.transaction!.notes!.isNotEmpty)
                      _buildInfoRow(Icons.note_alt_outlined,
                          "${'ملاحظات:'.tr} ${controller.invoice!.transaction!.notes}"),
                  ],
                ),
              ),

              // --- Stats Row ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard("Price Total".tr,
                        "${controller.invoice?.sumPrice ?? 0}", Colors.blue),
                    const SizedBox(width: 8),
                    _buildStatCard(
                        "Paid-for".tr,
                        "${controller.invoice?.sumPaymentPrice ?? 0}",
                        Colors.green),
                    const SizedBox(width: 8),
                    _buildStatCard("The rest".tr,
                        "${controller.getRemainingAmount()}", Colors.redAccent),
                  ],
                ),
              ),

              if (double.tryParse(controller.getRemainingAmount().replaceAll(',', '')) != null && 
                  double.parse(controller.getRemainingAmount().replaceAll(',', '')) > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.oldDebtPaymentController.text = controller.getRemainingAmount();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustemEditInvoiceDialog(
                                lableText: "المبلغ المدفوع".tr,
                                Mycontroller: controller.oldDebtPaymentController,
                                onPressed: () {
                                  controller.payOldDebts();
                                },
                                onback: () {
                                  Get.back();
                                },
                                title: "تسديد الديون دفعة واحدة".tr);
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    icon: const Icon(Icons.payment, color: Colors.white),
                    label: Text("تسديد الديون دفعة واحدة".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

              // --- Filters ---
              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
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
              ),
              const Divider(height: 1),

              // --- List View ---
              Expanded(
                child: Handlingview(
                  statusrequest: controller.statusrequest,
                  iconData: Icons.receipt_long,
                  title: "لا يوجد فواتير".tr,
                  widget: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
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
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Custemcartinvoice(
                          day: inv.date?.substring(8, 10) ?? "",
                          Mon: controller.getMonthAbbreviation(inv.date),
                          Title: "#${inv.number ?? ''}",
                          Status: inv.isPaid ? "Sincere".tr : 'Not Sincere'.tr,
                          Price: formavalue((((double.tryParse(
                                              inv.invoiceSum.toString()) ??
                                          0) -
                                      (inv.paymentPrice ?? 0) -
                                      (inv.discount ?? 0)) <
                                  0
                              ? 0
                              : (double.tryParse(inv.invoiceSum.toString()) ??
                                      0) -
                                  (inv.paymentPrice ?? 0) -
                                  (inv.discount ?? 0))),
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
                              totalSales: inv.totalSales,
                              debt: inv.debt,
                              invoiceSum: inv.invoiceSum,
                              name: controller.invoice!.transaction!.name,
                              familyName:
                                  controller.invoice!.transaction!.familyName,
                              phoneNumber:
                                  controller.invoice!.transaction!.phoneNumber,
                            );

                            controller.gotoShowInvoice(selectedInvoiceData);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
