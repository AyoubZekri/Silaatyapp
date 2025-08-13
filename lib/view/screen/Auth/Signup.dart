import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth/Signupcontroller.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/functions/alertExitApp.dart';
import '../../../core/functions/valiedinput.dart';
import '../../widget/Auth/CustemTextTitleauth.dart';
import '../../widget/Auth/login/Custemtextformauth.dart';
import '../../widget/auth/Custem Buttonauth.dart';
import '../../widget/auth/CustemTexTbodyauth.dart';
import '../../widget/auth/TextSignup.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SignupControllerImp controller = Get.put(SignupControllerImp());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Sign Up",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColor.backgroundcolor),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: WillPopScope(
            onWillPop: alertExitApp,
            child: GetBuilder<SignupControllerImp>(
              builder: (controller) => HandlingviewAuth(
                statusrequest: controller.statusrequest,
                widget: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  child: Form(
                    key: controller.formstate,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Custemtexttitleauth(
                          Title: "Welcome Back".tr,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Custemtextbodyauth(Body: "12".tr),
                        const SizedBox(
                          height: 20,
                        ),
                        Custemtextformauth(
                          keyboardType: TextInputType.name,
                          MyController: controller.Username,
                          hintText: "Enter Your Username".tr,
                          label: "Username".tr,
                          iconData: Icons.person_2_outlined,
                          valid: (Val) {
                            return validInput(Val!, 20, 5, "username");
                          },
                        ),
                        Custemtextformauth(
                          keyboardType: TextInputType.name,
                          MyController: controller.familyname,
                          hintText: "Enter Your Familyname".tr,
                          label: "Familyname".tr,
                          iconData: Icons.person_2_outlined,
                          valid: (Val) {
                            return validInput(Val!, 20, 5, "username");
                          },
                        ),
                        Custemtextformauth(
                          keyboardType: TextInputType.emailAddress,
                          MyController: controller.Email,
                          hintText: "Enter Your Email".tr,
                          label: "Email".tr,
                          iconData: Icons.email_outlined,
                          valid: (Val) {
                            return validInput(Val!, 100, 5, "Email");
                          },
                        ),
                        Custemtextformauth(
                          keyboardType: TextInputType.phone,
                          MyController: controller.Phone,
                          hintText: "Enter Your Phone".tr,
                          label: "Phone".tr,
                          iconData: Icons.phone_android_outlined,
                          valid: (Val) {
                            return validInput(Val!, 12, 10, "Phone");
                          },
                        ),
                        GetBuilder<SignupControllerImp>(
                          builder: (controller) => Custemtextformauth(
                            onTap: () {
                              controller.showPassword();
                            },
                            obscureText: controller.obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            MyController: controller.Password,
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
                        GetBuilder<SignupControllerImp>(
                          builder: (controller) => Custemtextformauth(
                            onTap: () {
                              controller.showPassword2();
                            },
                            obscureText: controller.obscureText2,
                            keyboardType: TextInputType.visiblePassword,
                            MyController: controller.confermPassword,
                            hintText: "Enter Your Password conferm".tr,
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
                            controller.SignUp();
                          },
                          Textname: "Sign Up".tr,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        custemTextsignup(
                            Textoen: " have an account ? ".tr,
                            TextoTwo: "Login".tr,
                            onTap: () {
                              controller.GoToSignIn();
                            })
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
