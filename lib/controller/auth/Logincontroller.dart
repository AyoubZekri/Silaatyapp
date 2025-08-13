import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/logen_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasource/Remote/Auth/Forgetpassword/checkemail.dart';

class Logincontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController Email;
  late TextEditingController Password;
  bool issobscureText = true;
  showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  Checkemaildata checkemaildata = Checkemaildata(Get.find());
  Myservices myServices = Get.find();
  LoginData logenData = LoginData(Get.find());
  List data = [];
  Statusrequest statusrequest = Statusrequest.none;

  Login() async {
    var formData = formstate.currentState;
    if (formData!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $fcmToken");
      var response =
          await logenData.postdata(Password.text, Email.text, fcmToken!);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      statusrequest = handlingData(response);
      print("=============================== Controller $response ");
      if (statusrequest == Statusrequest.success) {
        if (response["status"] == 1) {
          print(response["data"]["user"]["token"]);

          // myServices.sharedPreferences!.setInt("id", response['data']['id']);
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
          myServices.sharedPreferences!
              .setString("token", response["data"]["user"]["token"]);
          myServices.sharedPreferences!.setString("step", "2");
          if (response['data']["user"]["user"]['Status'] == 0) {
            Get.offNamed(Approutes.VerifiycodeSignUp, arguments: {
              "email": Email.text,
            });
            reset();
          } else if (response['data']["user"]["user"]['Status'] >= 2) {
            Get.offNamed(
              Approutes.HomeScreen,
            );
          } else {
            showSnackbar("error".tr, "contact_admin".tr, Colors.red);
          }
        }
      } else {
        showSnackbar("Warning".tr, "email_password_wrong".tr, Colors.orange);
      }
      update();
    } else {
      print("Not valid");
    }
  }

  GoToSignUp() {
    Get.offNamed(Approutes.SignUp);
  }

  GoToForgenPassword() {
    Get.offNamed(Approutes.forgenPassword);
  }

  reset() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await checkemaildata.postdata(Email.text);
    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == 1) {
        showSnackbar("success".tr, "code_sent".tr, Colors.green);
      } else {
        showSnackbar("Warning".tr, "email_not_found".tr, Colors.orange);

        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  getUser() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await logenData.getUser();
    print("==============================$response");
    statusrequest = handlingData(response);
    // if (statusrequest == Statusrequest.success) {
    //   if (response["status"] == 1) {
    //     final model = Categoris_Model.fromJson(response);
    //     Categoris = model.data?.catdata ?? [];
    //     if (Categoris.isEmpty) {
    //       statusrequest = Statusrequest.failure;
    //     }
    //   }
    // }

    update();
  }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   print("token:$token");
    // });

    Email = TextEditingController();
    Password = TextEditingController();
    getUser();
    super.onInit();
  }

  @override
  void dispose() {
    Email.dispose();
    Password.dispose();
    super.dispose();
  }
}
