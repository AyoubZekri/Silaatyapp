import 'package:Silaaty/controller/Statistice/CustomerSalesController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Statistics/CustomApparr.dart';
import '../../widget/Statistics/CustomStatCard.dart';
import '../../widget/Statistics/Customcard.dart';

class Customersales extends StatefulWidget {
  const Customersales({super.key});

  @override
  State<Customersales> createState() => _CustomersalesState();
}

class _CustomersalesState extends State<Customersales> {
  @override
  Widget build(BuildContext context) {
    Customersalescontroller controller = Get.put(Customersalescontroller());
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'مبيعات العملاء'.tr,
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
          child: GetBuilder<Customersalescontroller>(builder: (_) {
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
                          iconData: FontAwesomeIcons.moneyBillWave,
                          Price: controller.data?.summary?.totalSold
                                  .toStringAsFixed(2)
                                  .toString() ??
                              "0.0",
                          Title: "المبيعات".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.blue,
                          iconData: FontAwesomeIcons.coins,
                          Price: controller.data?.summary?.totalDebts
                                  .toStringAsFixed(2)
                                  .toString() ??
                              "0.0",
                          Title: "الديون".tr,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Costumtitlepayment(
                  iconData: FontAwesomeIcons.user,
                  title: "تقارير مبيعات العملاء".tr,
                ),
                Customapparr(
                  period: "العميل".tr,
                  revenue: "المبيعات".tr,
                  profit: "الديون".tr,
                ),
                SizedBox(
                  height: Get.width,
                  child: ListView.builder(
                      itemCount: controller.data?.transactionsDetails?.length,
                      itemBuilder: (context, index) {
                        final trn =
                            controller.data?.transactionsDetails?[index];
                        return FinanceDetailRow(
                          animated: true,
                          period: '${trn?.familyName} ${trn?.name}',
                          revenue:
                              trn?.totalSold.toStringAsFixed(1).toString() ??
                                  "0.0",
                          profit:
                              trn?.debts.toStringAsFixed(1).toString() ?? "0.0",
                          profit2: "",
                          totalSales: trn?.totalInvoices.toString() ?? "0",
                          expenses: trn?.averageOrderValue
                                  .toStringAsFixed(2)
                                  .toString() ??
                              "0.0",
                          itemsSold: trn?.totalDiscount
                                  .toStringAsFixed(2)
                                  .toString() ??
                              "0.0",
                          profitRate: "",
                          labelTotalSales: "إجمالي الفواتير".tr,
                          labelExpenses: "متوسط الطلب".tr,
                          labelItemsSold: "الخصومات".tr,
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
