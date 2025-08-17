import 'package:Silaaty/controller/Report/Reportcontroller.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Report/CustemcartReport.dart';
import 'package:Silaaty/view/widget/Report/CustemtextDealog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Reportcontroller controller = Get.put(Reportcontroller());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Reportcontroller>(builder: (controller) {
      return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            iconTheme: const IconThemeData(
              color: AppColor.backgroundcolor,
            ),
            title: Text(
              'Reports'.tr,
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
                  builder: (context) => CustomReportDialog(
                        controller: controller.reportController,
                        formKey: controller.formstate,
                        title: "Add Report".tr,
                        onSubmit: () {
                          controller.addReport();
                        },
                        onCancel: () {
                          Get.back();
                        },
                      ));
            },
            backgroundColor: AppColor.backgroundcolor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshdata();
              },
              child: Handlingview(
                statusrequest: controller.statusrequest,
                widget: Container(
                  child: ListView.builder(
                    itemCount: controller.report.length,
                    itemBuilder: (context, index) {
                      final rep = controller.report[index];
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
                          child: Custemcartreport(
                            Body: rep.report ?? "",
                            onEdit: () {
                              controller.reportEditController.text =
                                  rep.report ?? "";
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomReportDialog(
                                        controller:
                                            controller.reportEditController,
                                        formKey: controller.formstate,
                                        title: "Edit Report",
                                        onSubmit: () {
                                          controller.EditReport(rep.id);
                                        },
                                        onCancel: () {
                                          Get.back();
                                        },
                                      ));
                            },
                            onTap: () {
                              controller.Gotoinforeport(rep.id);
                            },
                            onDelete: () {
                              Get.defaultDialog(
                                backgroundColor: AppColor.white,
                                title: "تنبيه",
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.backgroundcolor),
                                middleText: "هل تريد حذف الابلاغ؟",
                                onConfirm: () {
                                  controller.deleteReport(rep.id);
                                },
                                onCancel: () {},
                                buttonColor: AppColor.backgroundcolor,
                                confirmTextColor: AppColor.primarycolor,
                                cancelTextColor: AppColor.backgroundcolor,
                              );
                            },
                          ));
                    },
                  ),
                ),
              )));
    });
  }
}
