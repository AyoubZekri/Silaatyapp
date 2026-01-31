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
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("العميل".tr, style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  Custemdropdawnanimated(
                    customers: controller.customers,
                    selectedCustomer: controller.selectedCustomer,
                    onSelect: (value) {
                      controller.selectCustomer(value);
                    },
                  ),
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
            const SizedBox(height: 5),
            Container(
                color: Colors.grey[400], height: 1, width: double.infinity),
            const SizedBox(height: 10),
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
                                    text: item['quantity'].toString(),
                                  );

                                  Get.dialog(
                                    CustemQuantityDialog(
                                      controller: qtyController,
                                      title: "تعديل الكمية".tr,
                                      onCancel: () => Get.back(),
                                      onConfirm: () {
                                        controller.updateQuantity(item['uuid'],
                                            int.parse(qtyController.text));
                                      },
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
                                    onCancel: () {
                                    },
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
                                q: item["quantity"].toString(),
                                value: (controller.type == 1
                                        ? item["price_Purchase"]
                                        : item["price"] * item["quantity"])
                                    .toString(),
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
                              Text("DZD ${controller.totalallPrice}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("الإجمالي".tr),
                              Text("${'عناصر'.tr} ${controller.totalItems}"),
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
                                                    onPressed: () =>
                                                        Navigator.pop(context),
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
