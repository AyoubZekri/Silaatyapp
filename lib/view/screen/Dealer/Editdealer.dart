import 'package:Silaaty/controller/Profaile/transaction/Edittransactioncontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';

class EditDealer extends StatefulWidget {
  const EditDealer({super.key});

  @override
  State<EditDealer> createState() => _EditDealerState();
}

class _EditDealerState extends State<EditDealer> {
  EditTransactionController controller = Get.put(EditTransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Edit Dealer'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Form(
            key: controller.formKey,
            child: GetBuilder<EditTransactionController>(builder: (controller) {
              return HandlingviewAuth(
                statusrequest: controller.statusrequest,
                widget: ListView(
                  children: [
                    Column(
                      children: [
                        Custemtextfromfild(
                          MyController: controller.nameController,
                          keyboardType: TextInputType.name,
                          hintText: "Name".tr,
                          label: "Name".tr,
                          iconData: Icons.person_outline,
                          enabled: true,
                        ),
                        Custemtextfromfild(
                          MyController: controller.familyNameController,
                          keyboardType: TextInputType.name,
                          hintText: "FrsetName".tr,
                          label: "FrsetName".tr,
                          iconData: Icons.family_restroom,
                          enabled: true,
                        ),
                        Custemtextfromfild(
                          MyController: controller.phoneController,
                          keyboardType: TextInputType.name,
                          hintText: "Phone Numper".tr,
                          label: "Phone Numper".tr,
                          iconData: Icons.phone_outlined,
                          enabled: true,
                        ),
                        Custembutton(
                          text: "Edit".tr,
                          onPressed: () {
                            if (!validInputsnak(controller.nameController.text,
                                1, 10, "Name".tr)) {
                              return;
                            }
                            if (!validInputsnak(
                                controller.familyNameController.text,
                                1,
                                10,
                                "FrsetName".tr)) {
                              return;
                            }
                            if (!validInputsnak(controller.phoneController.text,
                                10, 12, "Phone Numper".tr)) {
                              return;
                            }
                            controller.editTransaction();
                          },
                          vertical: 10,
                          horizontal: 10,
                          paddingvertical: 15,
                        )
                      ],
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}
