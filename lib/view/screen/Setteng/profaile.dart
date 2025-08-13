import 'package:Silaaty/controller/Setteng/updateUserController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/Profail/CustemCardProfail.dart';
import 'package:Silaaty/view/widget/Profail/CustemTextfildprofail.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';

class Profaile extends StatefulWidget {
  const Profaile({super.key});

  @override
  State<Profaile> createState() => _ProfaileState();
}

class _ProfaileState extends State<Profaile> {
  Updateusercontroller controller = Get.put(Updateusercontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          title: Text('Profail Account'.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
        ),
        body: GetBuilder<Updateusercontroller>(builder: (controller) {
          return HandlingviewAuth(
            statusrequest: controller.statusrequest,
            widget: ListView(
              children: [
                Form(
                  key: controller.formstate,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Custemcardprofail(
                          Title: "iformation user".tr,
                          iconData: Icons.credit_card,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Custemtextfildprofail(
                          MyController: controller.nameController,
                          hintText: "name".tr,
                          label: "name".tr,
                          valid: (Val) {
                            return validInput(Val!, 100, 3, "username");
                          },
                          keyboardType: TextInputType.name,
                          contentPaddingvertical: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Custemtextfildprofail(
                          MyController: controller.FamlynameController,
                          hintText: "famly name".tr,
                          label: "famly name".tr,
                          valid: (Val) {
                            return validInput(Val!, 100, 3, "username");
                          },
                          keyboardType: TextInputType.name,
                          contentPaddingvertical: 10,
                        ),
                        Custemtextfildprofail(
                          MyController: controller.PhoneController,
                          hintText: "Phone Namper".tr,
                          label: "Phone Namper".tr,
                          valid: (Val) {
                            return validInput(Val!, 12, 10, "phone");
                          },
                          keyboardType: TextInputType.phone,
                          contentPaddingvertical: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Custembutton(
                  text: "Conferm".tr,
                  onPressed: () {
                    controller.updateuser();
                  },
                  vertical: 10,
                  horizontal: 60,
                  paddingvertical: 7,
                )
              ],
            ),
          );
        }));
  }
}
