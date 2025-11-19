import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/Statistice/Supplierreportscontroller.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/Statistics/CustomApparr.dart';
import '../../widget/Statistics/CustomStatCard.dart';
import '../../widget/Statistics/Customcard.dart';

class Supplierreports extends StatefulWidget {
  const Supplierreports({super.key});

  @override
  State<Supplierreports> createState() => _SupplierreportsState();
}

class _SupplierreportsState extends State<Supplierreports> {
  @override
  Widget build(BuildContext context) {
    Supplierreportscontroller controller = Get.put(Supplierreportscontroller());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'تقارير الموردون'.tr,
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
          child: GetBuilder<Supplierreportscontroller>(builder: (_) {
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
                          color: Colors.blue,
                          iconData: FontAwesomeIcons.moneyBillWave,
                          Price:
                              controller.data?.summary?.totalSold.toString() ??
                                  "0.0",
                          Title: "الشراء".tr,
                        ),
                        const SizedBox(width: 10),
                        Custemcard(
                          color: Colors.red,
                          iconData: FontAwesomeIcons.coins,
                          Price:
                              controller.data?.summary?.totalDebts.toString() ??
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
                  title: "تقارير مبيعات المودون".tr,
                ),
                Customapparr(
                  period: "المورد".tr,
                  revenue: "إجمالي الشراء".tr,
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
                          revenue: trn?.totalSold.toString() ?? "0.0",
                          profit: trn?.debts.toString() ?? "0.0",
                          profit2: "",
                          totalSales: trn?.totalInvoices.toString() ?? "0",
                          expenses: trn?.averageOrderValue.toString() ?? "0.0",
                          itemsSold: "",
                          profitRate: "",
                          labelTotalSales: "إجمالي الفواتير".tr,
                          labelExpenses: "متوسط الطلب".tr,
                          labelItemsSold: "",
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
