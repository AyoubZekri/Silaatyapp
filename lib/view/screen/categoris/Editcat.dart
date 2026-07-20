import 'dart:io';

import 'package:Silaaty/controller/categoris/Editcatcontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/valiedinput.dart';
import 'package:Silaaty/view/widget/addItem/CustemButton.dart';
import 'package:Silaaty/view/widget/addItem/CustemTextFromFild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../LinkApi.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/class/handlingview.dart';

class Editcat extends StatefulWidget {
  const Editcat({super.key});

  @override
  State<Editcat> createState() => _EditcatState();
}

class _EditcatState extends State<Editcat> {
  @override
  Widget build(BuildContext context) {
    Editcatcontroller controller = Get.put(Editcatcontroller());
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Edit Categoris'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: GetBuilder<Editcatcontroller>(builder: (controler) {
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
                        child: (controller.file == null && (controller.imageUrl == null || controller.imageUrl!.isEmpty))
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: controller.file != null
                                              ? Image.file(
                                                  controller.file!,
                                                  fit: BoxFit.cover,
                                                )
                                              : ((controller.imageUrl?.startsWith('/') ?? false) || (controller.imageUrl?.startsWith('file://') ?? false) || (controller.imageUrl?.startsWith('C:') ?? false)
                                                  ? Image.file(
                                                      File(controller.imageUrl!),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      "${Applink.image}/storage/${controller.imageUrl}",
                                                      fit: BoxFit.cover,
                                                    ))),
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
                        enabled: true,
                      ),
                      Custemtextfromfild(
                        MyController: controller.nameFrController,
                        keyboardType: TextInputType.name,
                        hintText: "Name Categoris fr".tr,
                        label: "Name Categoris".tr,
                        enabled: true,
                        iconData: Icons.description,
                      ),
                          Custembutton(
                              isLoading: controller.statusrequest == Statusrequest.loadeng,
                              text: "Add".tr,
                              onPressed: () {
                                if (!validInputsnak(controler.nameController.text, 1,
                                    20, "Name Categoris".tr)) return;
                                if (!validInputsnak(controler.nameController.text, 1,
                                    20, "Name Categoris fr".tr)) return;

                                controller.Editcat();
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
