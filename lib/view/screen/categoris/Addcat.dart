import 'package:Silaaty/controller/categoris/Addcatcontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';

class Addcat extends StatefulWidget {
  const Addcat({super.key});

  @override
  State<Addcat> createState() => _AddcatState();
}

class _AddcatState extends State<Addcat> {
  @override
  Widget build(BuildContext context) {
    Addcatcontroller controller = Get.put(Addcatcontroller());
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Add Categoris'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: GetBuilder<Addcatcontroller>(builder: (controler) {
        return Container(
          padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                      Custemtextfromfild(
                        MyController: controller.nameController,
                        keyboardType: TextInputType.name,
                        hintText: "Name Categoris Ar".tr,
                        label: "Name Categoris".tr,
                        iconData: Icons.shopping_bag,
                      ),
                      Custemtextfromfild(
                        MyController: controller.nameFrController,
                        keyboardType: TextInputType.name,
                        hintText: "Name Categoris fr".tr,
                        label: "Name Categoris".tr,
                        iconData: Icons.description,
                      ),
                      Custembutton(
                        text: "Add".tr,
                        onPressed: () {
                          if (!validInputsnak(controler.nameController.text, 1, 20,
                              "Name Categoris".tr)) {
                            return;
                          }
                          if (!validInputsnak(controler.nameFrController.text, 1, 20,
                              "Name Categoris fr".tr)) {
                            return;
                          }
                          controller.addcat();
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
