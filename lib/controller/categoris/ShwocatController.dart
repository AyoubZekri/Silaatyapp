import 'package:Silaaty/controller/categoris/Editcatcontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
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
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await categorisData.viewdata();
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final model = Categoris_Model.fromJson(response);
        Categoris = model.data?.catdata ?? [];
        if (Categoris.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      }
    }
    update();
  }

  deletecat(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {'id': id};
    var response = await categorisData.deletecat(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("============================================== $response");
    print("$id");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
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
