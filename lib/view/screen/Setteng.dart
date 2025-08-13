import 'package:Silaaty/controller/Setteng/SettengContriller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Setteng/custemCartButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setteng extends StatefulWidget {
  const Setteng({super.key});

  @override
  State<Setteng> createState() => _SettengState();
}

class _SettengState extends State<Setteng> {
  @override
  Widget build(BuildContext context) {
    Settengcontriller contrller = Get.put(Settengcontriller());
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          title: Text('Setting'.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
        ),
        body: GetBuilder<Settengcontriller>(builder: (controller) {
                  return ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Custemcartbutton(
                    ontap: () {
                      contrller.showLanguageSheet(context);
                    },
                    Title: "Langugs".tr,
                    iconData: Icons.language),
                Custemcartbutton(
                    ontap: () {
                      contrller.GotoPrivacypolicy();
                    },
                    Title: "Privacy Policy".tr,
                    iconData: Icons.privacy_tip),
                Custemcartbutton(
                    ontap: () {
                      contrller.GotoInformationapp();
                    },
                    Title: "informationApp".tr,
                    iconData: Icons.info),
                Custemcartbutton(
                    ontap: () {
                      Get.defaultDialog(
                        backgroundColor: AppColor.white,
                        title: "Alert".tr,
                        titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.backgroundcolor),
                        middleText: "هل تريد تسجيل الخروج".tr,
                        onConfirm: () {
                          contrller.logout();
                          Get.back(result: true);
                        },
                        onCancel: () {},
                        buttonColor: AppColor.backgroundcolor,
                        confirmTextColor: AppColor.primarycolor,
                        cancelTextColor: AppColor.backgroundcolor,
                      );
                    },
                    Title: "Logout".tr,
                    iconData: Icons.logout),
              ],
            ),
          ),
        ],
                  );
                }));
  }
}
