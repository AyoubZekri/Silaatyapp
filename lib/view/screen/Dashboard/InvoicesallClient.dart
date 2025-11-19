import 'package:Silaaty/core/class/handlingview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/Dashpord/invoicesallcontroller.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../main.dart';
import '../../widget/Bills/custemcartallInvoices.dart';
import '../../widget/Home/Custemstatus.dart';
import '../../widget/Home/custemSearch.dart';

class Invoicesall extends StatefulWidget {
  const Invoicesall({super.key});

  @override
  State<Invoicesall> createState() => _InvoicesallState();
}

class _InvoicesallState extends State<Invoicesall> with RouteAware {
  late Invoicesallcontroller controller;

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
    super.didPopNext();
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        controller.showInvoice();
        controller.update();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<Invoicesallcontroller>()) {
      Get.delete<Invoicesallcontroller>();
    }
    controller = Get.put(Invoicesallcontroller());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'Invoices'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () {
                controller.gotoSaleNew();
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: Container(child: GetBuilder<Invoicesallcontroller>(builder: (_) {
        return Column(
          children: [
            Custemsearch(
              Search: "Search".tr,
              onChanged: (text) {
                setState(() {
                  controller.searchInvoices(text);
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Custemstatus(
                    onPressed: () {
                      setState(() {
                        controller.selectedIndex = 1;
                      });
                    },
                    NameItems: "الكل".tr,
                    isActive: controller.selectedIndex == 1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Custemstatus(
                    onPressed: () {
                      setState(() {
                        controller.selectedIndex = 2;
                      });
                    },
                    NameItems: "تم دفع".tr,
                    isActive: controller.selectedIndex == 2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Custemstatus(
                    onPressed: () {
                      setState(() {
                        controller.selectedIndex = 3;
                      });
                    },
                    NameItems: "بانتضار دفع".tr,
                    isActive: controller.selectedIndex == 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: Get.height - 255,
              child: Builder(
                builder: (context) {
                  final filteredInvoices =
                      controller.filteredInvoices.where((inv) {
                    final debt = (inv.debt ?? 0).toDouble();
                    final isPaid = debt <= 0;
                    print("============================$debt");
                    if (controller.selectedIndex == 1) return true;
                    if (controller.selectedIndex == 2) return isPaid;
                    return !isPaid;
                  }).toList();

                  return Handlingview(
                      statusrequest: controller.statusrequest,
                      iconData: Icons.receipt_long,
                      title: "لم تتم إضافة فواتير".tr,
                      widget: ListView.builder(
                        itemCount: filteredInvoices.length,
                        itemBuilder: (context, index) {
                          final inv = filteredInvoices[index];
                          return Custemcartallinvoice(
                            nameclient: inv.name == null
                                ? "virtualCustomer".tr
                                : '${inv.name} ${inv.familyName}',
                            day: inv.date!.substring(8, 10),
                            Mon: controller.getMonthAbbreviation(inv.date),
                            Title: "#${inv.number ?? ''}",
                            Status:
                                inv.debt == 0 ? "Sincere".tr : "Not Sincere".tr,
                            Price: "${inv.debt}",
                            onTap: () {
                              controller
                                  .gotoShowInvoice(controller.invoices[index]);
                            },
                            onDelete: () {
                              Get.defaultDialog(
                                backgroundColor: AppColor.white,
                                title: "Alert".tr,
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.backgroundcolor,
                                ),
                                middleText:
                                    "Do you want to delete the invoice?".tr,
                                onConfirm: () {
                                  controller.invoices.removeWhere(
                                    (element) => element.uuid == inv.uuid,
                                  );
                                  Get.back();
                                  controller.update();
                                  controller.deleteInvoice(inv.uuid!);
                                },
                                onCancel: () {
                                  Get.back();
                                },
                                buttonColor: AppColor.backgroundcolor,
                                confirmTextColor: AppColor.primarycolor,
                                cancelTextColor: AppColor.backgroundcolor,
                              );
                            },
                          );
                        },
                      ));
                },
              ),
            ),
          ],
        );
      })),
    );
  }
}
