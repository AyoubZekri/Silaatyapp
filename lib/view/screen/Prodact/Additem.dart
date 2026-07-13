import 'package:Silaaty/controller/items/AdditemsController.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemDropDownField.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromQuntety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Additem extends StatefulWidget {
  const Additem({super.key});

  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(Additemscontroller());
    controller.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Add Prodact'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: GetBuilder<Additemscontroller>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Form(
            key: controller.formstate,
            child: ListView(
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
                                        child: Image.file(
                                          controller.file!,
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
                            .map((cat) => DropdownMenuItem<String>(
                                  value: cat.uuid,
                                  child: Text(Get.locale?.languageCode == "ar"
                                      ? cat.categorisName ?? ''
                                      : cat.categorisNameFr ?? ''),
                                ))
                            .toList(),
                        value: controller.selectedtypeuuid,
                        onChanged: (val) {
                          setState(() {
                            if (val == null) {
                              showSnackbar("error".tr,
                                  "يجب إختيار الفئة أولا".tr, Colors.red);
                              return;
                            }
                            controller.selectedtypeuuid = val;
                          });
                        },
                      ),

                      CustemDropDownField(
                        hintText: "نوع المنتج".tr,
                        items: [
                          DropdownMenuItem(value: 2, child: Text("ميزان".tr)),
                          DropdownMenuItem(
                              value: 1, child: Text("غير ميزان".tr)),
                        ],
                        value: controller.type,
                        onChanged: (val) {
                          if (val != null) {
                            controller.typeProduct(val);
                          }
                        },
                      ),

                      CustemDropDownField(
                        hintText: "Barcode Type".tr,
                        items: [
                          DropdownMenuItem(value: 0, child: Text("Auto".tr)),
                          DropdownMenuItem(value: 1, child: Text("Manual".tr)),
                          DropdownMenuItem(value: 2, child: Text("Scan".tr)),
                        ],
                        value: controller.barcodeMode,
                        onChanged: (val) {
                          if (val != null) {
                            controller.toggleBarcodeMode(val, context);
                          }
                        },
                        suffix: IconButton(
                          icon: const Icon(Icons.qr_code_scanner,
                              color: AppColor.backgroundcolor),
                          onPressed: () {
                            controller.scanBarcode(context);
                          },
                        ),
                      ),

                      Custemtextfromfild(
                        MyController: controller.barcodeController,
                        keyboardType: TextInputType.number,
                        hintText: "Barcode".tr,
                        label: "Barcode".tr,
                        iconData: Icons.qr_code,
                        enabled: controller.barcodeMode != 0,
                        suffix: IconButton(
                          icon: const Icon(Icons.qr_code_scanner,
                              color: AppColor.backgroundcolor),
                          onPressed: () {
                            controller.scanBarcode(context);
                          },
                        ),
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
                        enabled: true,
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
                        initialValue: controller.type == 2
                            ? (double.tryParse(
                                    controller.quantityController.text) ??
                                1)
                            : ((int.tryParse(
                                        controller.quantityController.text) ??
                                    1)
                                .toDouble()),
                        Mycontroller: controller.quantityController,
                        hintText: "Quantity".tr,
                        label: "Quantity".tr,
                        onChanged: controller.onQuantityChanged,
                        isDecimal: controller.type == 2,
                      ),
                      Custemtextfromfild(
                        MyController: controller.priseController,
                        keyboardType: TextInputType.number,
                        hintText: "سعر التجزئة".tr,
                        label: "سعر التجزئة".tr,
                        iconData: Icons.attach_money,
                        enabled: true,
                      ),
                      if (controller.sellType >= 2)
                        Custemtextfromfild(
                          MyController: controller.priseHalfWholesaleController,
                          keyboardType: TextInputType.number,
                          hintText: "سعر النصف جملة".tr,
                          label: "سعر النصف جملة".tr,
                          iconData: Icons.attach_money,
                          enabled: true,
                        ),
                      if (controller.sellType >= 3)
                        Custemtextfromfild(
                          MyController: controller.priseWholesaleController,
                          keyboardType: TextInputType.number,
                          hintText: "سعر الجملة".tr,
                          label: "سعر الجملة".tr,
                          iconData: Icons.attach_money,
                          enabled: true,
                        ),
                      Custemtextfromfild(
                        MyController: controller.pricePurchaseController,
                        keyboardType: TextInputType.number,
                        hintText: "سعر التكلفة".tr,
                        label: "سعر التكلفة".tr,
                        iconData: Icons.attach_money,
                        enabled: true,
                      ),
                      Custemtextfromfild(
                        MyController: TextEditingController(
                            text: controller.priceTotalPurchase
                                .toStringAsFixed(2)),
                        keyboardType: TextInputType.number,
                        hintText: "إجمالي سعر التكلفة".tr,
                        label: "إجمالي سعر التكلفة".tr,
                        iconData: Icons.attach_money,
                        enabled: true,
                      ),
                      Custemtextfromfild(
                        MyController: TextEditingController(
                            text: controller.priceTotal.toStringAsFixed(2)),
                        keyboardType: TextInputType.number,
                        hintText: "Selling Prise Total".tr,
                        label: "Selling Prise Total".tr,
                        iconData: Icons.attach_money,
                        enabled: true,
                      ),
                          Custembutton(
                              isLoading: controller.statusrequest == Statusrequest.loadeng,
                              text: "Add".tr,
                              onPressed: () {
                                if (!validInputsnak(controller.nameController.text, 1,
                                    20, "Name".tr)) {
                                  return;
                                }

                                if (!validInputsnak(controller.barcodeController.text,
                                    8, 13, "Barcode".tr)) {
                                  return;
                                }

                                controller.addProduct();
                                Get.back(result: true);
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
        );
      }),
    );
  }
}
