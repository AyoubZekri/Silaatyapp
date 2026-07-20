import 'package:Silaaty/controller/items/ItemsController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import 'package:Silaaty/view/widget/Home/CustemType.dart';
import 'package:Silaaty/view/widget/Home/custemSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widget/addItem/CustemButton.dart';
import '../../widget/addItem/CustomCartaddProductSale.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') return newValue;
    if (RegExp(r'^\d*\.?\d{0,4}$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class AddProductSale extends StatefulWidget {
  const AddProductSale({super.key});

  @override
  State<AddProductSale> createState() => _AddProductSaleState();
}

class _AddProductSaleState extends State<AddProductSale> {
  void _showWeightPriceDialog(Itemscontroller controller, dynamic item) {
    TextEditingController weightController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    double unitPrice = item.productPrice ?? 0;
    final maxQty = num.tryParse(item.productQuantity ?? '0') ?? 0;

    Get.dialog(AlertDialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Center(
        child: Text(
          "تعديل الوزن/السعر".tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.backgroundcolor,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.productName ?? "",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [DecimalTextInputFormatter()],
              autofocus: true,
              decoration: InputDecoration(
                labelText: "الوزن".tr,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: const Icon(Icons.scale_outlined,
                    color: AppColor.backgroundcolor),
              ),
              onChanged: (val) {
                if (unitPrice > 0) {
                  double? weight = double.tryParse(val);
                  if (weight != null) {
                    priceController.text =
                        formavalue(weight * unitPrice);
                  } else {
                    priceController.clear();
                  }
                }
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [DecimalTextInputFormatter()],
              decoration: InputDecoration(
                labelText: "السعر الإجمالي".tr,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: const Icon(Icons.payments_outlined,
                    color: AppColor.backgroundcolor),
              ),
              onChanged: (val) {
                if (unitPrice > 0) {
                  double? price = double.tryParse(val);
                  if (price != null) {
                    weightController.text = (price / unitPrice).toString();
                  } else {
                    weightController.clear();
                  }
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Cancel".tr)),
        ElevatedButton(
            onPressed: () {
              double? weight = double.tryParse(weightController.text);
              if (weight != null && weight > 0) {
                controller.increment(item.uuid!, maxQty, val: weight);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundcolor,
            ),
            child:
                Text("Add".tr, style: const TextStyle(color: AppColor.white))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    Itemscontroller controller = Get.put(Itemscontroller());

    return GetBuilder<Itemscontroller>(builder: (_) {
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
          floatingActionButton: Custembutton(
            text: "Save".tr,
            onPressed: () {
              controller.Gotoback();
            },
            vertical: 10,
            horizontal: 20,
            paddingvertical: 15,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshData();
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
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
                        child: Handlingview(
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
                                      child: Customcartaddproductsale(
                                        type: item.type ?? 1,
                                        isSelected:
                                            controller.isSelected(item.uuid!),
                                        quantity:
                                            controller.getQuantity(item.uuid!),
                                        onTap: () {
                                          if (item.type == 2 &&
                                              !controller
                                                  .isSelected(item.uuid!)) {
                                            _showWeightPriceDialog(
                                                controller, item);
                                          } else {
                                            final maxQty = num.tryParse(
                                                    item.productQuantity ??
                                                        '0') ??
                                                0;
                                            controller.toggleSelect(
                                                item.uuid!, maxQty);
                                          }
                                        },
                                        onIncrement: () {
                                          final maxQty = num.tryParse(
                                                  item.productQuantity ??
                                                      '0') ??
                                              0;
                                          if (item.type == 2) {
                                            _showWeightPriceDialog(
                                                controller, item);
                                          } else {
                                            controller.increment(
                                                item.uuid!, maxQty);
                                          }
                                        },
                                        onDecrement: () =>
                                            controller.decrement(item.uuid!),
                                        image: true,
                                        imgitems: item.productImage,
                                        Title: item.productName ?? '',
                                        Body: num.tryParse(
                                                item.productQuantity ?? '0') ??
                                            0,
                                        Price: formavalue(controller.getSalePrice(item)),
                                        uuid: item.uuid!,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )
                    ],
                  ))));
    });
  }
}
