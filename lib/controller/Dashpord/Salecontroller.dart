import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/class/Statusrequest.dart';
import '../../core/constant/Colorapp.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/FormatQuantity.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/SaleData.dart';
import '../../data/datasource/Remote/transactiondata.dart';

class SaleController extends GetxController {
  int? type;
  RxInt saleType = 1.obs; // 1 = Retail, 2 = Half Wholesale, 3 = Wholesale
  RxString globalSaleUnit = 'piece'.obs; // 'piece' or 'carton'
  
  void setGlobalSaleUnit(String unit) {
    globalSaleUnit.value = unit;
    update();
  }
  late int userSellType = Get.find<Myservices>().sharedPreferences?.getInt("sell_type") ?? 3;
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
        if (globalSaleUnit.value == 'carton' && product['type_item'] != 2) {
           num itemsPerCarton = num.tryParse(product['items_per_carton']?.toString() ?? '0') ?? 0;
           if (itemsPerCarton > 0) {
              product['quantity'] = itemsPerCarton.toDouble();
              product['entered_quantity'] = 1.0;
              product['sale_unit'] = 'carton';
              product['total'] = product['quantity'] * product[type == 1 ? 'price_Purchase' : 'price'];
           }
        }
        selectedProducts.add(product);
      }
    }

    _calculateTotals();
    update();
  }

  void updateQuantity(String uuid, num newQuantity, {String? unit, num? enteredQty}) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      // Convert to num to safely compare
      num maxQty = num.tryParse(item["quantity_item"].toString()) ?? 0;

      if (newQuantity <= maxQty || type == 1) {
        item['quantity'] = newQuantity;
        if (unit != null) item['sale_unit'] = unit;
        if (enteredQty != null) item['entered_quantity'] = enteredQty;

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

  bool updateProductPrice(String uuid, double newPrice) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      if (type != 1) {
        double minPrice = double.tryParse(item['min_selling_price']?.toString() ?? '0') ?? 0.0;
        
        if (minPrice > 0 && newPrice < minPrice) {
          showSnackbar("تنبيه".tr, "لا يمكن أن يكون سعر البيع أقل من الحد الأدنى: $minPrice", Colors.red);
          return false;
        }
      }

      if (type == 1) {
        item['price_Purchase'] = newPrice;
      } else {
        item['price'] = newPrice;
      }
      item['total'] = newPrice * item['quantity'];
      selectedProducts[index] = Map<String, dynamic>.from(item);
      _calculateTotals();
      update();
      return true;
    }
    return false;
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
                          formavalue(weight * unitPrice);
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
                          formavalue(price / unitPrice);
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
                  selectedProducts[existingIndex]['entered_quantity'] = (selectedProducts[existingIndex]['entered_quantity'] ?? 0) + weight;
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
                    "product_price": productData['product_price'],
                    "product_price_wholesale": productData['product_price_wholesale'],
                    "product_price_half_wholesale": productData['product_price_half_wholesale'],
                    "product_price_purchase": productData['product_price_purchase'],
                    "quantity": weight,
                    "entered_quantity": weight,
                    "sale_unit": "piece",
                    "total": price * weight,
                    "type_item": 2,
                    "quantity_item": productData['product_quantity'],
                    "items_per_carton": productData['items_per_carton'],
                    "min_selling_price": double.tryParse(productData['min_selling_price']?.toString() ?? '0') ?? 0.0,
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

  Map<String, dynamic>? pendingProduct;
  double? pendingAddedQuantity;
  double? pendingEnteredQuantity;
  int? pendingExistingIndex;

  void confirmPendingProduct() {
    if (pendingProduct == null) return;
    final uuid = pendingProduct!['uuid'] ?? pendingProduct!['id'] ?? '';
    final name = pendingProduct!['product_name'] ?? '';
    final price = _getSalePrice(pendingProduct!);
    final typeItem = pendingProduct!['type'];

    if (pendingExistingIndex != null && pendingExistingIndex != -1) {
      selectedProducts[pendingExistingIndex!]['quantity'] += pendingAddedQuantity!;
      selectedProducts[pendingExistingIndex!]['entered_quantity'] = (selectedProducts[pendingExistingIndex!]['entered_quantity'] ?? 0) + (pendingEnteredQuantity ?? pendingAddedQuantity!);
      selectedProducts[pendingExistingIndex!]['total'] = (type == 1
              ? selectedProducts[pendingExistingIndex!]['price_Purchase']
              : selectedProducts[pendingExistingIndex!]['price']) *
          selectedProducts[pendingExistingIndex!]['quantity'];
      selectedProducts[pendingExistingIndex!] =
          Map<String, dynamic>.from(selectedProducts[pendingExistingIndex!]);
    } else {
      selectedProducts.add({
        "uuid": uuid,
        "name": name,
        type == 1 ? "price_Purchase" : "price": price,
        "product_price": pendingProduct!['product_price'],
        "product_price_wholesale": pendingProduct!['product_price_wholesale'],
        "product_price_half_wholesale": pendingProduct!['product_price_half_wholesale'],
        "product_price_purchase": pendingProduct!['product_price_purchase'],
        "quantity": pendingAddedQuantity,
        "entered_quantity": pendingEnteredQuantity,
        "sale_unit": pendingProduct!['sale_unit'] ?? 'piece',
        "total": price * pendingAddedQuantity!,
        "type_item": typeItem,
        "quantity_item": pendingProduct!['product_quantity'],
        "items_per_carton": pendingProduct!['items_per_carton'],
        "min_selling_price": double.tryParse(pendingProduct!['min_selling_price']?.toString() ?? '0') ?? 0.0,
      });
    }

    _calculateTotals();
    pendingProduct = null;
    pendingAddedQuantity = null;
    pendingEnteredQuantity = null;
    pendingExistingIndex = null;
    lastScannedTime = null; // reset debounce
    update();
  }

  void cancelPendingProduct() {
    pendingProduct = null;
    pendingAddedQuantity = null;
    pendingEnteredQuantity = null;
    pendingExistingIndex = null;
    lastScannedTime = null; // reset debounce
    update();
  }

  String lastScannedCode = '';
  DateTime? lastScannedTime;

  search(String codepar) async {
    if (pendingProduct != null) return; // Prevent new scans while waiting for confirmation
    
    lastScannedCode = codepar;
    lastScannedTime = DateTime.now();

    // Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    update();
    String cleaned = codepar.replaceAll(RegExp(r'[^\d]'), '');
    print(cleaned);
    
    String searchCode = cleaned;
    double? scaleWeight;

    // Logic for Scale Barcode (EAN-13 starting with 2)
    // Common format: Prefix (2 digits) + Product Code (5 digits) + Weight (5 digits) + Checksum (1 digit)
    if (cleaned.length == 13 && cleaned.startsWith('25')) {
      searchCode = cleaned.substring(0, 7); // Extract prefix + product code (7 digits)
      String weightPart = cleaned.substring(7, 12); // Extract weight
      scaleWeight = double.tryParse(weightPart) != null
          ? double.parse(weightPart) / 1000.0 // Assuming grams to kg
          : null;
      print("⚖️  Scale Item Detected - Base Code: $searchCode, Weight: $scaleWeight kg");
    }

    Map<String, Object?> data = {
      "codepar": searchCode,
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
      int typeItem = int.tryParse(productData['type'].toString()) ?? 1;

      bool isScaleBarcode = cleaned.length == 13 && cleaned.startsWith('25');
      if (isScaleBarcode) {
        typeItem = 2; // Force to weighted item if a scale barcode is detected
      }

      final existingIndex =
          selectedProducts.indexWhere((item) => item['uuid'] == uuid);

      if (typeItem == 2 && (scaleWeight == null || scaleWeight == 0)) {
        showWeightDialog(productData,
            existingIndex: existingIndex != -1 ? existingIndex : null);
        return;
      }

      double addedQuantity = 1.0;
      double enteredQuantity = 1.0;
      String saleUnit = 'piece';

      if (typeItem == 2 && scaleWeight != null && scaleWeight != 0) {
        addedQuantity = scaleWeight;
        enteredQuantity = scaleWeight;
      } else {
        if (globalSaleUnit.value == 'carton') {
          num itemsPerCarton = num.tryParse(productData['items_per_carton']?.toString() ?? '0') ?? 0;
          if (itemsPerCarton > 0) {
            addedQuantity = itemsPerCarton.toDouble();
            enteredQuantity = 1.0;
            saleUnit = 'carton';
          }
        }
      }

      pendingProduct = productData;
      pendingProduct!['sale_unit'] = saleUnit;
      pendingAddedQuantity = addedQuantity;
      pendingEnteredQuantity = enteredQuantity;
      pendingExistingIndex = existingIndex;

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
      arguments: {
        "selectedProducts": selectedProducts,
        "type": type,
        "sale_type": saleType.value,
        "globalSaleUnit": globalSaleUnit.value
      },
    );
    if (result != null && result is List) {
      final updatedList = List<Map<String, dynamic>>.from(result);

      selectedProducts.clear();

      selectedProducts.addAll(updatedList);

      _calculateTotals();
      update();
    }
  }

  void addDraftedProduct(Map<String, dynamic> draftedProduct) {
    if (draftedProduct['is_draft'] == true) {
      selectedProducts.add({
        "uuid": draftedProduct['uuid'],
        "name": draftedProduct['product_name'],
        type == 1 ? "price_Purchase" : "price": double.tryParse(draftedProduct[type == 1 ? 'product_price_purchase' : 'product_price'].toString()) ?? 0.0,
        "product_price": draftedProduct['product_price'],
        "product_price_wholesale": draftedProduct['product_price_wholesale'],
        "product_price_half_wholesale": draftedProduct['product_price_half_wholesale'],
        "product_price_purchase": draftedProduct['product_price_purchase'],
        "quantity": 1,
        "total": double.tryParse(draftedProduct[type == 1 ? 'product_price_purchase' : 'product_price'].toString()) ?? 0.0,
        "type_item": draftedProduct['type'],
        "quantity_item": "9999", // Unconstrained for draft products
        "items_per_carton": draftedProduct['items_per_carton'],
        "min_selling_price": double.tryParse(draftedProduct['min_selling_price']?.toString() ?? '0') ?? 0.0,
        "draft_data": draftedProduct // Save the payload to insert on payment
      });
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
    if (type != 1) {
      selectedCustomer.value = "virtualCustomer".tr;
    } else {
      selectedCustomer.value = 'مورد'.tr;
    }
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
    
    saleType.value = newType;

    if (type != 1) {
      for (var i = 0; i < selectedProducts.length; i++) {
        var item = selectedProducts[i];
        
        // Recalculate price
        double newPrice = _getSalePrice(item);
        
        item['price'] = newPrice;
        item['total'] = newPrice * item['quantity'];
        
        selectedProducts[i] = Map<String, dynamic>.from(item);
      }
    }
    
    _calculateTotals();
    update();
  }

  @override
  void onInit() {
    final arge = Get.arguments;
    print("=========================${arge}");
    
    // First, set the type if passed in arguments
    if (arge != null && arge["type"] != null) {
      type = arge["type"];
    }

    // Now safely reset data according to the correct type
    resetData();

    // If specific customer details were passed, override the default
    if (arge != null && arge["name"] != null && arge["famlyname"] != null) {
      selectedName.value = arge["name"];
      selectedFamilyName.value = arge["famlyname"];
      selectedUuid.value = arge["uuid"] ?? '';
      selectedCustomer.value = '${selectedName.value} ${selectedFamilyName.value}';
    }

    print("================================${selectedCustomer.value}");
    super.onInit();
  }
}
