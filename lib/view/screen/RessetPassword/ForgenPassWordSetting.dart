import 'package:Silaaty/controller/auth/Forgetpassword/Forgen_Controller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/Auth/CustemTextTitleauth.dart';
import 'package:Silaaty/view/widget/Auth/login/Custemtextformauth.dart';
import 'package:Silaaty/view/widget/auth/Custem%20Buttonauth.dart';
import 'package:Silaaty/view/widget/auth/CustemTexTbodyauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';

class Forgenpasswordsetting extends StatelessWidget {
  const Forgenpasswordsetting({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgenControllerImp());
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Forget Password".tr,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColor.backgroundcolor),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: GetBuilder<ForgenControllerImp>(
            builder: (controller) => HandlingviewAuth(
                  statusrequest: controller.statusrequest,
                  widget: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 35),
                    child: Form(
                      key: controller.formstate,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Custemtexttitleauth(
                            Title: "Check Email".tr,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Custemtextbodyauth(
                              Body: "enterEmailToReceiveCode".tr),
                          const SizedBox(
                            height: 55,
                          ),
                          Custemtextformauth(
                            MyController: controller.email,
                            hintText: "Enter Your Email".tr,
                            label: "Email".tr,
                            iconData: Icons.email_outlined,
                            valid: (Val) {
                              return validInput(Val!, 100, 5, "Email");
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Custembuttonauth(
                            onPressed: () {
                              controller.CheckEmail("VerFiyCodeSetteng");
                            },
                            Textname: "check".tr,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
  }
}
