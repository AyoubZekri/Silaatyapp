import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/Snacpar.dart';

class CustemStockTransferDialog extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> products;
  final Function(String productUuid, double quantity) onSubmit;
  final VoidCallback? onTransferAll;
  final bool isReturn;

  const CustemStockTransferDialog({
    Key? key,
    required this.title,
    required this.products,
    required this.onSubmit,
    this.onTransferAll,
    this.isReturn = false,
  }) : super(key: key);

  @override
  State<CustemStockTransferDialog> createState() => _CustemStockTransferDialogState();
}

class _CustemStockTransferDialogState extends State<CustemStockTransferDialog> {
  String? selectedProductUuid;
  int? selectedProductType; // 1 for piece, 2 for scale
  String currentUnit = 'piece';
  int itemsPerCarton = 0;
  
  double selectedQuantity = 1.0;
  double availableQuantity = 0.0;
  TextEditingController scaleQuantityController = TextEditingController(text: "1");

  @override
  void dispose() {
    scaleQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.backgroundcolor,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Text("المنتج".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: AppColor.backgroundcolor.withOpacity(0.3), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.backgroundcolor, size: 28),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(15),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                hint: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 22),
                    const SizedBox(width: 10),
                    Text("اختر المنتج...".tr, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                value: selectedProductUuid,
                items: () {
                  var seen = <String>{};
                  var uniqueProducts = widget.products.where((product) {
                    String val = widget.isReturn ? product['product_uuid'] : product['uuid'];
                    if (seen.contains(val)) return false;
                    seen.add(val);
                    return true;
                  }).toList();
                  
                  return uniqueProducts.map((product) {
                    return DropdownMenuItem<String>(
                      value: widget.isReturn ? product['product_uuid'] : product['uuid'],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${product['product_name']}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.isReturn ? Colors.orange.shade50 : AppColor.backgroundcolor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${'الكمية'.tr}: ${widget.isReturn ? product['quantity'] : product['product_quantity']}",
                              style: TextStyle(
                                color: widget.isReturn ? Colors.orange.shade800 : AppColor.backgroundcolor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                }(),
                onChanged: (value) {
                  setState(() {
                    selectedProductUuid = value;
                    var prod = widget.products.firstWhere((p) => (widget.isReturn ? p['product_uuid'] : p['uuid']) == value);
                    availableQuantity = double.tryParse((widget.isReturn ? prod['quantity'] : prod['product_quantity']).toString()) ?? 0.0;
                    selectedProductType = int.tryParse(prod['type']?.toString() ?? '1') ?? 1;
                    itemsPerCarton = int.tryParse(prod['items_per_carton']?.toString() ?? '0') ?? 0;
                    if (itemsPerCarton <= 0) currentUnit = 'piece';
                    selectedQuantity = 1.0; // Reset quantity when product changes
                    scaleQuantityController.text = selectedProductType == 2 ? "1.0" : "1";
                  });
                },
              ),
            ),
          ),
          
          
          if (itemsPerCarton > 0) ...[
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("بالقطعة".tr),
                    value: 'piece',
                    groupValue: currentUnit,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          currentUnit = val;
                          selectedQuantity = 1.0;
                          scaleQuantityController.text = "1";
                        });
                      }
                    },
                    activeColor: AppColor.backgroundcolor,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("بالكرتون".tr),
                    value: 'carton',
                    groupValue: currentUnit,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          currentUnit = val;
                          selectedQuantity = 1.0;
                          scaleQuantityController.text = "1";
                        });
                      }
                    },
                    activeColor: AppColor.backgroundcolor,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("الكمية".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (selectedProductUuid != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (currentUnit == 'carton' && itemsPerCarton > 0) {
                        selectedQuantity = (availableQuantity / itemsPerCarton).floorToDouble();
                      } else {
                        selectedQuantity = availableQuantity;
                      }
                      scaleQuantityController.text = selectedProductType == 2 
                          ? selectedQuantity.toString() 
                          : selectedQuantity.toInt().toString();
                    });
                  },
                  child: Text(
                    widget.isReturn ? "إرجاع الكل".tr : "تزويد الكل".tr,
                    style: TextStyle(
                      color: widget.isReturn ? Colors.orange.shade700 : AppColor.backgroundcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (selectedProductType == 2) 
            // Scale input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: scaleQuantityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "أدخل الكمية (مثال: 1.5)".tr,
                ),
                onChanged: (val) {
                  setState(() {
                    selectedQuantity = double.tryParse(val) ?? 0.0;
                  });
                },
              ),
            )
          else
            // Piece input (counter)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (selectedQuantity > 1) {
                      setState(() {
                         selectedQuantity--;
                         scaleQuantityController.text = selectedQuantity.toInt().toString();
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline, color: AppColor.backgroundcolor, size: 30),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: scaleQuantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (val) {
                        setState(() {
                          selectedQuantity = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    double maxAllowed = currentUnit == 'carton' && itemsPerCarton > 0 
                        ? (availableQuantity / itemsPerCarton).floorToDouble() 
                        : availableQuantity;
                    if (selectedQuantity < maxAllowed) {
                      setState(() {
                         selectedQuantity++;
                         scaleQuantityController.text = selectedQuantity.toInt().toString();
                      });
                    } else {
                      showSnackbar("تنبيه".tr, "لا توجد كمية كافية".tr, Colors.orange);
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline, color: AppColor.backgroundcolor, size: 30),
                ),
              ],
            ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isReturn ? Colors.orange.shade700 : AppColor.backgroundcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                if (selectedProductUuid == null) {
                  showSnackbar("خطأ".tr, "الرجاء اختيار المنتج أولاً".tr, Colors.red);
                  return;
                }
                if (selectedQuantity <= 0) {
                  showSnackbar("خطأ".tr, "الكمية غير صالحة".tr, Colors.red);
                  return;
                }
                double selectedPieces = currentUnit == 'carton' && itemsPerCarton > 0 ? selectedQuantity * itemsPerCarton : selectedQuantity;
                if (selectedPieces > availableQuantity) {
                  showSnackbar("تنبيه".tr, "الكمية المطلوبة أكبر من المتاح".tr, Colors.orange);
                  return;
                }
                widget.onSubmit(selectedProductUuid!, selectedPieces);
              },
              child: Text(
                "تأكيد".tr,
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (widget.onTransferAll != null && widget.products.isNotEmpty) ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: widget.isReturn
                          ? Colors.orange.shade700
                          : AppColor.backgroundcolor,
                      width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  widget.onTransferAll!();
                },
                child: Text(
                  widget.isReturn ? "إرجاع كل المنتجات بالمخزون".tr : "تزويد كل المنتجات بالمخزون".tr,
                  style: TextStyle(
                      fontSize: 16,
                      color: widget.isReturn
                          ? Colors.orange.shade700
                          : AppColor.backgroundcolor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
