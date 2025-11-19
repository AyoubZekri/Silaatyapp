import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/Statistice/PublicFinanceController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Statistics/CustomApparr.dart';
import '../../widget/Statistics/CustomStatCard.dart';
import '../../widget/Statistics/Customcard.dart';

class Publicfinance extends StatefulWidget {
  const Publicfinance({super.key});

  @override
  State<Publicfinance> createState() => _PublicfinanceState();
}

class _PublicfinanceState extends State<Publicfinance> {
  @override
  Widget build(BuildContext context) {
    Publicfinancecontroller controller = Get.put(Publicfinancecontroller());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'نضرة مالية عامة'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          child: GetBuilder<Publicfinancecontroller>(builder: (_) {
            return ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                      "${controller.datefilter(controller.data?.summary?.datestart.toString() ?? "")} - ${controller.datefilter(controller.data?.summary?.dateend.toString() ?? "")}"),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Custemcard(
                          color: Colors.grey,
                          iconData: FontAwesomeIcons.fileInvoiceDollar,
                          Price: controller.data?.summary?.totalInvoices
                                  .toString() ??
                              "0",
                          Title: "عدد الفواتير".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.green,
                          iconData: FontAwesomeIcons.coins,
                          Price: (controller.data?.summary?.netProfit ?? 0) < 0
                              ? "0"
                              : controller.data?.summary?.netProfit
                                      .toString() ??
                                  "0",
                          Title: "صافي الربح".tr,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Custemcard(
                          color: Colors.red,
                          iconData: FontAwesomeIcons.moneyBillWave,
                          Price: controller.data?.summary?.totalExpenses
                                  .toString() ??
                              "0.0",
                          Title: "المصروفات".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.blue,
                          iconData: FontAwesomeIcons.sackDollar,
                          Price: controller.data?.summary?.totalRevenue
                                  .toString() ??
                              "0.0",
                          Title: "الإرادات".tr,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Costumtitlepayment(
                  iconData: FontAwesomeIcons.alignJustify,
                  title: "تفاصيل المالية".tr,
                ),
                Customapparr(
                  period: "الفترة".tr,
                  revenue: "صافي الربح".tr,
                  profit: "الإرادات".tr,
                ),
                SizedBox(
                  height: Get.width * 1,
                  child: ListView.builder(
                      itemCount: controller.data?.details?.length ?? 0,
                      itemBuilder: (context, index) {
                        final detils = controller.data!.details?[index];
                        return FinanceDetailRow(
                          animated: true,
                          period:
                              controller.formatSmartDate(detils?.period ?? ""),
                          revenue: detils?.revenue.toString() ?? "",
                          profit: (detils?.netProfit ?? 0) < 0
                              ? "0"
                              : detils?.netProfit.toString() ?? "",
                          profit2: detils?.netProfit.toString() ?? "",
                          totalSales: detils?.totalSales.toString() ?? "",
                          expenses: detils?.expenses.toString() ?? "",
                          itemsSold: detils?.itemsSold.toString() ?? "",
                          profitRate: "${detils?.profitRate.toString() ?? ""}%",
                          labelTotalSales: "Total Sales".tr,
                          labelExpenses: "Expenses".tr,
                          labelItemsSold: "Items Sold".tr,
                          labelProfit: "Net Profit".tr,
                          labelProfitRate: "Profit Rate".tr,
                        );
                      }),
                )
              ],
            );
          })),
    );
  }
}
