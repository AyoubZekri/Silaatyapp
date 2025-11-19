import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/controller/Setteng/ProfaileController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Setteng/custemCartButton.dart';

class Profailedata extends StatelessWidget {
  const Profailedata({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    Profailecontroller controller = Get.put(Profailecontroller());

    return Scaffold(
      backgroundColor: AppColor.primarycolor,
      appBar: AppBar(
        title: Text(
          'Profaile'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
        elevation: 0,
      ),
      body: GetBuilder<Profailecontroller>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColor.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Custemcartbutton(
                        ontap: () => controller.GotoStok(),
                        Title: 'المخزون'.tr,
                        iconData: Icons.inventory_2_outlined,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoNecessary(),
                        Title: 'Necessary'.tr,
                        iconData: Icons.local_mall_outlined,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoDealer(),
                        Title: "Dealer".tr,
                        iconData: Icons.business_center_outlined,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoConvicts(),
                        Title: "Convicts".tr,
                        iconData: Icons.receipt_long_outlined,
                      ),
                      Custemcartbutton(
                        Title: "Categoris".tr,
                        iconData: Icons.category_outlined,
                        ontap: () => controller.Gotocat(),
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoNotification(),
                        Title: "Notification".tr,
                        iconData: Icons.notifications_outlined,
                      ),
                      // Custemcartbutton(
                      //   ontap: () => controller.GotoZakat(),
                      //   Title: "Zakat".tr,
                      //   iconData: Icons.account_balance_outlined,
                      // ),
                      Custemcartbutton(
                        ontap: () => controller.GotoReport(),
                        Title: "Report".tr,
                        iconData: Icons.feedback_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
