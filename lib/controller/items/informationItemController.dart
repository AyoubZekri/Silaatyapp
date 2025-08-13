import 'package:Silaaty/controller/items/Edititemcontroller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/model/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';

class Informationitemcontroller extends GetxController {
  late int id;
  ProdactData prodactData = ProdactData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Data> InfoProduct = [];
  Future<void> GotoEdititem() async {
    final product = InfoProduct[0];
    final controller = Get.put(Edititemcontroller());
    controller.initData(product);
    await Get.toNamed(
      Approutes.edititemcontroller,
    );
  }

  getProdact() async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {'id': id};
    var response = await prodactData.ShwoProdact(data);
    print("============================================== $response");
    print("$id");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Product_Model.fromJson(response);
      InfoProduct = model.data ?? [];
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  SwitchProduct(int idpro) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {
      "id": id,
    };
    var response = await prodactData.Switchupdate(data);
    print("==================================================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Get.back(result: true);
      Get.snackbar(
        "success".tr,
        "product_updated_successfully".tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon:const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
      );

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Get.find<Homecontroller>().getCategoris();
      // });
    } else {
      print(response);
      Get.snackbar(
        "error".tr,
        "error_updating_product".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
      );
      statusrequest = Statusrequest.failure;
    }
  }

  deleteProdact(int iditem) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {'id': iditem};
    var response = await prodactData.deleteProdact(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }
    print("============================================== $response");
    print("$id");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Get.back(result: true);
      showSnackbar(
          "success".tr, "product_deleted_successfully".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "error_deleting_product".tr, Colors.red);

      statusrequest = Statusrequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    getProdact();
  }
}
