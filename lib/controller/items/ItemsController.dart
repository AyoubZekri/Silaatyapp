import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';

import 'package:Silaaty/data/model/Categoris_model.dart' hide Data;
// ignore: library_prefixes
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../data/model/Product_Model.dart';

class Itemscontroller extends GetxController {
  int type = 0;
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

  final RxMap<String, int> quantities = <String, int>{}.obs;

  bool isSelected(String uuid) =>
      selectedUuids.contains(uuid) && getQuantity(uuid) > 0;

  int getQuantity(String uuid) => quantities[uuid] ?? 0;

  void toggleSelect(String uuid, int maxQuantity) {
    if (selectedUuids.contains(uuid) || (maxQuantity == 0 && type != 1)) {
      // showSnackbar("error".tr, "غير متوفر", Colors.red);
      selectedUuids.remove(uuid);
      quantities[uuid] = 0;
    } else {
      selectedUuids.add(uuid);
      quantities[uuid] = 1;
    }
    update();
  }

  void increment(String uuid, int maxQuantity) {
    final currentQty = getQuantity(uuid);
    if (currentQty < maxQuantity || type == 1) {
      quantities[uuid] = currentQty + 1;
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
            return {
              "uuid": item.uuid,
              "name": item.productName,
              "price": item.productPrice,
              "price_Purchase": item.productPricePurchase,
              "quantity": quantities[uuid] ?? 1,
              "quantity_item": item.productQuantity,
            };
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
      type = args["type"] ?? 0;
      for (var p in selected) {
        final uuid = p['uuid'];
        final qty = p['quantity'] ?? 1;
        selectedUuids.add(uuid);
        quantities[uuid] = qty;
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
