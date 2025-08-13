import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:Silaaty/data/datasource/Remote/Zakat/Zakat_data.dart';
import 'package:Silaaty/data/model/Product_Model_Zakat.dart';
import 'package:Silaaty/data/model/Zakat_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/functions/Snacpar.dart';

class Zacatcontroller extends GetxController {
  Future<void> GotoProdactDitails(int? id) async {
    await Get.toNamed(Approutes.informationitem, arguments: {"id": id});
  }

  final cashliquidityController = TextEditingController();
  late double totalzakat;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  ZakatData zakatdata = ZakatData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());

  Myservices myservices = Get.find();

  List<Data_model> zakat = [];
  List<Data> productzakat = [];
  var SumTotalPrise;

  Statusrequest statusrequest = Statusrequest.none;
  getZakat() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await zakatdata.GetZakat();
    print("===================================${response}");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Zakat_Model.fromJson(response);
      zakat = model.data ?? [];
      if (zakat.isEmpty) {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  addliquidity() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        'liquidity': cashliquidityController.text,
      };
      var response = await zakatdata.addcashliquidity(data);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }

      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        cashliquidityController.clear();
        getZakat();
        showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }
    }
  }

  @override
  void onInit() {
    getZakat();

    super.onInit();
  }
}
