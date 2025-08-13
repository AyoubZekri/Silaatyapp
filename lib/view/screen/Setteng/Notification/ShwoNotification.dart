import 'package:Silaaty/controller/Notification/ShwoNotificationcontroller.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/view/widget/Iformationitem/CustemBody.dart';
import 'package:Silaaty/view/widget/Iformationitem/CustemTextTitle.dart';
import 'package:Silaaty/view/widget/Iformationitem/iconButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Shwonotification extends StatefulWidget {
  const Shwonotification({super.key});

  @override
  State<Shwonotification> createState() => _ShwonotificationState();
}

class _ShwonotificationState extends State<Shwonotification> {
  ShwoNotificationcontroller controller = Get.put(ShwoNotificationcontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Notification'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: GetBuilder<ShwoNotificationcontroller>(builder: (controller) {
        if (controller.notification.isEmpty) {
          return Center(
            child: Lottie.asset(Appimageassets.loading, width: 150),
          );
        }
        return HandlingviewAuth(
          statusrequest: controller.statusrequest,
          widget: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Custemtexttitle(
                            title: controller.notification[0].title ?? ""),
                        const SizedBox(
                          width: 20,
                        ),
                        Iconbutton(
                          iconData: Icons.delete,
                          onTap: () {
                            Get.defaultDialog(
                              backgroundColor: AppColor.white,
                              title: "تنبيه",
                              titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.backgroundcolor),
                              middleText: "هل تريد تريد حذف الاشعار",
                              onConfirm: () {
                                controller.deleteNotification(controller.id);
                              },
                              onCancel: () {},
                              buttonColor: AppColor.backgroundcolor,
                              confirmTextColor: AppColor.primarycolor,
                              cancelTextColor: AppColor.backgroundcolor,
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Custembody(body: controller.notification[0].content ?? ""),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Custembody(
                        body:
                            "Date : ${controller.notification[0].createdAt?.substring(0, 10) ?? ""}")
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
