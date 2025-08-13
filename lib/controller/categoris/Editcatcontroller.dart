import 'dart:io';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_Model.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/functions/uploudfiler.dart';
import 'package:flutter/material.dart';

import '../../core/functions/Snacpar.dart';

class Editcatcontroller extends GetxController {
  File? file;
  String? imageUrl;
  final nameController = TextEditingController();
  final nameFrController = TextEditingController();
  int? id;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;

  Editcat() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": id,
        'categorie_name': nameController.text,
        'categorie_name_fr': nameFrController.text,
      };

      var response = await categorisData.Updatecat(data, file);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        Get.back(result: true);
        showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
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

  void initData(Catdata cat) {
    id = cat.id!;
    nameController.text = cat.categorisName ?? "";
    nameFrController.text = cat.categorisNameFr ?? "";
    imageUrl = cat.categorisImage;
    print(cat.categorisImage);
  }

  @override
  void onClose() {
    nameController.dispose();
    nameFrController.dispose();
    super.onClose();
  }
}
