import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/services/Services.dart';
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
  Myservices myServices = Get.find();
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
        print(response["data"]["user"]["token"]);
        myServices.sharedPreferences!
            .setInt("id", response['data']["user"]["user"]['id']);
        myServices.sharedPreferences!
            .setString("email", response['data']["user"]["user"]['email']);
        myServices.sharedPreferences!
            .setString("name", response["data"]["user"]["user"]["name"]);
        myServices.sharedPreferences!.setString(
            "phone", response["data"]["user"]["user"]["phone_number"]);
        myServices.sharedPreferences!.setString(
            "family_name", response["data"]["user"]["user"]["family_name"]);
        myServices.sharedPreferences!.setInt("user_notify_status",
            response["data"]["user"]["user"]["user_notify_status"]);
        if (response["data"]["user"]["user"]["adresse"] != null) {
          myServices.sharedPreferences!.setString(
              "adresse", response["data"]["user"]["user"]["adresse"]);
        }

        if (response["data"]["user"]["user"]["logo_stor"] != null) {
          myServices.sharedPreferences!.setString(
              "logo_stor", response["data"]["user"]["user"]["logo_stor"]);
        }

        myServices.sharedPreferences!
            .setInt("Status", response["data"]["user"]["user"]["Status"]);
        if (response["data"]["user"]["user"]["date_experiment"] != null) {
          myServices.sharedPreferences!.setString("date_experiment",
              response["data"]["user"]["user"]["date_experiment"]);
        }
        myServices.sharedPreferences!
            .setString("token", response["data"]["user"]["token"]);
        myServices.sharedPreferences!.setString("step", "2");
        DateTime? experimentDate;

        final experimentDateStr =
            response["data"]["user"]["user"]["date_experiment"];

        if (experimentDateStr != null &&
            experimentDateStr.toString().isNotEmpty) {
          try {
            experimentDate = DateTime.parse(experimentDateStr);
          } catch (e) {
            experimentDate = null;
          }
        }

        final today = DateTime.now();
        final status = response['data']["user"]["user"]['Status'];

        if (status == 0) {
          Get.offNamed(Approutes.VerifiycodeSignUp, arguments: {
            "email": response['data']["user"]["user"]['email'],
          });
          reset();
        } else if (status > 2) {
          Get.offNamed(Approutes.HomeScreen, arguments: {"fromlogin": 1});
        } else if (experimentDate != null &&
            today.isBefore(experimentDate) &&
            response['data']["user"]["user"]['Status'] >= 2) {
          Get.offNamed(Approutes.HomeScreen, arguments: {"fromlogin": 1});
        } else {
          showSnackbar("error".tr, "contact_admin".tr, Colors.red);
        }
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
