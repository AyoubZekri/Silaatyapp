import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:get/get.dart';

class Profailecontroller extends GetxController {


  GotoSetting() {
    Get.toNamed(Approutes.Setteng);
  }

  Gotocat() {
    Get.toNamed(Approutes.shwocat);
  }

  GotoNotification() {
    Get.toNamed(Approutes.notification);
  }

  // GotoZakat() {
  //   Get.toNamed(Approutes.Zakat);
  // }

  GotoDealer() {
    Get.toNamed(Approutes.Dealer, arguments: {
      "type": 1,
    });
  }

  GotoNecessary() {
    Get.toNamed(Approutes.necessary);
  }

  GotoStok() {
    Get.toNamed(Approutes.item);
  }

  GotoReport() {
    Get.toNamed(Approutes.report);
  }

  GotoConvicts() {
    Get.toNamed(Approutes.Convicts, arguments: {
      "type": 2,
    });
  }

  String? name = Get.find<Myservices>().sharedPreferences?.getString("name");
  String? email = Get.find<Myservices>().sharedPreferences?.getString("email");
}
