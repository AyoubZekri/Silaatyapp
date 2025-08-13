import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Report_data.dart';
import 'package:Silaaty/data/model/Report_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';

class Reportcontroller extends GetxController {
  final reportController = TextEditingController();
  final reportEditController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  ReportData reportData = ReportData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Report> report = [];

  getReport() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await reportData.ShwoReport();

    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      final model = Report_Model.fromJson(response);
      report = model.data!.report ?? [];
      if (report.isEmpty) {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  addReport() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        'report': reportController.text,
      };
      var response = await reportData.addReport(data);
      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        reportController.clear();
        Get.back();
        getReport();
        showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        print(response);
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  EditReport(int? id) async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": id,
        'report': reportEditController.text,
      };
      var response = await reportData.EditReport(data);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }

      print("==================================================$response");
      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        reportEditController.clear();
        Get.back();
        getReport();
        showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        print(response);
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  deleteReport(int? id) async {
    update();
    Map data = {
      "id": id,
    };
    var response = await reportData.deleteReport(data);
    if (response == Statusrequest.serverfailure) {
      showSnackbar("error".tr, "noInternet".tr, Colors.red);
    }

    print("==================================================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      Get.back();
      getReport();
      showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      print(response);
      showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  Gotoinforeport(int? id) {
    Get.toNamed(Approutes.shwoReport, arguments: {"id": id});
  }

  refreshdata() async {
    await getReport();
  }

  @override
  void onInit() {
    getReport();
    super.onInit();
  }
}
