import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Report_data.dart';
import 'package:Silaaty/data/model/Report_Model.dart';
import 'package:get/get.dart';

class Shworeportcontroller extends GetxController {
  ReportData reportData = ReportData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Report> report = [];
  int? id;

  ShwoReport() async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {
      "id": id,
    };
    var response = await reportData.ShwoinfoReport(data);
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Report_Model.fromJson(response);
      report = model.data!.report ?? [];
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    ShwoReport();
    print("============================================== $id");
    super.onInit();
  }
}
