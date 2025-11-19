import 'package:Silaaty/controller/Notification/notificaitioncontroller.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Notification/custemcartnotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  Notificaitioncontroller controller = Get.put(Notificaitioncontroller());

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
      body: Container(
          margin: const EdgeInsets.all(5),
          child: GetBuilder<Notificaitioncontroller>(builder: (controller) {
            return Handlingview(
                statusrequest: controller.statusrequest,
                iconData: Icons.notifications,
                title: "لا يوجد إشعارات".tr,
                widget: RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshdata();
                    },
                    child: ListView.builder(
                      itemCount: controller.notification.length,
                      itemBuilder: (context, index) {
                        final not = controller.notification[index];
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
                            child: Custemcartnotification(
                              onTap: () {
                                controller.Gotoshownotification(not.uuid);
                              },
                              onDelete: () {
                                Get.defaultDialog(
                                  backgroundColor: AppColor.white,
                                  title: "تنبيه".tr,
                                  titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.backgroundcolor),
                                  middleText: "هل تريد حذف الاشعار؟".tr,
                                  onConfirm: () {
                                    controller.deleteNotification(not.uuid);
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                  buttonColor: AppColor.backgroundcolor,
                                  confirmTextColor: AppColor.primarycolor,
                                  cancelTextColor: AppColor.backgroundcolor,
                                );
                              },
                              Title: not.title ?? "",
                              Body: not.content ?? "",
                            ));
                      },
                    )));
          })),
    );
  }
}
