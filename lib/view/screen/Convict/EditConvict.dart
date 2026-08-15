import 'package:Silaaty/controller/Profaile/transaction/Edittransactioncontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:Silaaty/view/widget/addItem/CustemDropDownField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/Statusrequest.dart';
import '../../../core/class/handlingview.dart';

class EditConvict extends StatefulWidget {
  const EditConvict({super.key});

  @override
  State<EditConvict> createState() => _EditConvictState();
}

class _EditConvictState extends State<EditConvict> {
  EditTransactionController controller = Get.put(EditTransactionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Edit Convict'.tr,
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
              return ListView(
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
                          enabled: true,
                          MyController: controller.phoneController,
                          keyboardType: TextInputType.name,
                          hintText: "Phone Numper".tr,
                          label: "Phone Numper".tr,
                          iconData: Icons.phone_outlined,
                        ),
                        CustemDropDownField(
                          hintText: "نوع البيع".tr,
                          items: [
                            DropdownMenuItem(value: 1, child: Text("تجزئة".tr)),
                            if (controller.sellType >= 2)
                              DropdownMenuItem(value: 2, child: Text("نصف جملة".tr)),
                            if (controller.sellType >= 3)
                              DropdownMenuItem(value: 3, child: Text("جملة".tr)),
                          ],
                          value: controller.customerSaleType,
                          onChanged: (val) {
                            setState(() {
                              if (val != null) controller.customerSaleType = val;
                            });
                          },
                        ),
                        Custemtextfromfild(
                          MyController: controller.notesController,
                          keyboardType: TextInputType.text,
                          hintText: "ملاحظات".tr,
                          label: "ملاحظات".tr,
                          iconData: Icons.note,
                          enabled: true,
                        ),
                        Custembutton(
                          text: "Edit".tr,
                          isLoading: controller.statusrequest == Statusrequest.loadeng,
                          onPressed: () {
                            if (!validInputsnak(controller.nameController.text,
                                1, 1000, "Name".tr)) {
                              return;
                            }
                            if (!validInputsnak(
                                controller.familyNameController.text,
                                0,
                                1000,
                                "FrsetName".tr,
                              empty: false)) {
                              return;
                            }
                            if (!validInputsnak(controller.phoneController.text,
                                1, 1000, "Phone Numper".tr)) {
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
              );
            })),
      ),
    );
  }
}
