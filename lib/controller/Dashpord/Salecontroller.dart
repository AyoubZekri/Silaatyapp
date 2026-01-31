import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/class/Statusrequest.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/Snacpar.dart';
import '../../data/datasource/Remote/SaleData.dart';
import '../../data/datasource/Remote/transactiondata.dart';

class SaleController extends GetxController {
  var selectedCustomer = 'العميل'.tr.obs;

  final customers = ["virtualCustomer".tr, 'اختر عميل'.tr, 'عميل جديد'.tr];

  var selectedUuid = ''.obs;

  var selectedName = ''.obs;
  var selectedFamilyName = ''.obs;
  int? type;

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

  void updateQuantity(String uuid, int newQuantity) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      if (newQuantity <= int.parse(item["quantity_item"])) {
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

  void deleteProduct(String uuid) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      selectedProducts.removeAt(index);
      _calculateTotals();
      update();
    }
  }

  void _calculateTotals() {
    totalItems = selectedProducts.length;
    totalallPrice = selectedProducts.fold(
      0.0,
      (sum, item) =>
          sum +
          (type == 1
              ? item['price_Purchase'] * item['quantity']
              : item['price'] * item['quantity']),
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

    if (value == 'اختر عميل'.tr) {
      var result = await Get.toNamed(Approutes.client, arguments: {"type": 2});

      if (result != null) {
        selectedUuid.value = result['uuid'] ?? '';
        selectedName.value = result['name'] ?? '';
        selectedFamilyName.value = result['famlyname'] ?? '';

        selectedCustomer.value =
            '${selectedName.value} ${selectedFamilyName.value}';
      }
    } else if (value == 'عميل جديد'.tr) {
      var result = await Get.toNamed(Approutes.AddConvict);

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
    update();

    Map<String, Object?> data = {
      "codepar": codepar,
    };

    var result = await saledata.searchpro(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      Map<String, dynamic> product;

      product = Map<String, dynamic>.from(result.first);

      final uuid = product['uuid'] ?? product['id'] ?? '';
      final name = product['product_name'] ?? '';
      final price = type == 1
          ? double.tryParse(product['product_price_purchase'].toString()) ?? 0.0
          : double.tryParse(product['product_price'].toString()) ?? 0.0;

      final existingIndex =
          selectedProducts.indexWhere((item) => item['uuid'] == uuid);

      if (existingIndex != -1) {
        selectedProducts[existingIndex]['quantity'] += 1;
        selectedProducts[existingIndex]['total'] = type == 1
            ? selectedProducts[existingIndex]['price_Purchase']
            : selectedProducts[existingIndex]['price'] *
                selectedProducts[existingIndex]['quantity'];
      } else {
        selectedProducts.add({
          "uuid": uuid,
          "name": name,
          type == 1 ? "price_Purchase" : "price": price,
          "quantity": 1,
          "total": price,
        });
      }

      _calculateTotals();
      Get.back();
      statusrequest = Statusrequest.success;
    } else {
      Get.back();
      showSnackbar("تنبيه".tr, "المنتج غير موجود".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
      update();
    }
    update();
  }

  void gotoaddproductNewSale() async {
    final result = await Get.toNamed(
      Approutes.addProductSale,
      arguments: {"selectedProducts": selectedProducts, "type": type},
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
    if (selectedCustomer.value == 'العميل'.tr ||
        selectedCustomer.value == 'عميل جديد'.tr ||
        selectedCustomer.value == 'اختر عميل'.tr) {
      showSnackbar("تنبيه".tr, "يرجى اختيار العميل أولاً".tr, Colors.orange);
      return;
    }

    if (selectedProducts.isEmpty) {
      showSnackbar("تنبيه".tr, "لا توجد منتجات حالياً، أضف منتج أولاً.".tr,
          Colors.orange);

      return;
    }
    Get.toNamed(Approutes.payment, arguments: {
      "products": selectedProducts,
      "uuid": selectedUuid.value,
      "name": selectedName.value,
      "type": type,
      "famlyname": selectedFamilyName.value,
      "totalprice": totalallPrice,
      "selectedCustomer": selectedCustomer.value
    })?.then((result) {
      if (result == true) {
        resetData();
      }
    });
  }

  void resetData() {
    selectedCustomer.value = 'العميل'.tr;
    selectedUuid.value = '';
    selectedName.value = '';
    selectedFamilyName.value = '';
    selectedProducts.clear();
    totalallPrice = 0.0;
    totalItems = 0;
    type = 0;
    update();
  }

  @override
  void onInit() {
    resetData();
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
