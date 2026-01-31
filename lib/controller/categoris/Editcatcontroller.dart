import 'dart:io';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_Model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/functions/uploudfiler.dart';

class Editcatcontroller extends GetxController {
  File? file;
  String? imageUrl;
  final nameController = TextEditingController();
  final nameFrController = TextEditingController();
  String? uuid; 

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;

  /// 🟢 تعديل كاتيجوري أوفلاين + sync
  Future<void> Editcat() async {
    if (formstate.currentState!.validate()) {
 

      if (uuid == null) {
        showSnackbar("error".tr, "Invalid category ID", Colors.red);
        return;
      }

      final success = await categorisData.Updatecat(
        uuid!,
        nameController.text,
        nameFrController.text,
        file,
      );

      if (success) {
        statusrequest = Statusrequest.success;
        Get.back(result: true);
        // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }

      update();
    }
  }

  /// 🟢 رفع صورة
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

  /// 🟢 تهيئة البيانات لما تفتح صفحة التعديل
  void initData(Catdata cat) {
    uuid = cat.uuid; // بدل id
    nameController.text = cat.categorisName ?? "";
    nameFrController.text = cat.categorisNameFr ?? "";
    imageUrl = cat.categorisImage;
    print("📷 الصورة الحالية: ${cat.categorisImage}");
  }

  @override
  void onClose() {
    nameController.dispose();
    nameFrController.dispose();
    super.onClose();
  }
}
