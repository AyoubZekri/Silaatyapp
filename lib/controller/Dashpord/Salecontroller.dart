import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/class/Statusrequest.dart';
import '../../core/constant/Colorapp.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/Snacpar.dart';
import '../../data/datasource/Remote/SaleData.dart';
import '../../data/datasource/Remote/transactiondata.dart';

class SaleController extends GetxController {
  int? type;
  RxInt saleType = 1.obs; // 1 = Retail, 2 = Half Wholesale, 3 = Wholesale
  RxString selectedCustomer = ''.obs;
  List<String> get customers => [
        if (type != 1) "virtualCustomer".tr,
        type == 1 ? 'اختر مورد'.tr : 'اختر عميل'.tr,
        type == 1 ? 'مورد جديد'.tr : 'عميل جديد'.tr
      ];

  var selectedUuid = ''.obs;

  var selectedName = ''.obs;
  var selectedFamilyName = ''.obs;

  final Transactiondata transactiondata = Transactiondata(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  Saledata saledata = Saledata();
  RxList<Map<String, dynamic>> selectedProducts = <Map<String, dynamic>>[].obs;

  double totalallPrice = 0.0;
  int totalItems = 0;

  void addProducts(List<Map<String, dynamic>> products) {
    for (var product in products) {
      final exists = selectedProducts.any((p) => p['uuid'] == product['uuid']);
      if (!exists) {
        selectedProducts.add(product);
      }
    }

    _calculateTotals();
    update();
  }

  void updateQuantity(String uuid, num newQuantity) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      // Convert to num to safely compare
      num maxQty = num.tryParse(item["quantity_item"].toString()) ?? 0;

      if (newQuantity <= maxQty || type == 1) {
        item['quantity'] = newQuantity;

        final price = type == 1
            ? (item['price_Purchase'] ?? 0) as num
            : (item['price'] ?? 0) as num;
        item['total'] = price * newQuantity;

        selectedProducts[index] = Map<String, dynamic>.from(item);

        _calculateTotals();
        update();
      } else {
        showSnackbar("خطأ".tr, "الكمية غير متوفرة".tr, Colors.red);
        print("===========error");
      }
    }
  }

  void updateProductPrice(String uuid, double newPrice) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      if (type == 1) {
        item['price_Purchase'] = newPrice;
      } else {
        item['price'] = newPrice;
      }
      item['total'] = newPrice * item['quantity'];
      selectedProducts[index] = Map<String, dynamic>.from(item);
      _calculateTotals();
      update();
    }
  }

  void deleteProduct(String uuid) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      selectedProducts.removeAt(index);
      _calculateTotals();
      update();
    }
  }

  double _getSalePrice(Map<String, dynamic> productData) {
    if (type == 1) {
      return double.tryParse(productData['product_price_purchase'].toString()) ?? 0.0;
    }
    
    double retailPrice = double.tryParse(productData['product_price'].toString()) ?? 0.0;
    
    if (saleType.value == 3) {
      double wholesalePrice = double.tryParse(productData['product_price_wholesale'].toString()) ?? 0.0;
      return wholesalePrice > 0 ? wholesalePrice : retailPrice;
    } else if (saleType.value == 2) {
      double halfWholesalePrice = double.tryParse(productData['product_price_half_wholesale'].toString()) ?? 0.0;
      return halfWholesalePrice > 0 ? halfWholesalePrice : retailPrice;
    }
    
    return retailPrice;
  }

  void _calculateTotals() {
    totalItems = selectedProducts.length;
    totalallPrice = selectedProducts.fold(
      0.0,
      (sum, item) =>
          sum +
          ((type == 1 ? item['price_Purchase'] : item['price']) *
              item['quantity']),
    );
  }

  void showWeightDialog(Map<String, dynamic> productData,
      {int? existingIndex}) {
    TextEditingController weightController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    final unitPrice = _getSalePrice(productData);

    Get.dialog(
      AlertDialog(
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
                productData['product_name'] ?? "",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                  suffixIcon: const Icon(
                    Icons.scale_outlined,
                    color: AppColor.backgroundcolor,
                  ),
                ),
                onChanged: (val) {
                  if (unitPrice > 0) {
                    double? weight = double.tryParse(val);
                    if (weight != null) {
                      totalPriceController.text =
                          (weight * unitPrice).toStringAsFixed(2);
                    } else {
                      totalPriceController.clear();
                    }
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: totalPriceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                  suffixIcon: const Icon(
                    Icons.payments_outlined,
                    color: AppColor.backgroundcolor,
                  ),
                ),
                onChanged: (val) {
                  if (unitPrice > 0) {
                    double? price = double.tryParse(val);
                    if (price != null) {
                      weightController.text =
                          (price / unitPrice).toStringAsFixed(3);
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
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              double? weight = double.tryParse(weightController.text);
              if (weight != null && weight > 0) {
                final uuid = productData['uuid'] ?? productData['id'] ?? '';
                final name = productData['product_name'] ?? '';
                final price = _getSalePrice(productData);

                if (existingIndex != null) {
                  selectedProducts[existingIndex]['quantity'] += weight;
                  selectedProducts[existingIndex]['total'] = (type == 1
                          ? selectedProducts[existingIndex]['price_Purchase']
                          : selectedProducts[existingIndex]['price']) *
                      selectedProducts[existingIndex]['quantity'];
                  selectedProducts[existingIndex] = Map<String, dynamic>.from(
                      selectedProducts[existingIndex]);
                } else {
                  selectedProducts.add({
                    "uuid": uuid,
                    "name": name,
                    type == 1 ? "price_Purchase" : "price": price,
                    "quantity": weight,
                    "total": price * weight,
                    "type_item": 2,
                    "quantity_item": productData['product_quantity'],
                  });
                }
                _calculateTotals();
                update();
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundcolor,
            ),
            child: Text(
              "Add".tr,
              style: const TextStyle(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  double get totalPrice => selectedProducts.fold(
        0.0,
        (sum, p) =>
            sum +
            ((type == 1 ? p['price_Purchase'] : p['price']) *
                (p["quantity"] ?? 1)),
      );

  void selectCustomer(String value) async {
    selectedCustomer.value = value;

    if (value == 'اختر عميل'.tr || value == 'اختر مورد'.tr) {
      var result = await Get.toNamed(Approutes.client,
          arguments: {"type": type == 1 ? 1 : 2});
      if (result != null) {
        selectedUuid.value = result['uuid'] ?? '';
        selectedName.value = result['name'] ?? '';
        selectedFamilyName.value = result['famlyname'] ?? '';
        selectedCustomer.value =
            '${selectedName.value} ${selectedFamilyName.value}';
        print("===================$selectedCustomer");
      }
    } else if (value == 'عميل جديد'.tr || value == 'مورد جديد'.tr) {
      var result = await Get.toNamed(
          type == 1 ? Approutes.AddDealer : Approutes.AddConvict,
          arguments: {"type": type == 1 ? 1 : 2});
      print("===================$result");
      if (result != null) {
        selectedUuid.value = result['uuid'] ?? '';
        selectedName.value = result['name'] ?? '';
        selectedFamilyName.value = result['famlyname'] ?? '';

        selectedCustomer.value =
            '${selectedName.value} ${selectedFamilyName.value}';
      }
    } else {
      // Walk-in customer
      selectedUuid.value = '';
      selectedName.value = '';
      selectedFamilyName.value = '';
    }
  }

  search(String codepar) async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    update();
    String cleaned = codepar.replaceAll(RegExp(r'[^\d]'), '');
    print(cleaned);
    double? scaleWeight;

    // Logic for Scale Barcode (EAN-13 starting with 2)
    // Common format: 2 (1 digit) + Product Code (5 digits) + Weight/Price (5 digits) + Check (1 digit)
    if (cleaned.length == 13 && cleaned.startsWith('2')) {
      // searchCode =
      //     cleaned.substring(1, 7); // Extract product code (e.g. 5 or 6 digits)
      String weightPart = cleaned.substring(7, 12); // Extract weight
      scaleWeight = double.tryParse(weightPart) != null
          ? double.parse(weightPart) / 1000.0 // Assuming grams to kg
          : null;
      print("⚖️  Weight $scaleWeight");
    }

    Map<String, Object?> data = {
      "codepar": cleaned,
    };

    print("==================$cleaned");

    var result = await saledata.searchpro(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      Map<String, dynamic> productData;
      productData = Map<String, dynamic>.from(result.first);

      final uuid = productData['uuid'] ?? productData['id'] ?? '';
      final name = productData['product_name'] ?? '';
      final price = _getSalePrice(productData);
      final typeItem = productData['type'];

      final existingIndex =
          selectedProducts.indexWhere((item) => item['uuid'] == uuid);

      if (typeItem == 2 && scaleWeight == null) {
        showWeightDialog(productData,
            existingIndex: existingIndex != -1 ? existingIndex : null);
        return;
      }

      double addedQuantity =
          (typeItem == 2 && scaleWeight != null) ? scaleWeight : 1.0;

      if (existingIndex != -1) {
        selectedProducts[existingIndex]['quantity'] += addedQuantity;
        selectedProducts[existingIndex]['total'] = (type == 1
                ? selectedProducts[existingIndex]['price_Purchase']
                : selectedProducts[existingIndex]['price']) *
            selectedProducts[existingIndex]['quantity'];
        selectedProducts[existingIndex] =
            Map<String, dynamic>.from(selectedProducts[existingIndex]);
      } else {
        selectedProducts.add({
          "uuid": uuid,
          "name": name,
          type == 1 ? "price_Purchase" : "price": price,
          "quantity": addedQuantity,
          "total": price * addedQuantity,
          "type_item": typeItem,
          "quantity_item": productData['product_quantity'],
        });
      }

      _calculateTotals();
      statusrequest = Statusrequest.success;
    } else {
      showSnackbar("تنبيه".tr, "المنتج غير موجود".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
      update();
    }
    update();
  }

  void gotoaddproductNewSale() async {
    final result = await Get.toNamed(
      Approutes.addProductSale,
      arguments: {"selectedProducts": selectedProducts, "type": type, "sale_type": saleType.value},
    );
    if (result != null && result is List) {
      final updatedList = List<Map<String, dynamic>>.from(result);

      selectedProducts.clear();

      selectedProducts.addAll(updatedList);

      _calculateTotals();
      update();
    }
  }

  void gotoPayment() {
    if (selectedCustomer.value == (type == 1 ? 'مورد'.tr : 'العميل'.tr) ||
        selectedCustomer.value ==
            (type == 1 ? 'مورد جديد'.tr : 'عميل جديد'.tr) ||
        selectedCustomer.value ==
            (type == 1 ? 'اختر مورد'.tr : 'اختر عميل'.tr,)) {
      showSnackbar(
          "تنبيه".tr,
          type == 1
              ? "يرجى اختيار مورد أولاً".tr
              : "يرجى اختيار العميل أولاً".tr,
          Colors.orange);
      return;
    }

    if (selectedProducts.isEmpty) {
      showSnackbar("تنبيه".tr, "لا توجد منتجات حالياً، أضف منتج أولاً.".tr,
          Colors.orange);

      return;
    }
    print("===================$type");
    Get.toNamed(Approutes.payment, arguments: {
      "products": selectedProducts,
      "uuid": selectedUuid.value,
      "name": selectedName.value,
      "type": type,
      "sale_type": saleType.value,
      "famlyname": selectedFamilyName.value,
      "totalprice": totalallPrice,
      "selectedCustomer": selectedCustomer.value
    })?.then((result) {
      if (result == true) {
        resetData();
        final arge = Get.arguments;
        if (arge != null) {
          type = arge["type"];
        }
      }
    });
  }

  void resetData() {
    selectedCustomer.value = type == 1 ? 'مورد'.tr : 'العميل'.tr;
    selectedUuid.value = '';
    selectedName.value = '';
    selectedFamilyName.value = '';
    selectedProducts.clear();
    saleType.value = 1;
    totalallPrice = 0.0;
    totalItems = 0;
    update();
  }

  void changeSaleType(int newType) {
    if (saleType.value == newType) return;
    
    if (selectedProducts.isNotEmpty) {
      Get.defaultDialog(
        title: "تنبيه".tr,
        middleText: "تغيير نوع البيع سيؤدي إلى إفراغ القائمة. هل توافق؟".tr,
        onConfirm: () {
          saleType.value = newType;
          selectedProducts.clear();
          _calculateTotals();
          update();
          Get.back();
        },
        onCancel: () {},
        textConfirm: "نعم".tr,
        textCancel: "لا".tr,
        confirmTextColor: AppColor.white,
      );
    } else {
      saleType.value = newType;
      update();
    }
  }

  @override
  void onInit() {
    resetData();
    selectedCustomer = (type == 1 ? 'مورد'.tr : 'العميل'.tr).obs;
    print("=========================${selectedCustomer.value}");
    final arge = Get.arguments;
    print("=========================${arge}");
    if (arge != null) {
      selectedName.value = arge["name"];
      selectedFamilyName.value = arge["famlyname"];
      selectedUuid.value = arge["uuid"];
      type = arge["type"];
      selectedCustomer.value =
          '${selectedName.value} ${selectedFamilyName.value}';
    }

    print("================================${selectedCustomer.value}");
    super.onInit();
  }
}
