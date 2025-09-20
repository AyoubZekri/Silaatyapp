import 'package:Silaaty/controller/auth/CheckEmailcontroller.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/functions/valiedinput.dart';
import '../../widget/Auth/CustemTextTitleauth.dart';
import '../../widget/Auth/login/Custemtextformauth.dart';
import '../../widget/auth/Custem Buttonauth.dart';
import '../../widget/auth/CustemTexTbodyauth.dart';

class CheckEmail extends StatelessWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CheckEmailControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.backgroundcolor,
          elevation: 0.0,
          title: Text('Check Email',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColor.grey)),
        ),
        body: GetBuilder<CheckEmailControllerImp>(
            builder: (controller) => HandlingviewAuth(
                  statusrequest: controller.statusrequest,
                  widget: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    child: ListView(children: [
                      const SizedBox(height: 20),
                      const Custemtexttitleauth(
                          Title: "Account successfully created"),
                      const SizedBox(height: 10),
                      const Custemtextbodyauth(
                        Body:
                            'please Enter Your Email Address To Recive A verification code',
                      ),
                      const SizedBox(height: 15),
                      Custemtextformauth(
                        MyController: controller.email,
                        hintText: "Enter Your Email",
                        label: "Email",
                        iconData: Icons.email_outlined,
                        valid: (Val) {
                          return validInput(Val!, 100, 5, "Email");
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Custembuttonauth(
                        onPressed: () {
                          controller.goToSuccessSignUp();
                        },
                        Textname: 'check',
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                )));
  }
}
