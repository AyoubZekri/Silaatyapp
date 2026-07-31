import 'dart:io';

import 'package:Silaaty/controller/HomesallerController.dart';
import 'package:Silaaty/controller/Setteng/SettengContriller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homesaller extends StatefulWidget {
  const Homesaller({super.key});

  @override
  State<Homesaller> createState() => _HomesallerState();
}

class _HomesallerState extends State<Homesaller> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomesallerControllerImp());
    return GetBuilder<HomesallerControllerImp>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            'الصفحة الرئيسية'.tr,
            style: const TextStyle(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: AppColor.backgroundcolor,
          centerTitle: true,
          elevation: 8,
          shadowColor: AppColor.backgroundcolor.withOpacity(0.5),
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () {
            Get.defaultDialog(
              backgroundColor: AppColor.white,
              title: "تنبيه".tr,
              titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColor.backgroundcolor),
              middleText: "هل تريد الخروج من التطبيق".tr,
              onConfirm: () {
                exit(0);
              },
              onCancel: () {
                Get.back();
              },
              buttonColor: AppColor.backgroundcolor,
              confirmTextColor: AppColor.primarycolor,
              cancelTextColor: AppColor.backgroundcolor,
            );
            return Future.value(false);
          },
          child: Container(
            color: const Color(0xFFF8F9FB), // خلفية ناعمة جداً
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95, // تعديل الارتفاع ليكون مريح للعين
              children: [
                _buildGridItem(
                  icon: Icons.point_of_sale_rounded,
                  title: "بيع جديد".tr,
                  onTap: () => Get.toNamed(Approutes.newSale),
                ),
                _buildGridItem(
                  icon: Icons.person_add_alt_1_rounded,
                  title: "عميل جديد".tr,
                  onTap: () => Get.toNamed(Approutes.AddConvict),
                ),
                _buildGridItem(
                  icon: Icons.people_alt_rounded,
                  title: "العملاء".tr,
                  onTap: () => Get.toNamed(Approutes.Convicts),
                ),
                _buildGridItem(
                  icon: Icons.receipt_long_rounded,
                  title: "الفواتير".tr,
                  onTap: () => Get.toNamed(Approutes.invoicesall),
                ),
                _buildGridItem(
                  icon: Icons.person_rounded,
                  title: "الملف الشخصي".tr,
                  onTap: () => Get.toNamed(Approutes.profail),
                ),
                _buildGridItem(
                  icon: Icons.print_rounded,
                  title: "Printer Settings".tr,
                  onTap: () {
                    final settengController = Get.put(Settengcontriller());
                    settengController.showPrinterSettingsSheet(context);
                  },
                ),
                _buildGridItem(
                  icon: Icons.language_rounded,
                  title: "اللغة".tr,
                  onTap: () {
                    final settengController = Get.put(Settengcontriller());
                    settengController.showLanguageSheet(context);
                  },
                ),
                _buildGridItem(
                  icon: Icons.logout_rounded,
                  title: "تسجيل الخروج".tr,
                  onTap: () => controller.logout(),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
    ));
  }

  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    Color mainColor =
        isDestructive ? Colors.redAccent : AppColor.backgroundcolor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      splashColor: mainColor.withOpacity(0.1),
      highlightColor: mainColor.withOpacity(0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: mainColor.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
