import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/data/datasource/Remote/Report_data.dart';
import 'package:Silaaty/data/model/Report_Model.dart';
import 'package:get/get.dart';

class Shworeportcontroller extends GetxController {
  ReportData reportData = ReportData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  List<Report> report = [];
  String? uuid;

  ShwoReport() async {

    Map<String, Object?> data = {
      "uuid": uuid,
    };
    var result = await reportData.ShwoinfoReport(data);
    print("============================================== $result");
    if (result["status"] == 1) {
      final model = Report_Model.fromJson(result);
      report = model.data!.report ?? [];
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    uuid = Get.arguments['uuid'];
    ShwoReport();
    print("============================================== $uuid");
    super.onInit();
  }
}
