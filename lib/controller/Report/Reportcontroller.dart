import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/Report_data.dart';
import 'package:Silaaty/data/model/Report_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class Reportcontroller extends GetxController {
  final reportController = TextEditingController();
  final reportEditController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  ReportData reportData = ReportData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Report> report = [];

  getReport() async {
    update();
    var result = await reportData.ShwoReport();

    print("============================================== $result");
    if (result["status"] == 1) {
      final model = Report_Model.fromJson(result);
      report = model.data!.report ?? [];
      report.isEmpty
          ? statusrequest = Statusrequest.failure
          : statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  addReport() async {
    if (formstate.currentState!.validate()) {
      final uuid = Uuid().v4();
      update();
      Map<String, Object?> data = {
        "uuid": uuid,
        'report': reportController.text,
        "report_id": id,
        "created_at": DateTime.now().toIso8601String(),
      };
      var result = await reportData.addReport(data);
      print("==================================================$result");
      if (result["status"] == 1) {
        statusrequest = Statusrequest.success;
        reportController.clear();
        Get.back();
        getReport();
        // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }
    }
  }

  EditReport(String? uuid) async {
    if (formstate.currentState!.validate()) {
      Map<String, Object?> data = {
        "uuid": uuid,
        'report': reportEditController.text,
      };
      var result = await reportData.EditReport(data);

      print("==================================================$result");
      if (result["status"] == 1) {
        statusrequest = Statusrequest.success;
        reportEditController.clear();
        Get.back();
        getReport();
        // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      }
    }
  }

  deleteReport(String? uuid) async {
    update();
    Map<String, Object?> data = {
      "uuid": uuid,
      'updated_at': DateTime.now().toIso8601String(),
    };
    var result = await reportData.deleteReport(data);
    print("==================================================$result");
    if (result["status"] == 1) {
      statusrequest = Statusrequest.success;
      Get.back();
      getReport();
      // showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operationFailed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  Gotoinforeport(String? uuid) {
    Get.toNamed(Approutes.shwoReport, arguments: {"uuid": uuid});
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
