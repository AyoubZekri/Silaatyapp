import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/controller/Setteng/ProfaileController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/view/widget/Setteng/custemCartButton.dart';

class Profailedata extends StatelessWidget {
  const Profailedata({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Profailecontroller controller = Get.put(Profailecontroller());

    return Scaffold(
      backgroundColor: AppColor.primarycolor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30),
          onPressed: () => controller.GotoSetting(),
        ),
        title: Text(
          'Profaile'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: GetBuilder<Profailecontroller>(builder: (controller) {
        return Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth * 0.3,
              height: screenWidth * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.4, color: AppColor.grey),
                image: const DecorationImage(
                  image: AssetImage(Appimageassets.avater),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              controller.name ?? "",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            Text(
              controller.email ?? "",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: AppColor.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Custemcartbutton(
                        ontap: () => controller.GotoNecessary(),
                        Title: 'Necessary'.tr,
                        iconData: Icons.local_mall,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoDealer(),
                        Title: "Dealer".tr,
                        iconData: Icons.business_center,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoConvicts(),
                        Title: "Convicts".tr,
                        iconData: Icons.receipt_long,
                      ),
                      Custemcartbutton(
                        Title: "Settings and Privacy".tr,
                        iconData: Icons.person,
                        ontap: () => controller.GotoProfaile(),
                      ),
                      Custemcartbutton(
                        Title: "Categoris".tr,
                        iconData: Icons.category,
                        ontap: () => controller.Gotocat(),
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoNotification(),
                        Title: "Notification".tr,
                        iconData: Icons.notifications,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoZakat(),
                        Title: "Zakat".tr,
                        iconData: Icons.account_balance,
                      ),
                      Custemcartbutton(
                        ontap: () => controller.GotoReport(),
                        Title: "Report".tr,
                        iconData: Icons.feedback,
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
