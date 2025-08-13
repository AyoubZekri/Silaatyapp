import 'dart:io';

import 'package:Silaaty/controller/HomeScreen/HomeScreenController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/HomeScreen/CustemapparbuttonList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomescreencontrollerImp());
    return GetBuilder<HomescreencontrollerImp>(
        builder: (controller) => Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: const CustemapparbuttonList(),
              // ignore: deprecated_member_use
              body: WillPopScope(
                child: controller.Screen.elementAt(controller.currentpage),
                onWillPop: () {
                  Get.defaultDialog(
                    backgroundColor: AppColor.white,
                    title: "Alert".tr,
                    titleStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.backgroundcolor),
                    middleText: "هل تريد الخروج من التطبيق".tr,
                    onConfirm: () {
                      exit(0);
                    },
                    onCancel: () {},
                    buttonColor: AppColor.backgroundcolor,
                    confirmTextColor: AppColor.primarycolor,
                    cancelTextColor: AppColor.backgroundcolor,
                  );

                  return Future.value(false);
                },
              ),
            ));
  }
}
