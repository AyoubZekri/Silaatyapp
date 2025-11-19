import 'package:Silaaty/controller/auth/Forgetpassword/VeriFycodecontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Auth/CustemTextTitleauth.dart';
import 'package:Silaaty/view/widget/auth/CustemTexTbodyauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';

class Verifiycodesetting extends StatelessWidget {
  const Verifiycodesetting({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VeriFyCodeControllerImp());
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "VeriFiCation Code".tr,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColor.backgroundcolor),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: GetBuilder<VeriFyCodeControllerImp>(
            builder: (controller) => HandlingviewAuth(
                  statusrequest: controller.statusrequest,
                  widget: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 35),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Custemtexttitleauth(
                          Title: "Check Code".tr,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Custemtextbodyauth(
                            Body: "Plese Enter The Digit Code Sent To".tr),
                        const SizedBox(
                          height: 55,
                        ),
                        // Custemtextformauth(
                        //   MyController: controller.Email,
                        //   hintText: "Enter Your Email",
                        //   label: "Email",
                        //   iconData: Icons.person_2_outlined,
                        // ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: OtpTextField(
                            borderRadius: BorderRadius.circular(10),
                            numberOfFields: 5,
                            borderColor: const Color(0xFF512DA8),
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              //handle validation or checks here
                            },
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode) {
                              controller.GoToresetPasswored(
                                  verificationCode, "resePasswordsetting");
                            }, // end onSubmit
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              controller.reset();
                            },
                            child: Center(
                                child: Text(
                              "rsend Verify code".tr,
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: AppColor.backgroundcolor),
                            ))),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
