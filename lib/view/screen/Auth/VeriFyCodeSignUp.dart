import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../controller/auth/VerifiycodeSignUp_Controller.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/Auth/CustemTextTitleauth.dart';
import '../../widget/auth/CustemTexTbodyauth.dart';

class VerifiycodeSignUp extends StatelessWidget {
  const VerifiycodeSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifiycodesignupControllerImp());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "VeriFiCation Code SignUp",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColor.backgroundcolor),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: GetBuilder<VerifiycodesignupControllerImp>(
            builder: (controller) => HandlingviewAuth(
                  statusrequest: controller.statusrequest,
                  widget: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Custemtexttitleauth(
                          Title: "Verification Code",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Custemtextbodyauth(
                            Body: "Plese Enter The Digit Code Sent To"),
                        const SizedBox(
                          height: 55,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: OtpTextField(
                            borderRadius: BorderRadius.circular(10),
                            numberOfFields: 5,
                            borderColor:const Color(0xFF512DA8),
                            showFieldAsBox: true,
                            onCodeChanged: (String code) {},
                            onSubmit: (String verificationCode) {
                              controller.GoToSuccessSignup(verificationCode);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                            onTap: () {
                              controller.reset();
                            },
                            child: const Center(
                                child: Text(
                              "rsend Verify code",
                              style: TextStyle(
                                  fontSize: 20, color: AppColor.backgroundcolor),
                            )))
                      ],
                    ),
                  ),
            )));
  }
}
