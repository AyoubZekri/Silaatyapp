import 'package:Silaaty/controller/items/ItemsController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Home/CustemType.dart';
import 'package:Silaaty/view/widget/Home/custemCartitems.dart';
import 'package:Silaaty/view/widget/Home/custemSearch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        controller.refreshData();
        controller.update();
      }
    });
  }

  Itemscontroller controller = Get.put(Itemscontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Itemscontroller>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
          title: Text('stock'.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
          backgroundColor: AppColor.white,
          elevation: 4,
          // ignore: deprecated_member_use
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.GotoAddaitems(1);
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
              // شريط البحث ثابت
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
                            : "لم تتم إضافة أي منتجات".tr,
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
