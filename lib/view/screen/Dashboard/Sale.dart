import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../controller/Dashpord/Salecontroller.dart';
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
      backgroundColor: AppColor.primarycolor, // The light grey color from Colorapp
      appBar: AppBar(
        title: Text(
          "بيع جديد".tr,
          style: const TextStyle(
              color: AppColor.backgroundcolor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.primarycolor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: GetBuilder<SaleController>(builder: (_) {
        return Column(
          children: [
            const SizedBox(height: 15),
            
            // Header section (Customer & Sale Type)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: AppColor.backgroundcolor, size: 18),
                              const SizedBox(width: 5),
                              Text("العميل".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                  ),
                  if (controller.type != 1 && controller.userSellType > 1) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.sell_outlined, color: AppColor.backgroundcolor, size: 18),
                                const SizedBox(width: 5),
                                Text("نوع البيع".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // List of Products
            Expanded(
              child: controller.selectedProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: AppColor.backgroundcolor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: AppColor.backgroundcolor,
                              size: 70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "السلة فارغة".tr,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "ابدأ بإضافة منتجات لإكمال الفاتورة".tr,
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      itemCount: controller.selectedProducts.length,
                      itemBuilder: (context, index) {
                        final item = controller.selectedProducts[index];
                        final currentPrice = controller.type == 1 ? item['price_Purchase'] : item['price'];
                        final totalValue = currentPrice * item['quantity'];
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () => _showEditProductDialog(context, item, currentPrice),
                              onLongPress: () => _showDeleteDialog(item),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: AppColor.backgroundcolor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.inventory_2, color: AppColor.backgroundcolor),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["name"],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "${formavalue(currentPrice)} DA",
                                                style: const TextStyle(color: Colors.black54, fontSize: 13),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColor.primarycolor,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  "الكمية: ${formatQuantity(item['quantity'])}",
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${formavalue(totalValue)}",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColor.backgroundcolor),
                                        ),
                                        const Text(
                                          "DA",
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Bottom Action Area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: Column(
                children: [
                  // Totals
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.backgroundcolor, AppColor.backgroundcolor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.backgroundcolor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("الإجمالي".tr, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            Text(
                              "${formavalue(controller.totalallPrice)} DA",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_bag, color: Colors.white, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                "${formatQuantity(controller.totalItems)} ${'عناصر'.tr}",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Action Buttons
                  Row(
                    children: [
                      // Scanner button
                      InkWell(
                        onTap: _showScannerDialog,
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.backgroundcolor, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.qr_code_scanner, color: AppColor.backgroundcolor),
                        ),
                      ),
                      const SizedBox(width: 10),
                      
                      // Select Product Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.gotoaddproductNewSale();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.backgroundcolor,
                            side: const BorderSide(color: AppColor.backgroundcolor, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text("منتج".tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      // Add New Product Button (Supplier Only)
                      if (controller.type?.toString() == '1') ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              var result = await Get.toNamed(
                                Approutes.Additem,
                                arguments: {'isDraftMode': true},
                              );
                              if (result != null && result is Map<String, dynamic>) {
                                controller.addDraftedProduct(result);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColor.backgroundcolor,
                              side: const BorderSide(color: AppColor.backgroundcolor, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            child: Text(
                              "جديد".tr,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(width: 10),
                      
                      // Pay/Save Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.gotoPayment();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.backgroundcolor, // BRAND COLOR
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                          ),
                          child: Text("الدفع".tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteDialog(dynamic item) {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: "تنبيه".tr,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      content: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 50),
          const SizedBox(height: 10),
          Text("هل تريد حذف هذا المنتج من الفاتورة؟".tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("إلغاء".tr, style: const TextStyle(color: AppColor.grey, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            controller.deleteProduct(item["uuid"]);
            Get.back();
          },
          child: Text("حذف".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showEditProductDialog(BuildContext context, dynamic item, num currentPrice) {
    TextEditingController qtyController = TextEditingController(text: formatQuantity(item['quantity']));
    TextEditingController priceController = TextEditingController(text: formavalue(currentPrice));
    TextEditingController totalPriceController = TextEditingController(text: formavalue(currentPrice * item['quantity']));

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_note, size: 50, color: AppColor.backgroundcolor),
                const SizedBox(height: 10),
                Text(
                  "تعديل المنتج".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: qtyController,
                  keyboardType: item['type_item'] == 2 ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "الكمية / الوزن".tr,
                    prefixIcon: const Icon(Icons.inventory_2_outlined, color: AppColor.backgroundcolor),
                    filled: true,
                    fillColor: AppColor.primarycolor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) {
                    if (item['type_item'] == 2) {
                      double? weight = double.tryParse(val);
                      double? uprice = double.tryParse(priceController.text);
                      if (weight != null && uprice != null) {
                        totalPriceController.text = formavalue(weight * uprice);
                      }
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "سعر الوحدة".tr,
                    prefixIcon: const Icon(Icons.attach_money, color: AppColor.backgroundcolor),
                    filled: true,
                    fillColor: AppColor.primarycolor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) {
                    double? uprice = double.tryParse(val);
                    double? qty = double.tryParse(qtyController.text);
                    if (uprice != null && qty != null) {
                      totalPriceController.text = formavalue(uprice * qty);
                    }
                  },
                ),
                if (item['type_item'] == 2) ...[
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: totalPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "السعر الإجمالي".tr,
                      prefixIcon: const Icon(Icons.payments_outlined, color: AppColor.backgroundcolor),
                      filled: true,
                      fillColor: AppColor.primarycolor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                    onChanged: (val) {
                      double? total = double.tryParse(val);
                      double? uprice = double.tryParse(priceController.text);
                      if (total != null && uprice != null && uprice > 0) {
                        qtyController.text = formatQuantity(total / uprice);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text("إلغاء".tr, style: const TextStyle(color: AppColor.grey, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          num? qty = double.tryParse(qtyController.text);
                          final price = double.tryParse(priceController.text);
                          if (qty != null && qty > 0) {
                            if (item['type_item'] != 2) qty = qty.toInt();
                            controller.updateQuantity(item['uuid'], qty);
                          }
                          if (price != null && price > 0) {
                            controller.updateProductPrice(item['uuid'], price);
                          }
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.backgroundcolor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("حفظ التعديل".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScannerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 550,
              width: double.infinity,
              child: Stack(
                children: [
                  MobileScanner(
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final scannedCode = barcodes.first.rawValue;
                        if (scannedCode != null) {
                          controller.search(scannedCode);
                        }
                      }
                    },
                  ),
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.backgroundcolor, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "امسح الباركود".tr,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 28),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: GetBuilder<SaleController>(
                      builder: (controller) {
                        if (controller.pendingProduct == null) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 45),
                              const SizedBox(height: 12),
                              Text(
                                controller.pendingProduct!['product_name'] ?? "",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => controller.cancelPendingProduct(),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColor.red,
                                        side: const BorderSide(color: AppColor.red),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: Text("إلغاء".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => controller.confirmPendingProduct(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.backgroundcolor,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: Text("تأكيد".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
