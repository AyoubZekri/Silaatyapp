import 'dart:io';

import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/Userdata.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/functions/Snacpar.dart';
import '../../core/functions/uploudfiler.dart';
import '../StartpageContrller.dart';

class Updateusercontroller extends GetxController {
  File? file;
  final nameController = TextEditingController();
  final FamlynameController = TextEditingController();
  final PhoneController = TextEditingController();
  final emailController = TextEditingController();
  final adresseController = TextEditingController();
  final AddressController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Userdata userdata = Userdata(Get.find());

  // Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  updateuser() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      var response = await userdata.updateuser(
          nameController.text,
          PhoneController.text,
          FamlynameController.text,
          adresseController.text,
          file);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("==================================================$response");

      statusrequest = handlingData(response);

      if (statusrequest == Statusrequest.success) {
        if (response["status"] == 1) {
          // showSnackbar("success".tr, "updateSuccess".tr, Colors.green);
          final startController = Get.find<Startpagecontrller>();
          await startController.getUser();
          Get.offAllNamed(Approutes.HomeScreen);
        } else {
          showSnackbar("error".tr, "somethingWentWrong".tr, Colors.red);
          statusrequest = Statusrequest.failure;
        }
      }
    }
  }

  void imageupload() async {
    file = await fileuploadGallery(false);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.getString("name") ?? "";
    FamlynameController.text = prefs.getString("family_name") ?? "";
    PhoneController.text = prefs.getString("phone") ?? "";
    emailController.text = prefs.getString("email") ?? "";
    adresseController.text = prefs.getString("adresse") ?? "";
  }
}
