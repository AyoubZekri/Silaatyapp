import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:get/get.dart';
import '../core/class/SyncServer.dart';
import 'StartpageContrller.dart';

abstract class HomesallerController extends GetxController {
  logout();
}

class HomesallerControllerImp extends HomesallerController {
  Myservices myServices = Get.find();
  Future<void> _handleLoginSync() async {
    try {
      final sync = SyncService();

      final startController = Get.find<Startpagecontrller>();
      await startController.getUser();

      await sync.syncAll();
    } catch (e, s) {
      print("❌ خطأ أثناء المزامنة بعد تسجيل الدخول");
      print(e);
      print(s);
    }
  }

  @override
  logout() {
    Get.defaultDialog(
      title: "تنبيه".tr,
      middleText: "هل أنت متأكد من تسجيل الخروج؟".tr,
      onConfirm: () {
        myServices.sharedPreferences!.clear();
        Get.offAllNamed(Approutes.Login);
      },
      onCancel: () {},
      textConfirm: "نعم".tr,
      textCancel: "لا".tr,
    );
  }

  @override
  void onInit() {
    final args = Get.arguments;
    final fromLogin = args != null && args['fromlogin'] == 1;

    if (fromLogin) {
      _handleLoginSync();
    }

    super.onInit();
  }
}
