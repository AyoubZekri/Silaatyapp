import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Setteng/custemCartButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/Setteng/SettengPrivacycontroller.dart';

class SettengPrivacy extends StatefulWidget {
  const SettengPrivacy({super.key});

  @override
  State<SettengPrivacy> createState() => _SettengPrivacyState();
}

class _SettengPrivacyState extends State<SettengPrivacy> {
  @override
  Widget build(BuildContext context) {
    Settengprivacycontroller contrller = Get.put(Settengprivacycontroller());
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          title: Text('SettengPrivacy'.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
        ),
        body: GetBuilder<Settengprivacycontroller>(builder: (controller) {
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
                          contrller.GotoProfaile();
                        },
                        Title: "Edit Profaile".tr,
                        iconData: Icons.account_circle_outlined),
                    Custemcartbutton(
                        ontap: () {
                          contrller.ChangePassword();
                        },
                        Title: "Change the Password".tr,
                        iconData: Icons.admin_panel_settings),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
