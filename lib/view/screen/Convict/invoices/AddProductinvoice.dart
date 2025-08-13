import 'package:Silaaty/controller/Profaile/invoice/Addproductinvoice.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromQuntety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/class/handlingview.dart';
import '../../../../core/functions/valiedinput.dart';

class Addproductinvoice extends StatefulWidget {
  const Addproductinvoice({super.key});

  @override
  State<Addproductinvoice> createState() => _AddproductinvoiceState();
}

class _AddproductinvoiceState extends State<Addproductinvoice> {
  @override
  Widget build(BuildContext context) {
    AddProductInvoiceController controller =
        Get.put(AddProductInvoiceController());
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
      body: GetBuilder<AddProductInvoiceController>(builder: (controler) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Form(
            key: controller.formKey,
            child: HandlingviewAuth(
              statusrequest: controler.statusRequest,
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
                        MyController: controller.priceController,
                        keyboardType: TextInputType.number,
                        hintText: "Price".tr,
                        label: "Prise Prodact".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custemtextfromfild(
                        MyController: TextEditingController(
                            text: controller.totalSalePrice.toStringAsFixed(2)),
                        keyboardType: TextInputType.number,
                        hintText: "",
                        label: "Prise Total".tr,
                        iconData: Icons.attach_money,
                      ),
                      Custembutton(
                        text: "Add".tr,
                        onPressed: () {
                          if (!validInputsnak(
                              controller.nameController.text, 3, 10, "Name".tr)) {
                            return;
                          }
              
                          controller.addProduct();
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
