import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Setteng/ProfailController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/imageassets.DART';
import '../../widget/Profail/Customditails.dart';
import '../../widget/Setteng/custemCartButton.dart';

class Profail extends StatefulWidget {
  const Profail({super.key});

  @override
  State<Profail> createState() => _ProfailState();
}

class _ProfailState extends State<Profail> {
  @override
  Widget build(BuildContext context) {
    Profailcontroller controller = Get.put(Profailcontroller());
    return Scaffold(
        backgroundColor: AppColor.white,
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
        ),
        body: GetBuilder<Profailcontroller>(builder: (_) {
          return Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: Get.width - 20,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.02),
                        Container(
                          width: Get.width * 0.3,
                          height: Get.width * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 0.4, color: AppColor.grey),
                            image: DecorationImage(
                              image: controller.logoFile != null
                                  ? FileImage(controller.logoFile!)
                                      as ImageProvider
                                  : const AssetImage(Appimageassets.test2),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.015),
                        Text(
                          controller.name ?? "",
                          style: TextStyle(
                            fontSize: Get.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        Text(
                          controller.email ?? "",
                          style: TextStyle(
                            fontSize: Get.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppColor.grey,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Customditails(
                                Title: "الإشتراك".tr,
                                body: controller.Supscription == 2
                                    ? "Free".tr
                                    : "Paid".tr,
                              ),
                              Container(
                                width: double.infinity,
                                height: 2,
                                color: Colors.grey[300],
                              ),
                              Customditails(
                                Title: "ينتهي في ".tr,
                                body: controller.Supscription == 2
                                    ? controller.dateexperiment!
                                        .substring(0, 10)
                                    : "وصول دائم للتطبيق".tr,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Custemcartbutton(
                  ontap: () {
                    controller.gotoprofaileedit();
                  },
                  Title: "إعدادات المتجر".tr,
                  iconData: Icons.store,
                ),
              ],
            ),
          );
        }));
  }
}
