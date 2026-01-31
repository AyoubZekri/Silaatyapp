import 'dart:io';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:flutter/material.dart';

import '../../core/functions/Snacpar.dart';

class Addcatcontroller extends GetxController {
  File? file;
  final nameController = TextEditingController();
  final nameFrController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;

  addcat() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      // Map data = {
      //   'categorie_name': nameController.text,
      //   'categorie_name_fr': nameFrController.text,
      // };
      var response = await categorisData.Adddata(nameController.text,nameFrController.text, file);


      // ignore: avoid_print
      print("==================================================$response");
      statusrequest = handlingData(response);
      if (response != false) {
        Get.back(result: true);

        // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }
    }
  }

  void imageupload() {
    showbottom(uploadimagecamera, uploadimagefile);
  }

  Future<void> uploadimagecamera() async {
    file = await imageuploadcamera();
    update();
  }

  Future<void> uploadimagefile() async {
    file = await fileuploadGallery(false);
    update();
  }
}
