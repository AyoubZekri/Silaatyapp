import 'package:Silaaty/view/widget/Home/CustemTitle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controller/HomeScreen/HomeController.dart';
import '../../core/constant/Colorapp.dart';
import '../widget/Home/CustemCard.dart';
import '../widget/Home/CustemcartAbbreviation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Homecontroller controller = Get.put(Homecontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'Home'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: GetBuilder<Homecontroller>(builder: (_) {
        return Container(
          padding: const EdgeInsets.all(10),
          color: AppColor.white,
          child: ListView(
            children: [
              Custemtitle(title: "إحصائيات اليوم".tr),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    children: [
                      Custemcard(
                        color: Colors.green,
                        iconData: FontAwesomeIcons.sackDollar,
                        Price:
                            controller.statisticsHome?.todayIncome.toString() ??
                                "0,0",
                        Title: "المبيعات".tr,
                      ),
                      const SizedBox(width: 10),
                      Custemcard(
                        color: Colors.blue,
                        iconData: FontAwesomeIcons.cartShopping,
                        Price: controller.statisticsHome?.todayInvoices
                                .toString() ??
                            "0",
                        Title: "عدد المبيعات".tr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Custemcard(
                        color: Colors.grey,
                        iconData: FontAwesomeIcons.moneyBillWave,
                        Price: controller.statisticsHome?.todayNetProfit
                                .toString() ??
                            "0,0",
                        Title: "صافي الربح".tr,
                      ),
                      const SizedBox(width: 10),
                      Custemcard(
                        color: Colors.orange,
                        iconData: FontAwesomeIcons.triangleExclamation,
                        Price: controller.statisticsHome?.lowStockCount
                                .toString() ??
                            "0",
                        Title: "مخزون منخفض".tr,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Custemtitle(title: "اختصارات".tr),
              const SizedBox(height: 20),
              Row(
                children: [
                  Custemcartabbreviation(
                    onTap: () {
                      controller.gotoNewSale();
                    },
                    iconData: Icons.shopping_cart_outlined,
                    title: "بيع جديد".tr,
                  ),
                  const SizedBox(width: 15),
                  Custemcartabbreviation(
                    onTap: () {
                      controller.gotoAddclients();
                    },
                    iconData: Icons.person_add,
                    title: "عميل جديد".tr,
                  ),
                  const SizedBox(width: 15),
                  Custemcartabbreviation(
                    onTap: () {
                      controller.gotoAddproduct();
                    },
                    iconData: Icons.add_box,
                    title: "إضافة منتج".tr,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Custemtitle(title: "الإدارة والتحكم".tr),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Custemcartabbreviation(
                      onTap: () {
                        controller.gotoproduct();
                      },
                      iconData: Icons.inventory_2_outlined,
                      title: "المخزون".tr,
                    ),
                    const SizedBox(width: 15),
                    Custemcartabbreviation(
                      onTap: () {
                        controller.gotoclients();
                      },
                      iconData: Icons.people_alt_outlined,
                      title: "العملاء".tr,
                    ),
                    const SizedBox(width: 15),
                    Custemcartabbreviation(
                      onTap: () {
                        controller.gotoInvoicesall();
                      },
                      iconData: Icons.receipt_long_outlined,
                      title: "الفواتير".tr,
                    ),
                    const SizedBox(width: 15),
                    Custemcartabbreviation(
                      onTap: () {
                        controller.gotoLowStoke();
                      },
                      iconData: FontAwesomeIcons.triangleExclamation,
                      title: "مخزون منخفض".tr,
                    ),
                    const SizedBox(width: 15),
                    Custemcartabbreviation(
                      onTap: () {
                        controller.gotoMore();
                      },
                      iconData: Icons.dashboard_customize_outlined,
                      title: "المزيد".tr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
