import 'package:Silaaty/view/widget/Statistics/CustemFilterDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/Statistice/StatisticeReportesController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/DialogDate.dart';
import '../../widget/Setteng/custemCartButton.dart';

class SellerReports extends StatefulWidget {
  const SellerReports({super.key});

  @override
  State<SellerReports> createState() => _SellerReportsState();
}

class _SellerReportsState extends State<SellerReports> {
  @override
  Widget build(BuildContext context) {
    Statisticereportescontroller controller =
        Get.put(Statisticereportescontroller());
    final seller = Get.arguments ?? {};
    final sellerId = seller['id'];
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'تقارير البائع'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: GetBuilder<Statisticereportescontroller>(builder: (_) {
        return ListView(children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("تقارير مالية".tr),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                  ),
                  child: Column(
                    children: [
                      Custemcartbutton(
                        Title: "نضرة مالية عامة".tr,
                        iconData: Icons.description_outlined,
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Custemfilterdialog<String>(
                                      onConfirm: () {
                                        Get.back();
                                        controller.gotoPublicFinance(
                                            sellerId: sellerId);
                                      },
                                      onCancel: () {
                                        controller.filterController = null;
                                        Get.back();
                                      },
                                      title: 'إختر النطاق'.tr,
                                      hintText: 'النطاق'.tr,
                                      value: controller.filterController,
                                      items: controller.ranges.entries.map((e) {
                                        return DropdownMenuItem<String>(
                                          value: e.key,
                                          child: Text(e.value),
                                        );
                                      }).toList(),
                                      onChanged: (value) async {
                                        setStateDialog(() {
                                          controller.filterController =
                                              value.toString();
                                        });

                                        if (value == "custom") {
                                          final result =
                                              await showCustomRangePicker(
                                                  context);

                                          if (result != null) {
                                            controller.customStartDate =
                                                result["start"]!;
                                            controller.customEndDate =
                                                result["end"]!;
                                            controller.update();
                                          } else {
                                            controller.filterController = "";
                                          }
                                        }
                                      });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Text("تقارير العملاء".tr),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                  ),
                  child: Column(
                    children: [
                      Custemcartbutton(
                        Title: 'تقارير مبيعات العملاء'.tr,
                        iconData: Icons.description_outlined,
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Custemfilterdialog<String>(
                                      onConfirm: () {
                                        Get.back();
                                        controller.gotoCustomerSales(
                                            sellerId: sellerId);
                                      },
                                      onCancel: () {
                                        controller.filterController = null;

                                        Get.back();
                                      },
                                      title: 'إختر النطاق'.tr,
                                      hintText: 'النطاق'.tr,
                                      value: controller.filterController,
                                      items: controller.ranges.entries.map((e) {
                                        return DropdownMenuItem<String>(
                                          value: e.key,
                                          child: Text(e.value),
                                        );
                                      }).toList(),
                                      onChanged: (value) async {
                                        setStateDialog(() {
                                          controller.filterController =
                                              value.toString();
                                        });

                                        if (value == "custom") {
                                          final result =
                                              await showCustomRangePicker(
                                                  context);

                                          if (result != null) {
                                            controller.customStartDate =
                                                result["start"]!;
                                            controller.customEndDate =
                                                result["end"]!;
                                            controller.update();
                                          } else {
                                            controller.filterController = "";
                                          }
                                        }
                                      });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]);
      }),
    );
  }
}
