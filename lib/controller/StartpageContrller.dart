import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/logen_data.dart';
import 'package:Silaaty/data/model/User_Model.dart';
import 'package:get/get.dart';

class Startpagecontrller extends GetxController {
  LoginData logenData = LoginData(Get.find());
  // List data = [];
  late int Status;

  Statusrequest statusrequest = Statusrequest.none;

  getUser() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await logenData.getUser();
    print("==============================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        Status = response['data']["data"][0]['Status'];

      }
    }

    update();
  }


}
