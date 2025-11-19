import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/data/datasource/Remote/StatisticsData.dart';
import 'package:Silaaty/data/model/StatisticHomeModel.dart';
import 'package:get/get.dart';

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

    super.onInit();
  }
}
