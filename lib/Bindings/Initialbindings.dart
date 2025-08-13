import 'package:Silaaty/controller/auth/Logincontroller.dart';
import 'package:Silaaty/core/class/Crud.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:get/get.dart';

class Initialbindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(Myservices());
    Get.lazyPut(() => Logincontroller(), fenix: true);
    // Get.lazyPut(() => Additemscontroller(), fenix: true);
    // Get.lazyPut(() => HomescreencontrollerImp());
    // Get.lazyPut(() => Homecontroller());

  }
}
