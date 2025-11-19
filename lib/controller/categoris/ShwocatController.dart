import 'package:Silaaty/controller/categoris/Editcatcontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';

class Shwocatcontroller extends GetxController {
  late int id;
  CategorisData categorisData = CategorisData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Catdata> Categoris = [];
  Future<void> GotoEditcat(int index) async {
    final cat = Categoris[index];
    final controller = Get.put(Editcatcontroller());
    controller.initData(cat);
    final result = await Get.toNamed(Approutes.editCat);
    if (result == true) {
      getcat();
    }
  }

  gotoaddcat() async {
    final result = await Get.toNamed(Approutes.addcat);
    if (result == true) {
      getcat();
    }
  }

  getcat() async {
    try {
      var response = await categorisData.viewdata();

      print("============================================== $response");

      if (response.isNotEmpty) {
        Categoris = (response as List)
            .map((e) => Catdata.fromJson(e as Map<String, dynamic>))
            .toList();
        statusrequest = Statusrequest.success;
      } else {
        statusrequest = Statusrequest.failure;
      }
    } catch (e) {
      print("❌ getcat error: $e");
      statusrequest = Statusrequest.serverfailure;
    }

    update();
  }

  Future<void> deletecat(String uuid) async {
    final success = await categorisData.deletecat(uuid);

    if (success) {
      statusrequest = Statusrequest.success;
      Get.back();
      showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      getcat();
    } else {
      showSnackbar("error".tr, "operationFailed".tr, Colors.red);
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    // getProdact();
    getcat();
  }

  refreshData() async {
    await getcat();
  }
}
