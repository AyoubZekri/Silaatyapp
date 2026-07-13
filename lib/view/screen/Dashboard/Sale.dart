import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../controller/Dashpord/Salecontroller.dart';
import '../../widget/Zacat/CustemRowProdact.dart';
import '../../widget/sale/CostumDealogEditProduct.dart';
import '../../widget/sale/CustemdropdawnAnimated.dart';
import '../../widget/sale/CustemSaleTypeDropdownAnimated.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';

class NewSale extends StatefulWidget {
  const NewSale({super.key});

  @override
  State<NewSale> createState() => _NewSaleState();
}

class _NewSaleState extends State<NewSale> with SingleTickerProviderStateMixin {
  late SaleController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SaleController>()) {
      Get.delete<SaleController>();
    }
    controller = Get.put(SaleController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "بيع جديد".tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: GetBuilder<SaleController>(builder: (_) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("العميل".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Custemdropdawnanimated(
                          customers: controller.customers,
                          selectedCustomer: controller.selectedCustomer,
                          onSelect: (value) {
                            controller.selectCustomer(value);
                            print("===================$controller.selectedCustomer");
                          },
                        ),
                      ],
                    ),
                  ),
                  if (controller.type != 1 && controller.userSellType > 1) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("نوع البيع".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          CustemSaleTypeDropdownAnimated(
                            selectedSaleType: controller.saleType,
                            allowedSellType: controller.userSellType,
                            onSelect: (val) {
                              controller.changeSaleType(val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
                color: Colors.grey[400], height: 1, width: double.infinity),
            Custemrowprodact(
              title: "Product".tr,
              price: "Price".tr,
              fontSize: 17,
              color: AppColor.backgroundcolor,
              colorp: AppColor.backgroundcolor,
              q: "Quantity".tr,
              value: "Value".tr,
            ),
            Container(
                color: Colors.grey[400], height: 1, width: double.infinity),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: controller.selectedProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.inventory,
                                  color: AppColor.backgroundcolor,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "لم تتم إضافة أي منتجات".tr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.selectedProducts.length,
                            itemBuilder: (context, index) {
                              final item = controller.selectedProducts[index];
                              return Custemrowprodact(
                                onTap: () {
                                  TextEditingController qtyController =
                                      TextEditingController(
                                    text: formatQuantity(item['quantity']),
                                  );
                                  final currentPrice = controller.type == 1
                                      ? item['price_Purchase']
                                      : item['price'];
                                  TextEditingController priceController =
                                      TextEditingController(
                                    text: currentPrice.toString(),
                                  );

                                  TextEditingController totalPriceController =
                                      TextEditingController(
                                    text: (currentPrice * item['quantity'])
                                        .toStringAsFixed(2),
                                  );

                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor: AppColor.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: Center(
                                        child: Text(
                                          "تعديل المنتج".tr,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.backgroundcolor,
                                          ),
                                        ),
                                      ),
                                      content: StatefulBuilder(
                                          builder: (context, setState) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: qtyController,
                                                keyboardType:
                                                    item['type_item'] == 2
                                                        ? const TextInputType
                                                            .numberWithOptions(
                                                            decimal: true)
                                                        : TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "الكمية/الوزن".tr,
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  suffixIcon: const Icon(
                                                    Icons.inventory_2_outlined,
                                                    color: AppColor
                                                        .backgroundcolor,
                                                  ),
                                                ),
                                                onChanged: (val) {
                                                  if (item['type_item'] == 2) {
                                                    double? weight =
                                                        double.tryParse(val);
                                                    double? uprice =
                                                        double.tryParse(
                                                            priceController
                                                                .text);
                                                    if (weight != null &&
                                                        uprice != null) {
                                                      totalPriceController
                                                          .text = (weight *
                                                              uprice)
                                                          .toStringAsFixed(2);
                                                    }
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                controller: priceController,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  labelText: "سعر الوحدة".tr,
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  suffixIcon: const Icon(
                                                    Icons.attach_money,
                                                    color: AppColor
                                                        .backgroundcolor,
                                                  ),
                                                ),
                                                onChanged: (val) {
                                                  double? uprice =
                                                      double.tryParse(val);
                                                  double? qty = double.tryParse(
                                                      qtyController.text);
                                                  if (uprice != null &&
                                                      qty != null) {
                                                    totalPriceController.text =
                                                        (uprice * qty)
                                                            .toStringAsFixed(2);
                                                  }
                                                },
                                              ),
                                              if (item['type_item'] == 2) ...[
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  controller:
                                                      totalPriceController,
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                          decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "السعر الإجمالي".tr,
                                                    filled: true,
                                                    fillColor: Colors.grey[100],
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    suffixIcon: const Icon(
                                                      Icons.payments_outlined,
                                                      color: AppColor
                                                          .backgroundcolor,
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    double? total =
                                                        double.tryParse(val);
                                                    double? uprice =
                                                        double.tryParse(
                                                            priceController
                                                                .text);
                                                    if (total != null &&
                                                        uprice != null &&
                                                        uprice > 0) {
                                                      qtyController.text =
                                                          (total / uprice)
                                                              .toStringAsFixed(
                                                                  3);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ],
                                          ),
                                        );
                                      }),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text("Cancel".tr),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            num? qty = double.tryParse(
                                                qtyController.text);
                                            final price = double.tryParse(
                                                priceController.text);
                                            if (qty != null && qty > 0) {
                                              if (item['type_item'] != 2) {
                                                qty = qty.toInt();
                                              }
                                              controller.updateQuantity(
                                                  item['uuid'], qty);
                                            }
                                            if (price != null && price > 0) {
                                              controller.updateProductPrice(
                                                  item['uuid'], price);
                                            }
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.backgroundcolor,
                                          ),
                                          child: Text("Edit".tr,
                                              style: const TextStyle(
                                                  color: AppColor.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  Get.defaultDialog(
                                    backgroundColor: AppColor.white,
                                    title: "Alert".tr,
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.backgroundcolor),
                                    middleText: "هل تريد حذف المنتج؟".tr,
                                    onConfirm: () {
                                      controller.deleteProduct(item["uuid"]);
                                      Get.back();
                                    },
                                    onCancel: () {},
                                    buttonColor: AppColor.backgroundcolor,
                                    confirmTextColor: AppColor.primarycolor,
                                    cancelTextColor: AppColor.backgroundcolor,
                                  );
                                },
                                title: item["name"],
                                price: controller.type == 1
                                    ? item["price_Purchase"].toString()
                                    : item["price"].toString(),
                                fontSize: 17,
                                color: AppColor.grey,
                                colorp: AppColor.grey,
                                da: "DA".tr,
                                q: formatQuantity(item["quantity"]),
                                value: ((controller.type == 1
                                            ? item["price_Purchase"]
                                            : item["price"]) *
                                        item["quantity"])
                                    .toStringAsFixed(0),
                              );
                            },
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.primarycolor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, -1))
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 30),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "DZD ${controller.totalallPrice.toStringAsFixed(2)}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("الإجمالي".tr),
                              Text(
                                  "${'عناصر'.tr} ${controller.totalItems.toStringAsFixed(0)}"),
                              Icon(Icons.shopping_cart_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.gotoPayment();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.backgroundcolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text("الدفع".tr,
                                    style: TextStyle(color: AppColor.white)),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  controller.gotoaddproductNewSale();
                                },
                                icon: const Icon(Icons.add),
                                label: Text("منتج".tr),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        insetPadding: const EdgeInsets.all(20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: SizedBox(
                                          height: 400,
                                          child: Column(
                                            children: [
                                              AppBar(
                                                title: Text(
                                                  "امسح الباركود".tr,
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .backgroundcolor),
                                                ),
                                                automaticallyImplyLeading:
                                                    false,
                                                backgroundColor:
                                                    AppColor.primarycolor,
                                                actions: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.close,
                                                        color: AppColor
                                                            .backgroundcolor),
                                                    onPressed: () => Get.back(),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: MobileScanner(
                                                  onDetect: (capture) {
                                                    final barcodes =
                                                        capture.barcodes;
                                                    if (barcodes.isNotEmpty) {
                                                      final scannedCode =
                                                          barcodes
                                                              .first.rawValue;
                                                      print(
                                                          "=======================$scannedCode");
                                                      controller
                                                          .search(scannedCode!);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.qr_code_scanner),
                                label: Text("مسح".tr),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
