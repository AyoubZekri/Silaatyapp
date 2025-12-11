import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../data/datasource/Remote/Auth/Forgetpassword/checkemail.dart';
import '../../data/datasource/Remote/Auth/Forgetpassword/verifycode.dart';

abstract class VerifiycodesignupController extends GetxController {
  CheckCode();
  GoToSuccessSignup(VerifiycodeSignup);
}

class VerifiycodesignupControllerImp extends VerifiycodesignupController {
  String? email;
  Statusrequest statusrequest = Statusrequest.none;
  Verifycodedata verifiycodeSignupData = Verifycodedata(Get.find());
  Checkemaildata checkemaildata = Checkemaildata(Get.find());

  @override
  CheckCode() {}

  @override
  GoToSuccessSignup(VerifiycodeSignup) async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response =
        await verifiycodeSignupData.postdata(VerifiycodeSignup, email!);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == 1) {
        Get.offNamed(Approutes.Login);
      } else {
        showSnackbar("Warning".tr, "Verfiy code not Correct".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    } else {
      showSnackbar("Warning".tr, "Verfiy code not Correct".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  reset() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await checkemaildata.postdata(email!);
    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == 1) {
        showSnackbar("success".tr, "code_sent".tr, Colors.green);
      } else {
        showSnackbar("Warning".tr, "email_not_found".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    email = Get.arguments["email"];
    super.onInit();
  }
}
