import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/Statistice/StockValueController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/FormatQuantity.dart';
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
                          Price: formatQuantity(controller.data?.summary?.totalStart ?? 0),
                          Title: "افتتاحي".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.grey,
                          iconData: FontAwesomeIcons.box,
                          Price: formatQuantity(controller.data?.summary?.totalEnd ?? 0),
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
                          Price: formatQuantity(controller.data?.summary?.totalSold ?? 0),
                          Title: "المباعة".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.blue,
                          iconData: FontAwesomeIcons.truckRampBox,
                          Price: formatQuantity(controller.data?.summary?.totalIn ?? 0),
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
                          profit: formatQuantity(item?.endsubtotal ?? 0),
                          profit2: "",
                          totalSales: formatQuantity(item?.startsubtotal ?? 0),
                          expenses: formatQuantity(item?.soldsubtotal ?? 0),
                          itemsSold: formatQuantity(item?.insubtotal ?? 0),
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
