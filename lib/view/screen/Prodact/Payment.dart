import 'package:Silaaty/controller/items/PaymentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../../widget/Bills/CostumCartdetails.dart';
import '../../widget/Bills/CostumCartdetailsPayment.dart';
import '../../widget/Bills/CostumTextFildPatment.dart';
import '../../widget/Bills/CostumtitlePayment.dart';
import '../../widget/addItem/CustemButton.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final controller = Get.put(PaymentController());

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
        body: GetBuilder<PaymentController>(builder: (_) {
          return Container(
            margin: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: ListView(
              children: [
                Costumtitlepayment(
                  iconData: Icons.person_outline,
                  title: "معلومات العميل".tr,
                ),
                Costumcartdetails(
                  iconData: Icons.person_2_outlined,
                  title: "العميل".tr,
                  body:controller.selectedCustomer == "virtualCustomer".tr? controller.selectedCustomer:"${controller.name} ${controller.familyName}",
                ),
                Costumcartdetails(
                  iconData: Icons.date_range,
                  title: "التاريخ".tr,
                  body: controller.currentDate.toString(),
                ),
                Container(
                  height: 50,
                ),
                Costumtitlepayment(
                  iconData: Icons.payment,
                  title: "الدفع".tr,
                ),
                Costumtextfildpatment(
                  MyController: controller.paymentController,
                  hintText: "Payment".tr,
                  label: "Payment".tr,
                  iconData: Icons.payment_outlined,
                  valid: (Val) {
                    return validInput(Val!, 100, 5, "Email");
                  },
                  enabled: controller.selectedCustomer == "virtualCustomer".tr ? false:true,
                  keyboardType: TextInputType.number,
                ),
                Costumtextfildpatment(
                  onTap: () {
                    controller.update();
                  },
                  MyController: controller.discountController,
                  hintText: "Discount".tr,
                  label: "Discount".tr,
                  iconData: Icons.discount_outlined,
                  valid: (Val) {
                    return validInput(Val!, 100, 5, "Email");
                  },
                  enabled: true,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Costumcartdetailspayment(
                        title: "المجموع الفرعي".tr,
                        body: controller.totalprice,
                      ),
                      Costumcartdetailspayment(
                        title: "الخصم".tr,
                        body: controller.discountController.text,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("الإجمالي".tr,
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            controller.finalAmount.toString(),
                            style: TextStyle(
                                color: AppColor.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Custembutton(
                  text: "Add".tr,
                  onPressed: () {
                    if (!validInputsnak(
                        controller.paymentController.text, 1, 20, "Name".tr)) {
                      return;
                    }

                    controller.addSale();
                  },
                  vertical: 30,
                  horizontal: 10,
                  paddingvertical: 10,
                )
              ],
            ),
          );
        }));
  }
}
