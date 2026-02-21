import 'package:Silaaty/core/constant/routes.dart';
import 'package:get/get.dart';

import '../../core/services/Services.dart';
import '../../data/datasource/Remote/StatisticsData.dart';
import '../../data/model/ChartPointModel.dart';

class Statisticecontroller extends GetxController {
  int StatisticeType = 1;
  Statisticsdata statisticsdata = Statisticsdata();
  List<ChartStats> chartData = [];
  Stats? currentStats;

  switchTypeStatistice(int index) {
    StatisticeType = index;
    loadChartData();
    update();
  }

  gotoStatisticeReports() {
    Get.toNamed(Approutes.statisticereports);
  }

  loadChartData() async {
    try {
      update();
      var result = await statisticsdata.getChartStats(StatisticeType);
      print("===============get Statistics==================$result");

      if (result.isNotEmpty) {
        chartData = result
            .map<ChartStats>((json) => ChartStats.fromJson(json))
            .toList();
        currentStats = chartData.first.stats;
      }
    } catch (e) {
      print("===============Error get Statistics===================$e");
    }
    update();
  }

  Future<void> reloadStats() async {
    await loadChartData();
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
