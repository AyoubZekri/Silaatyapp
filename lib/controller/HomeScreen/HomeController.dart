import 'package:Silaaty/controller/StartpageContrller.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/StatisticsData.dart';
import 'package:Silaaty/data/model/StatisticHomeModel.dart';
import 'package:get/get.dart';

import '../../core/class/SyncServer.dart';
import '../../core/services/Services.dart';

class Homecontroller extends GetxController {
  Statisticsdata statisticsdata = Statisticsdata();
  Statusrequest staticrequest = Statusrequest.none;
  StatisticsHomeModel? statisticsHome;

  gotoAddclients() {
    Get.toNamed(Approutes.AddConvict);
  }

  gotoclients() {
    Get.toNamed(Approutes.Convicts, arguments: {
      "type": 2,
    });
  }

  gotoAddproduct() {
    Get.toNamed(Approutes.Additem);
  }

  gotoproduct() {
    Get.toNamed(Approutes.item);
  }

  gotoInvoicesall() {
    Get.toNamed(Approutes.invoicesall);
  }

  gotoLowStoke() {
    Get.toNamed(Approutes.lowstock);
  }

  gotoNewSale() {
    Get.toNamed(Approutes.newSale);
  }

  gotoMore() {
    Get.toNamed(Approutes.profailedata);
  }

  getstatistics() async {
    try {
      update();
      var result = await statisticsdata.statisticsHome();
      print("===============get Statistics==================$result");

      if (result.isNotEmpty) {
        statisticsHome = StatisticsHomeModel.fromJson(result);
        staticrequest = Statusrequest.success;
      }
    } catch (e) {
      print("===============Error get Statistics===================$e");
      staticrequest = Statusrequest.serverfailure;
    }
    update();
  }

  Future<void> _handleLoginSync() async {
    try {
      final sync = SyncService();

      final startController = Get.find<Startpagecontrller>();
      await startController.getUser();

      await sync.syncAll();

      // print("=============");
      // getstatistics();
      // print("=============");
    } catch (e, s) {
      print("❌ خطأ أثناء المزامنة بعد تسجيل الدخول");
      print(e);
      print(s);
    }
  }

  Future<void> reloadStats() async {
    await getstatistics();
    update();
  }

  @override
  void onInit() {
    final refreshService = Get.find<RefreshService>();
    ever(refreshService.refreshTrigger, (_) {
      reloadStats();
    });
    Get.find<RefreshService>().fire();

    final args = Get.arguments;
    final fromLogin = args != null && args['fromlogin'] == 1;

    if (fromLogin) {
      _handleLoginSync();
    }

    super.onInit();
  }
}
