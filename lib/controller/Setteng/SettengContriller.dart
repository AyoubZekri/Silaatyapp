import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/logen_data.dart';
import 'package:Silaaty/view/widget/Setteng/custemLanguge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';


class Settengcontriller extends GetxController {
  GotoProfaile() {
    Get.toNamed(Approutes.profaile);
  }

  GotoNotification() {
    Get.toNamed(Approutes.notification);
  }

  GotoPrivacypolicy() {
    Get.toNamed(Approutes.Privacypolicy);
  }

  GotoInformationapp() {
    Get.toNamed(Approutes.Informationapp);
  }

  // GotoZakat() {
  //   Get.toNamed(Approutes.Zakat);
  // }

  gotoProfail() {
    Get.toNamed(Approutes.profail);
  }

  ChangePassword() {
    Get.toNamed(Approutes.reset);
  }

  LoginData loginData = LoginData(Get.find());
  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  log() {
    myServices.sharedPreferences?.clear();
  }

  logout() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await loginData.logout();
    print("==================================================$response");
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      myServices.sharedPreferences?.clear();
      // showSnackbar("success".tr, "logout_success".tr, Colors.green);

      Get.offAllNamed(Approutes.Login);
    } else {
      print(response);
      // showSnackbar("error".tr, "error_occurred".tr, Colors.green);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  void showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  "Langugs".tr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Custemlanguge(
                  Langugs: "ar", long: "Arabic".tr, image: Appimageassets.ALG),
              const SizedBox(
                height: 10,
              ),
              Custemlanguge(
                  Langugs: "en", long: "English".tr, image: Appimageassets.en)
            ],
          ),
        );
      },
    );
  }

}
