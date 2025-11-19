import 'package:Silaaty/controller/Statistice/LowStockController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Statistics/CustomApparr.dart';
import '../../widget/Statistics/CustomStatCard.dart';

class Lowstock extends StatefulWidget {
  const Lowstock({super.key});

  @override
  State<Lowstock> createState() => _LowstockState();
}

class _LowstockState extends State<Lowstock> {
  @override
  Widget build(BuildContext context) {
    Lowstockcontroller controller = Get.put(Lowstockcontroller());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "المخزون المنخفظ".tr,
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
          child: GetBuilder<Lowstockcontroller>(builder: (_) {
            return ListView(
              children: [
                Costumtitlepayment(
                  iconData: Icons.warning_amber_rounded,
                  title: "العناصر منخفضة المخزون".tr,
                ),
                Customapparr(
                  period: "المنتج".tr,
                  revenue: "",
                  profit: "كمية المنتج".tr,
                ),
                SizedBox(
                  height: Get.width,
                  child: ListView.builder(
                      itemCount: controller.data?.products?.length,
                      itemBuilder: (context, index) {
                        final item = controller.data?.products?[index];
                        return InkWell(
                          onTap: () {
                            controller.gotoditailsitems(item!.uuid);
                          },
                          child: FinanceDetailRow(
                            animated: false,
                            labelTotalSales: "",
                            labelExpenses: "",
                            labelItemsSold: "",
                            labelProfit: "",
                            labelProfitRate: "",
                            period: item?.name.toString() ?? "",
                            revenue: "",
                            profit: item?.quantity.toString() ?? "",
                            profit2: "",
                            totalSales: "",
                            expenses: "",
                            itemsSold: "",
                            profitRate: "",
                          ),
                        );
                      }),
                )
              ],
            );
          })),
    );
  }
}
