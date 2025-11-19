import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/Statistice/StockValueController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Statistics/CustomApparr.dart';
import '../../widget/Statistics/CustomStatCard.dart';
import '../../widget/Statistics/Customcard.dart';

class Stockvalue extends StatefulWidget {
  const Stockvalue({super.key});

  @override
  State<Stockvalue> createState() => _StockvalueState();
}

class _StockvalueState extends State<Stockvalue> {
  @override
  Widget build(BuildContext context) {
    Stockvaluecontroller controller = Get.put(Stockvaluecontroller());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'قيمة المخزون'.tr,
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
          child: GetBuilder<Stockvaluecontroller>(builder: (_) {
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
                          Price:
                              controller.data?.summary?.totalStart.toString() ??
                                  "0.0",
                          Title: "افتتاحي".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.grey,
                          iconData: FontAwesomeIcons.box,
                          Price:
                              controller.data?.summary?.totalEnd.toString() ??
                                "0.0",
                          Title: "ختامي".tr,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Custemcard(
                          color: Colors.red,
                          iconData: FontAwesomeIcons.cartShopping,
                          Price:
                              controller.data?.summary?.totalSold.toString() ??
                                  "0.0",
                          Title: "المباعة".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.blue,
                          iconData: FontAwesomeIcons.truckRampBox,
                          Price: controller.data?.summary?.totalIn.toString() ??
                              "0.0",
                          Title: "الواردة".tr,
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
                  profit: "قيمة الختامية".tr,
                ),
                SizedBox(
                  height: Get.width,
                  child: ListView.builder(
                      itemCount: controller.data?.productsBalance?.length,
                      itemBuilder: (context, index) {
                        final item = controller.data?.productsBalance?[index];
                        return FinanceDetailRow(
                          animated: true,
                          period: item?.productName ?? "",
                          revenue: "",
                          profit: item?.endsubtotal.toString() ?? "",
                          profit2: "",
                          totalSales: item?.startsubtotal.toString() ?? "",
                          expenses: item?.soldsubtotal.toString() ?? "",
                          itemsSold: item?.insubtotal.toString() ?? "",
                          profitRate: "",
                          labelTotalSales: "إفتتاحي".tr,
                          labelExpenses: "المباعة".tr,
                          labelItemsSold: "الواردة".tr,
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
