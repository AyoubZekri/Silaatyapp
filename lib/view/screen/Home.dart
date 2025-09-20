import 'package:Silaaty/controller/HomeScreen/HomeController.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Home/CustemType.dart';
import 'package:Silaaty/view/widget/Home/custemCartitems.dart';
import 'package:Silaaty/view/widget/Home/custemSearch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Homecontroller controller = Get.put(Homecontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Home'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        elevation: 4,
        // ignore: deprecated_member_use
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: GetBuilder<Homecontroller>(builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Custemsearch(
                      Search: "Search".tr,
                      onChanged: (text) {
                        controller.search(text);
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Container(
                    //   margin: const EdgeInsets.all(15),
                    //   child: Wrap(
                    //     spacing: 10,
                    //     runSpacing: 10,
                    //     children: [
                    //       Custemcategoriscard(
                    //           onPressed: () {
                    //             controller.getProdact(1);
                    //           },
                    //           iconData: Icons.category,
                    //           NameItems: "Prodacts".tr),
                    //       Custemcategoriscard(
                    //         onPressed: () {
                    //           controller.getProdact(2);
                    //         },
                    //         iconData: Icons.local_mall,
                    //         NameItems: 'Necessary'.tr,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    if (controller.isSearching == false)
                      Container(
                        margin: const EdgeInsets.all(15),
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: controller.statusrequestcat ==
                                    Statusrequest.loadeng
                                ? List.generate(
                                    4,
                                    (index) => const Custemtype(
                                      NameItems: '',
                                      isActive: false,
                                      isLoading: true,
                                    ),
                                  )
                                : List.generate(
                                    controller.categories.length,
                                    (index) {
                                      final cat = controller.categories[index];
                                      return Custemtype(
                                        onPressed: () {
                                          controller.selectCategory(cat.id!);
                                        },
                                        NameItems:
                                            Get.locale?.languageCode == "ar"
                                                ? cat.categorisName!
                                                : cat.categorisNameFr!,
                                        isActive:
                                            controller.selectedCategoryId ==
                                                cat.id,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    if (controller.isSearching == false)
                      const SizedBox(
                        height: 10,
                      ),
                    if (controller.isSearching == false)
                      Container(
                        margin: const EdgeInsets.only(right: 15, left: 15),
                        child: Text(
                          "Prodacts".tr,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Handlingviewhome(
                        statusrequest: controller.statusrequest,
                        widget: controller.product.isEmpty
                            ? ListView(
                                children: [
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      "".tr,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: controller.product.length,
                                itemBuilder: (context, index) {
                                  final item = controller.product[index];
                                  return TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: Duration(
                                        milliseconds: 300 + (index * 2)),
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
                                        controller.GotoIformationItem(item.id!);
                                      },
                                      imgitems: item.productImage,
                                      Title: item.productName ?? '',
                                      Body: item.productQuantity ?? '0',
                                      Price: item.productPrice ?? '0',
                                    ),
                                  );
                                },
                              ),
                      ),
                    )
                  ],
                );
              }))),
    );
  }
}
