import 'package:Silaaty/controller/categoris/ShwocatController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/categoris/custemcartcat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Shwocat extends StatefulWidget {
  const Shwocat({super.key});

  @override
  State<Shwocat> createState() => _ShwocatState();
}

class _ShwocatState extends State<Shwocat> {
  Shwocatcontroller controller = Get.put(Shwocatcontroller());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Shwocatcontroller>(builder: (controller) {
      return Scaffold(
          backgroundColor: AppColor.primarycolor,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            iconTheme: const IconThemeData(
              color: AppColor.backgroundcolor,
            ),
            title: Text(
              'Categoris'.tr,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColor.backgroundcolor,
                    fontSize: 24,
                  ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.gotoaddcat();
            },
            backgroundColor: AppColor.backgroundcolor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshData();
              },
              child: Handlingview(
                  statusrequest: controller.statusrequest,
                  widget: Container(
                    margin: const EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: controller.Categoris.length,
                      itemBuilder: (context, index) {
                        final cat = controller.Categoris[index];
                        return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration:
                                Duration(milliseconds: 300 + (index * 2)),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(50 * (1 - value), 0),
                                  child: child,
                                ),
                              );
                            },
                            child: Custemcartcat(
                              imgitems: cat.categorisImage,
                              name: Get.locale?.languageCode == "ar"
                                  ? cat.categorisName!
                                  : cat.categorisNameFr!,
                              image: false,
                              onEdit: () {
                                controller.GotoEditcat(index);
                              },
                              onDelete: () {
                                Get.defaultDialog(
                                  backgroundColor: AppColor.white,
                                  title: "Alert".tr,
                                  titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.backgroundcolor),
                                  middleText:
                                      "Do you want to delete the categoris?".tr,
                                  onConfirm: () {
                                    controller.deletecat(cat.id!);
                                  },
                                  onCancel: () {},
                                  buttonColor: AppColor.backgroundcolor,
                                  confirmTextColor: AppColor.primarycolor,
                                  cancelTextColor: AppColor.backgroundcolor,
                                );
                              },
                            ));
                      },
                    ),
                  ))));
    });
  }
}
