import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/Statistice/StockBalanceController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Statistics/CustomApparr.dart';
import '../../widget/Statistics/CustomStatCard.dart';
import '../../widget/Statistics/Customcard.dart';

class Stockbalance extends StatefulWidget {
  const Stockbalance({super.key});

  @override
  State<Stockbalance> createState() => _StockbalanceState();
}

class _StockbalanceState extends State<Stockbalance> {
  @override
  Widget build(BuildContext context) {
    Stockbalancecontroller controller = Get.put(Stockbalancecontroller());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'رصيد المخزون'.tr,
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
          child: GetBuilder<Stockbalancecontroller>(builder: (_) {
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
                          color: Colors.green,
                          iconData: FontAwesomeIcons.boxArchive,
                          Price: controller.data?.summary?.totalStart
                                  .toStringAsFixed(0)
                                  .toString() ??
                              "0.0",
                          Title: "كمية اول مدة".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.grey,
                          iconData: FontAwesomeIcons.box,
                          Price: controller.data?.summary?.totalEnd
                                  .toStringAsFixed(0)
                                  .toString() ??
                              "0.0",
                          Title: "كمية اخر مدة".tr,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Custemcard(
                          color: Colors.red,
                          iconData: FontAwesomeIcons.cartShopping,
                          Price: controller.data?.summary?.totalSold
                                  .toStringAsFixed(0)
                                  .toString() ??
                              "0.0",
                          Title: "الكمية المباعة".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.blue,
                          iconData: FontAwesomeIcons.truckRampBox,
                          Price: controller.data?.summary?.totalIn
                                  .toStringAsFixed(0)
                                  .toString() ??
                              "0.0",
                          Title: "الكمية الواردة".tr,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Costumtitlepayment(
                  iconData: FontAwesomeIcons.boxesStacked,
                  title: "المنتجات".tr,
                ),
                Customapparr(
                  period: "المنتج".tr,
                  revenue: "",
                  profit: "الكمية".tr,
                ),
                SizedBox(
                  height: Get.width,
                  child: ListView.builder(
                      itemCount: controller.data?.productsBalance?.length,
                      itemBuilder: (context, index) {
                        final item = controller.data?.productsBalance?[index];
                        return FinanceDetailRow(
                          animated: true,
                          period: item?.productName.toString() ?? "",
                          revenue: "",
                          profit: item?.endQuantity.toString() ?? "",
                          profit2: "",
                          totalSales: item?.startQuantity.toString() ?? "",
                          expenses: item?.soldQuantity.toString() ?? "",
                          itemsSold: item?.inQuantity.toString() ?? "",
                          profitRate: "",
                          labelTotalSales: "كمية اول مدة".tr,
                          labelExpenses: "الكمية المباعة".tr,
                          labelItemsSold: "الكمية الواردة".tr,
                          labelProfit: "",
                          labelProfitRate: "",
                        );
                      }),
                )
              ],
            );
          })),
    );
  }
}
