import 'package:Silaaty/controller/auth/Logincontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/Auth/custembutonauth.dart';
import 'package:Silaaty/view/widget/Auth/login/CustemBody.dart';
import 'package:Silaaty/view/widget/Auth/login/Custemtextformauth.dart';
import 'package:Silaaty/view/widget/Auth/login/custemtitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/class/handlingview.dart';
import '../../../core/constant/imageassets.DART';
import '../../widget/auth/TextSignup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Logincontroller controller = Get.put(Logincontroller());

    return Scaffold(
        backgroundColor: AppColor.white,
        body: Container(
            // onWillPop: alertExitApp,

            color: Colors.white,
            child: GetBuilder<Logincontroller>(
                builder: (_) => HandlingviewAuth(
                      statusrequest: controller.statusrequest,
                      widget: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 35, right: 35, top: 100),
                        child: Form(
                          key: controller.formstate,
                          child: ListView(
                            children: [
                              Image.asset(
                                Appimageassets.logo,
                                height: 200,
                              ),
                              Custemtitle(
                                tatli: "1".tr,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Custemtextbody(Body: "12".tr),
                              const SizedBox(
                                height: 30,
                              ),
                              Custemtextformauth(
                                MyController: controller.Email,
                                hintText: "10".tr,
                                label: "2".tr,
                                iconData: Icons.email_outlined,
                                valid: (Val) {
                                  return validInput(Val!, 100, 5, "email");
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              GetBuilder<Logincontroller>(
                                builder: (controller) => Custemtextformauth(
                                  obscureText: controller.issobscureText,
                                  onTap: () {
                                    controller.showPassword();
                                    print(controller.issobscureText);
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  MyController: controller.Password,
                                  hintText: "11".tr,
                                  label: "3".tr,
                                  iconData: controller.issobscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  valid: (Val) {
                                    return validInput(Val!, 20, 6, "Password");
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.GoToForgenPassword();
                                },
                                child: Text(
                                  "Forget Password".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: AppColor.backgroundcolor),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Custembutonauth(
                                onPressed: () {
                                  controller.Login();
                                },
                                title: "1".tr,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              custemTextsignup(
                                onTap: () {
                                  controller.GoToSignUp();
                                },
                                TextoTwo: "Signup".tr,
                                Textoen: "5".tr,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              custemTextsignup(
                                onTap: () async {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: "codedev39@gmail.com",
                                  );

                                  try {
                                    await launchUrl(
                                      emailUri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("تعذر فتح تطبيق البريد"),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                TextoTwo: "ClickHere".tr,
                                Textoen: "Conect".tr,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ),
                    ))));
  }
}
