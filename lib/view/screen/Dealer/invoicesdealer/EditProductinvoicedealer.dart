import 'package:Silaaty/controller/Profaile/invoice/Editproductinvoice.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromQuntety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/class/handlingview.dart';

class Editproductinvoicedealer extends StatefulWidget {
  const Editproductinvoicedealer({super.key});

  @override
  State<Editproductinvoicedealer> createState() => _Editproductinvoicedealer();
}

class _Editproductinvoicedealer extends State<Editproductinvoicedealer> {
  @override
  Widget build(BuildContext context) {
    EditProductInvoiceController controller =
        Get.put(EditProductInvoiceController());
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
      body: GetBuilder<EditProductInvoiceController>(builder: (controler) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Form(
            key: controller.formKey,
            child: HandlingviewAuth(
              statusrequest: controller.statusRequest,
              widget: ListView(
                children: [
                  Column(
                    children: [
                      Custemtextfromfild(
                        MyController: controller.nameController,
                        keyboardType: TextInputType.name,
                        hintText: "Name Prodact".tr,
                        label: "Name Prodact".tr,
                        iconData: Icons.shopping_bag,
                      ),
                      QuantityInput(
                        initialValue:
                            int.tryParse(controller.quantityController.text) ?? 1,
                        Mycontroller: controller.quantityController,
                        hintText: "Quantity".tr,
                        label: "Quantity".tr,
                        onChanged: controller.onQuantityChanged,
                      ),
                      Custemtextfromfild(
                        MyController: controller.purchasePriceController,
                        keyboardType: TextInputType.number,
                        hintText: "Price".tr,
                        label: "Prise Prodact".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custemtextfromfild(
                        MyController: TextEditingController(
                            text:
                                controller.priceTotalPurchase.toStringAsFixed(2)),
                        keyboardType: TextInputType.number,
                        hintText: "Price Total".tr,
                        label: "Prise Prodact".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custembutton(
                        text: "Add".tr,
                        onPressed: () {
                          if (!validInputsnak(
                              controller.nameController.text, 1, 20, "Name".tr)) {
                            return;
                          }
              
                          controller.editProduct();
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
