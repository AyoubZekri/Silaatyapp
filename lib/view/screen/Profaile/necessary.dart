import 'package:Silaaty/controller/Profaile/Necessary/Necessarycontroller.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Home/CustemType.dart';
import 'package:Silaaty/view/widget/Home/custemCartitems.dart';
import 'package:Silaaty/view/widget/Home/custemSearch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';

class Necessary extends StatefulWidget {
  const Necessary({super.key});

  @override
  State<Necessary> createState() => _HomeState();
}

class _HomeState extends State<Necessary> {
  Necessarycontroller controller = Get.put(Necessarycontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Necessarycontroller>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
          title: Text(
            'Necessary'.tr,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColor.backgroundcolor,
                  fontSize: 24,
                ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.GotoAddaitems(2);
          },
          backgroundColor: AppColor.backgroundcolor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Custemsearch(
                Search: "Search".tr,
                onChanged: (text) {
                  controller.search(text);
                },
              ),

              // الباقي Scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 5),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الفئات
                      if (controller.isSearching == false)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 55,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(
                                controller.categories.length + 1,
                                (index) {
                                  if (index == 0) {
                                    return Custemtype(
                                      onPressed: () {
                                        controller.selectCategory("");
                                      },
                                      NameItems: "الكل".tr,
                                      isActive:
                                          controller.selectedCategoryId == "",
                                    );
                                  } else {
                                    final cat =
                                        controller.categories[index - 1];
                                    return Custemtype(
                                      onPressed: () {
                                        controller.selectCategory(cat.uuid!);
                                      },
                                      NameItems:
                                          Get.locale?.languageCode == "ar"
                                              ? cat.categorisName!
                                              : cat.categorisNameFr!,
                                      isActive: controller.selectedCategoryId ==
                                          cat.uuid,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (controller.isSearching == false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Prodacts".tr,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      // قائمة المنتجات
                      Handlingview(
                        statusrequest: controller.statusrequest,
                        iconData: Icons.inventory,
                        title: controller.isSearching
                            ? "لم يتم العثور على منتجات مطابقة للبحث".tr
                            : "لا يوجد منتجات نفذ مخزونها".tr,
                        widget: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.product.length,
                          itemBuilder: (context, index) {
                            final item = controller.product[index];
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
                              child: Custemcartitems(
                                image: true,
                                onTap: () async {
                                  controller.GotoIformationItem(item.uuid!);
                                },
                                imgitems: item.productImage,
                                Title: item.productName ?? '',
                                Body: item.productQuantity ?? '0',
                                Price: item.productPrice.toString(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
