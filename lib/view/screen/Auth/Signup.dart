import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../controller/auth/Signupcontroller.dart';
import '../../../core/class/Statusrequest.dart';
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
        backgroundColor: AppColor.white,
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
              builder: (controller) => Container(
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
                          hintText: "إسم التاجر".tr,
                          label: "إسم التاجر".tr,
                          iconData: Icons.person_2_outlined,
                          valid: (Val) {
                            return validInput(Val!, 20, 1, "username");
                          },
                        ),
                        Custemtextformauth(
                          keyboardType: TextInputType.name,
                          MyController: controller.familyname,
                          hintText: "إسم المتجر".tr,
                          label: "إسم المتجر".tr,
                          iconData: Icons.person_2_outlined,
                          valid: (Val) {
                            return validInput(Val!, 20, 1, "username");
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
                        const SizedBox(height: 15),
                        GetBuilder<SignupControllerImp>(
                          builder: (controller) => Container(
                            margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                            child: DropdownButtonFormField2<int>(
                              value: controller.accountType,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                                label: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 9),
                                  child: Text("نوع الحساب".tr),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Icon(Icons.keyboard_arrow_down, color: AppColor.grey),
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 203, 201, 201),
                                  ),
                                ),
                                elevation: 8,
                              ),
                              isExpanded: true,
                              items: [1, 2].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        value == 1 ? Icons.storefront_outlined : Icons.local_shipping_outlined,
                                        color: AppColor.backgroundcolor,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        value == 1 ? "محل".tr : "موزع".tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.backgroundcolor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  controller.changeAccountType(newValue);
                                }
                              },
                            ),
                          ),
                        ),const SizedBox(height: 20),
                        Custembuttonauth(
                                isLoading: controller.statusrequest == Statusrequest.loadeng,
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
            ));
  }
}
