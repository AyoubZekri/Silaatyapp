import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/controller/items/Edititemcontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemDropDownField.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromQuntety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';
import '../../../core/functions/Snacpar.dart';
import '../../../core/functions/valiedinput.dart';

class Edititem extends StatefulWidget {
  const Edititem({super.key});

  @override
  State<Edititem> createState() => _EdititemState();
}

class _EdititemState extends State<Edititem> {
  @override
  void initState() {
    super.initState();
    Get.put(Edititemcontroller());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Edit Prodact'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: GetBuilder<Edititemcontroller>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Form(
            key: controller.formstate,
            child: HandlingviewAuth(
              statusrequest: controller.statusrequest,
              widget: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppColor.primarycolor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2),
                        ),
                        child: controller.file == null
                            ? MaterialButton(
                                onPressed: () {
                                  controller.imageupload();
                                },
                                child: Text("اضافة صورة".tr),
                              )
                            : Stack(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: controller.file != null
                                            ? Image.file(
                                                controller.file!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                "${Applink.image}/storage/${controller.imageUrl}",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.white),
                                      onPressed: () {
                                        controller.imageupload();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      CustemDropDownField(
                        hintText: "Category".tr,
                        items: controller.categories
                            .map((cat) => DropdownMenuItem<int>(
                                  value: cat.id,
                                  child: Text(cat.categorisName ?? ''),
                                ))
                            .toList(),
                        value: controller.selectedtypeId,
                        onChanged: (val) {
                          setState(() {
                            if (val == null) {
                              showSnackbar(
                                  "خطا", "يجب إختيار الفئة أولا", Colors.red);
                              return;
                            }

                            controller.selectedtypeId = val;
                          });
                        },
                      ),
                      // CustemDropDownField(
                      //   hintText: "Category".tr,
                      //   items: [
                      //     DropdownMenuItem<int>(
                      //       value: 1,
                      //       child: Text(Get.locale?.languageCode == 'ar'
                      //           ? 'سلع'
                      //           : 'Prodacts'),
                      //     ),
                      //     DropdownMenuItem<int>(
                      //       value: 2,
                      //       child: Text(Get.locale?.languageCode == 'ar'
                      //           ? 'ضرورياب'
                      //           : 'Necessary'),
                      //     ),
                      //   ],
                      //   value: controller.selectedtypeId,
                      //   onChanged: (val) {
                      //     setState(() {
                      //       controller.selectedCategoryId = val;

                      //       if (val == 1) {
                      //         controller.selectedCategoryId = 1;
                      //       } else if (val == 2) {
                      //         controller.selectedCategoryId = 2;
                      //       }
                      //     });
                      //   },
                      // ),
                      Custemtextfromfild(
                        MyController: controller.nameController,
                        keyboardType: TextInputType.name,
                        hintText: "Name Prodact".tr,
                        label: "Name Prodact".tr,
                        iconData: Icons.shopping_bag,
                      ),
                      // Custemtextfromfild(
                      //     MyController: controller.descriptionController,
                      //     keyboardType: TextInputType.name,
                      //     hintText: "Description".tr,
                      //     label: "Description".tr,
                      //     iconData: Icons.description,
                      //     valid: (val) {
                      //       validInput(val!, 20, 300, "username");
                      //       return null;
                      //     }),
                      QuantityInput(
                        initialValue:
                            int.tryParse(controller.quantityController.text) ??
                                1,
                        Mycontroller: controller.quantityController,
                        hintText: "Quantity".tr,
                        label: "Quantity".tr,
                        onChanged: controller.onQuantityChanged,
                      ),
                      Custemtextfromfild(
                        MyController: controller.priseController,
                        keyboardType: TextInputType.number,
                        hintText: "Selling Price".tr,
                        label: "Selling Prise".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custemtextfromfild(
                        MyController: controller.pricePurchaseController,
                        keyboardType: TextInputType.number,
                        hintText: "Purchase Price".tr,
                        label: "Purchase Prise".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custemtextfromfild(
                        MyController: TextEditingController(
                            text: controller.priceTotalPurchase
                                .toStringAsFixed(2)),
                        keyboardType: TextInputType.number,
                        hintText: "Purchase Price Total".tr,
                        label: "Purchase Prise Total".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custemtextfromfild(
                        MyController: TextEditingController(
                            text: controller.priceTotal.toStringAsFixed(2)),
                        keyboardType: TextInputType.number,
                        hintText: "Selling Prise Total".tr,
                        label: "Selling Prise Total".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custembutton(
                        text: "Edit".tr,
                        onPressed: () {
                          if (!validInputsnak(controller.nameController.text, 1,
                              20, "Name".tr)) {
                            return;
                          }

                          controller.EditProduct();
                        },
                        vertical: 10,
                        horizontal: 10,
                        paddingvertical: 15,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
