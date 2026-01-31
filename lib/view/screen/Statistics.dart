import 'package:Silaaty/data/model/ChartPointModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/HomeScreen/StatisticsController.dart';
import '../../core/constant/Colorapp.dart';
import '../widget/Setteng/custemCartButton.dart';
import '../widget/Statistics/CustemTypeStatistice.dart';
import '../widget/Statistics/CustomCurve.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    Statisticecontroller controller = Get.put(Statisticecontroller());
    final spots = (controller.chartData.isNotEmpty &&
            controller.chartData.first.chart.isNotEmpty)
        ? controller.chartData.first.chart.map((e) => e.toFlSpot()).toList()
        : [FlSpot(0, 0)];

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'Statistics'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: GetBuilder<Statisticecontroller>(builder: (_) {
            return Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("مقاييس الأداء".tr),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Wrap(
                        runSpacing: 10,
                        children: [
                          Custemtypestatistice(
                            onPressed: () {
                              controller.switchTypeStatistice(1);
                            },
                            activte: controller.StatisticeType == 1,
                            title: "يوم".tr,
                          ),
                          Custemtypestatistice(
                            onPressed: () {
                              controller.switchTypeStatistice(2);
                            },
                            activte: controller.StatisticeType == 2,
                            title: "أسبوع".tr,
                          ),
                          Custemtypestatistice(
                            onPressed: () {
                              controller.switchTypeStatistice(3);
                            },
                            activte: controller.StatisticeType == 3,
                            title: "شهر".tr,
                          ),
                          Custemtypestatistice(
                            onPressed: () {
                              controller.switchTypeStatistice(4);
                            },
                            activte: controller.StatisticeType == 4,
                            title: "سنة".tr,
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomCurve(
                  period: controller.StatisticeType == 1
                      ? 'day'
                      : controller.StatisticeType == 2
                          ? 'week'
                          : controller.StatisticeType == 3
                              ? 'month'
                              : 'year',
                  spots: controller.chartData.isNotEmpty
                      ? controller.chartData.first.chart
                          .map((e) => e.toFlSpot())
                          .toList()
                      : spots,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 10, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("إجمالي المبيعات".tr),
                          Text(
                            truncateWithDots(
                                controller.currentStats?.totalSales
                                        .toStringAsFixed(2)
                                        .toString() ??
                                    "0.0",
                                13),
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("الأرباح".tr),
                          Text(
                            truncateWithDots(
                                controller.currentStats?.totalProfit
                                        .toStringAsFixed(2)
                                        .toString() ??
                                    "0.0",
                                13),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("المصروفات".tr),
                          Text(
                            truncateWithDots(
                                controller.currentStats?.totalExpenses
                                        .toStringAsFixed(2)
                                        .toString() ??
                                    "0.0",
                                13),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 30,
                ),
                Custemcartbutton(
                  ontap: () {
                    controller.gotoStatisticeReports();
                  },
                  Title: "Reports".tr,
                  iconData: Icons.analytics,
                ),
              ],
            );
          })),
    );
  }
}

String truncateWithDots(String text, int maxChars) {
  if (text.length <= maxChars) return text;
  return text.substring(0, maxChars) + '...';
}
