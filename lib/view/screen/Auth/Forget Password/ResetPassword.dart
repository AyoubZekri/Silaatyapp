import 'package:Silaaty/controller/auth/Forgetpassword/ResetPasswordcontroler.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/Auth/CustemTextTitleauth.dart';
import 'package:Silaaty/view/widget/Auth/login/Custemtextformauth.dart';
import 'package:Silaaty/view/widget/auth/Custem%20Buttonauth.dart';
import 'package:Silaaty/view/widget/auth/CustemTexTbodyauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/class/handlingview.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetpasswordcontrolerImp());

    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Reset Password".tr,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColor.backgroundcolor),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: GetBuilder<ResetpasswordcontrolerImp>(
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
                          Custemtexttitleauth(Title: "New Password".tr),
                          const SizedBox(
                            height: 20,
                          ),
                          Custemtextbodyauth(
                              Body: "Please Enter new Password".tr),
                          const SizedBox(
                            height: 55,
                          ),
                          GetBuilder<ResetpasswordcontrolerImp>(
                            builder: (controller) => Custemtextformauth(
                              obscureText: controller.obscureText,
                              onTap: () {
                                controller.showPassword();
                              },
                              keyboardType: TextInputType.visiblePassword,
                              MyController: controller.Passwoed,
                              hintText: "Enter Your Password".tr,
                              label: "Password".tr,
                              iconData: controller.obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              valid: (Val) {
                                return validInput(Val!, 20, 6, "password");
                              },
                            ),
                          ),
                          GetBuilder<ResetpasswordcontrolerImp>(
                            builder: (controller) => Custemtextformauth(
                              obscureText: controller.obscureText2,
                              onTap: () {
                                controller.showPasswored2();
                              },
                              keyboardType: TextInputType.visiblePassword,
                              MyController: controller.RePasswoed,
                              hintText: "confermPassword".tr,
                              label: "Password".tr,
                              iconData: controller.obscureText2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              valid: (Val) {
                                return validInput(Val!, 20, 6, "password");
                              },
                            ),
                          ),
                          Custembuttonauth(
                            onPressed: () {
                              controller.Resetpassword("Login");
                            },
                            Textname: "save".tr,
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
