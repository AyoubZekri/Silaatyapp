import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';

import 'package:Silaaty/data/model/Categoris_model.dart' hide Data;
// ignore: library_prefixes
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/Snacpar.dart';
import '../../data/model/Product_Model.dart';

class Itemscontroller extends GetxController {
  int type = 0;
  int saleType = 1;
  String globalSaleUnit = 'piece';
  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());
  Myservices myservices = Get.find();

  List<Catdata> categories = [];
  List<Prodact.Data> product = [];
  List<Prodact.Data> prodactSearch = [];
  Map<String, List<Data>> _cachedSearch = {};
  Map<String, List<Data>> _cachedProducts = {};
  bool isSearching = false;

  final RxSet<String> selectedUuids = <String>{}.obs;

  final RxMap<String, num> quantities = <String, num>{}.obs;

  List<Map<String, dynamic>> originalSelectedProducts = [];

  bool isSelected(String uuid) =>
      selectedUuids.contains(uuid) && getQuantity(uuid) > 0;

  num getQuantity(String uuid) => quantities[uuid] ?? 0;

  void toggleSelect(String uuid, num maxQuantity) {
    if (selectedUuids.contains(uuid) || (maxQuantity == 0 && type == 0)) {
      // showSnackbar("error".tr, "غير متوفر", Colors.red);
      selectedUuids.remove(uuid);
      quantities[uuid] = 0;
    } else {
      selectedUuids.add(uuid);
      num qtyToAdd = 1;
      quantities[uuid] = qtyToAdd;
    }
    update();
  }

  void increment(String uuid, num maxQuantity, {num? val}) {
    final currentQty = getQuantity(uuid);
    num qtyToAdd = val ?? 1;

    if (type == 1) {
      quantities[uuid] = currentQty + qtyToAdd;
    } else {
      if (currentQty + qtyToAdd > maxQuantity) {
        quantities[uuid] = maxQuantity;
      } else {
        quantities[uuid] = currentQty + qtyToAdd;
      }
    }
    selectedUuids.add(uuid);
    update();
  }

  void decrement(String uuid) {
    final q = getQuantity(uuid);
    if (q <= 1) {
      quantities[uuid] = 0;
      selectedUuids.remove(uuid);
    } else {
      quantities[uuid] = q - 1;
    }
    update();
  }

  void clearSelection() {
    selectedUuids.clear();
    quantities.clear();
    update();
  }

  Statusrequest statusrequest = Statusrequest.none;
  Statusrequest statusrequestcat = Statusrequest.none;

  // late int catid;

  // ignore: non_constant_identifier_names
  Future<void> GotoIformationItem(String? uuid) async {
    final result = await Get.toNamed(
      Approutes.informationitem,
      arguments: {"uuid": uuid},
    );

    if (result == true) {
      print("======$selectedCategoryId");
      _cachedProducts.clear();
      await getProdactnotcat();
    }
  }

  List<Map> getSelectedProducts() {
    return selectedUuids
        .map((uuid) {
          final item = product.firstWhereOrNull((e) => e.uuid == uuid);
          if (item != null) {
            num enteredQty = quantities[uuid] ?? 1;
            num qty = enteredQty;
            
            if (globalSaleUnit == 'carton' && item.type != 2) {
              num itemsPerCarton = num.tryParse(item.itemsPerCarton?.toString() ?? '0') ?? 0;
              if (itemsPerCarton > 0) {
                qty = enteredQty * itemsPerCarton;
              }
            }
            
            final price = type == 1 ? (item.productPricePurchase?.toDouble() ?? 0.0) : getSalePrice(item);
            
            return {
              "uuid": item.uuid,
              "name": item.productName,
              "price": getSalePrice(item),
              "product_price": item.productPrice,
              "product_price_wholesale": item.productPriceWholesale,
              "product_price_half_wholesale": item.productPriceHalfWholesale,
              "product_price_purchase": item.productPricePurchase,
              "price_Purchase": item.productPricePurchase,
              "quantity": qty,
              "entered_quantity": enteredQty,
              "sale_unit": globalSaleUnit,
              "total": qty * price,
              "quantity_item": item.productQuantity,
              "type_item": item.type,
              "min_selling_price": item.minSellingPrice ?? 0.0,
              "items_per_carton": item.itemsPerCarton,
            };
          } else {
            final originalItem = originalSelectedProducts.firstWhereOrNull((e) => e['uuid'] == uuid);
            if (originalItem != null) {
              final updatedItem = Map<String, dynamic>.from(originalItem);
              num enteredQty = quantities[uuid] ?? 1;
              updatedItem['entered_quantity'] = enteredQty;
              
              if (updatedItem['sale_unit'] == 'carton' && updatedItem['type_item'] != 2) {
                 num itemsPerCarton = num.tryParse(updatedItem['items_per_carton']?.toString() ?? '0') ?? 0;
                 if (itemsPerCarton > 0) {
                    updatedItem['quantity'] = enteredQty * itemsPerCarton;
                 } else {
                    updatedItem['quantity'] = enteredQty;
                 }
              } else {
                 updatedItem['quantity'] = enteredQty;
              }
              
              final price = type == 1 ? (updatedItem['price_Purchase'] ?? 0.0) : (updatedItem['price'] ?? 0.0);
              updatedItem['total'] = updatedItem['quantity'] * price;
              return updatedItem;
            }
          }
          return {};
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Gotoback() {
    final selected = getSelectedProducts();
    print("==============================$selected");
    Get.back(result: selected);
  }

  double getSalePrice(Prodact.Data item) {
    if (type == 1) {
      return item.productPricePurchase?.toDouble() ?? 0.0;
    }

    double retailPrice = item.productPrice?.toDouble() ?? 0.0;

    if (saleType == 3) {
      double wholesalePrice = item.productPriceWholesale?.toDouble() ?? 0.0;
      return wholesalePrice > 0 ? wholesalePrice : retailPrice;
    } else if (saleType == 2) {
      double halfWholesalePrice = item.productPriceHalfWholesale?.toDouble() ?? 0.0;
      return halfWholesalePrice > 0 ? halfWholesalePrice : retailPrice;
    }

    return retailPrice;
  }

  getCategoris() async {
    try {
      var response = await categorisData.viewdata();

      print("============================================== $response");

      if (response.isNotEmpty) {
        categories = (response as List)
            .map((e) => Catdata.fromJson(e as Map<String, dynamic>))
            .toList();
        statusrequest = Statusrequest.success;
      } else {
        statusrequest = Statusrequest.failure;
      }
    } catch (e) {
      print("❌ getcat error: $e");
      statusrequest = Statusrequest.serverfailure;
    }

    update();
  }

  getProdact(String? uuid) async {
    if (_cachedProducts.containsKey(uuid)) {
      product = _cachedProducts[uuid]!;
      statusrequest = Statusrequest.success;
      update();
      return;
    }

    Map<String, Object?> data = {
      "Categorie_id": 1,
      "Categoris_uuid": uuid,
    };

    var result = await prodactData.getCatProdactbytype(data);
    print("============================================== $result");

    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      _cachedProducts[uuid ?? "default"] = product;

      statusrequest =
          product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
    } else {
      product = [];
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  searchBarcode(String codepar) async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    update();

    String cleaned = codepar.replaceAll(RegExp(r'[^\d]'), '');

    // if (cleaned.length <= 9) {
    //   cleaned = cleaned.substring(1);
    // }
    print("====== CLEANED: $cleaned");

    Map<String, Object?> data = {
      "codepar": cleaned,
    };

    var result = await prodactData.searchpro(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      final res = await Get.toNamed(
        Approutes.informationitem,
        arguments: {"uuid": result.first['uuid']},
      );

      if (res == true) {
        print("======$selectedCategoryId");
        _cachedProducts.clear();
        await getProdactnotcat();
      }
      statusrequest = Statusrequest.success;
    } else {
      showSnackbar("تنبيه".tr, "المنتج غير موجود".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  search(String query) async {
    if (query.isEmpty) {
      isSearching = false;
      product = [];
      _cachedSearch.clear();
      selectedCategoryId.isNotEmpty
          ? getProdact(selectedCategoryId)
          : getProdactnotcat();
      return;
    }

    if (_cachedSearch.containsKey(query)) {
      product = _cachedSearch[query]!;
      isSearching = true;
      statusrequest = Statusrequest.success;
      update();
      return;
    }

    isSearching = true;
    prodactSearch.clear;
    update();

    Map<String, Object?> data = {
      "query": query,
      'Categorie_id': 1,
    };

    var result = await prodactData.search(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      _cachedSearch[query] = product;

      statusrequest =
          product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
    } else {
      product = [];
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  getProdactnotcat() async {
    const String key = "no_category";

    if (_cachedProducts.containsKey(key)) {
      print("=======================ok");
      product = _cachedProducts[key]!;
      statusrequest = Statusrequest.success;
      update();
      return;
    }
    update();
    Map<String, Object?> data = {
      "Categoris_id": 1,
    };
    var result = await prodactData.getProdact(data);
    print("============================================== $result");
    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      _cachedProducts[key] = product;

      statusrequest =
          product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
    } else {
      product = [];
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  @override
  void onInit() {
    selectedCategoryId = "";
    getCategoris();
    print("==========================================");
    getProdactnotcat();
    print(
        "==========================================Product=====================");
    FirebaseMessaging.instance.subscribeToTopic("users");
    FirebaseMessaging.instance.getInitialMessage();
    final args = Get.arguments;
    if (args != null && args['selectedProducts'] != null) {
      final List<Map<String, dynamic>> selected =
          List<Map<String, dynamic>>.from(args['selectedProducts']);
      originalSelectedProducts = selected;
      type = args["type"] ?? 0;
      saleType = args["sale_type"] ?? 1;
      globalSaleUnit = args["globalSaleUnit"] ?? 'piece';
      print("=============================type$type, saleType$saleType, globalSaleUnit$globalSaleUnit");
      for (var p in selected) {
        final uuid = p['uuid'];
        final qty = p['entered_quantity'] ?? p['quantity'] ?? 1;
        selectedUuids.add(uuid);
        quantities[uuid] = qty is int ? qty : (qty as num);
      }
    }
    super.onInit();
  }

  String selectedCategoryId = "";

  selectCategory(String uuid) {
    selectedCategoryId = uuid;
    if (uuid.isEmpty) {
      getProdactnotcat();
    } else {
      getProdact(uuid);
    }
    update();
  }

  refreshData() async {
    selectedCategoryId = "";
    await getCategoris();
    await getProdactnotcat();
  }

  Future<void> GotoAddaitems(int? id) async {
    final result =
        await Get.toNamed(Approutes.Additem, arguments: {"catid": id});
    if (result == true) {
      _cachedProducts.clear();
      await getProdactnotcat();
    }
  }
}
