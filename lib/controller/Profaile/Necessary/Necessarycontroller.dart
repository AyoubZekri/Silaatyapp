import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';

import 'package:Silaaty/data/model/Categoris_model.dart' hide Data;
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:get/get.dart';

import '../../../data/model/Product_Model.dart';

class Necessarycontroller extends GetxController {
  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());
  Myservices myservices = Get.find();

  List<Catdata> categories = [];
  List<Prodact.Data> product = [];
  bool isSearching = false;

  Statusrequest statusrequest = Statusrequest.none;
  Statusrequest statusrequestcat = Statusrequest.none;

  // late int catid;

  Future<void> GotoIformationItem(String? uuid) async {
    final result = await Get.toNamed(
      Approutes.informationitem,
      arguments: {"uuid": uuid},
    );

    if (result == true) {
      selectedCategoryId == 0
          ? await getProdactnotcat()
          : await getProdact(selectedCategoryId);
    }
  }

  Future<void> GotoAddaitems(int? id) async {
    final result =
        await Get.toNamed(Approutes.Additem, arguments: {"catid": id});
    if (result == true) {
      selectedCategoryId == 0
          ? await getProdactnotcat()
          : await getProdact(selectedCategoryId);
    }
  }

  getCategoris() async {
    try {
      update();
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


    Map<String, Object?> data = {
      "Categorie_id": 2,
      "Categoris_uuid": uuid,
    };

    var result = await prodactData.getCatProdactbytype(data);
    print("============================================== $result");

    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      statusrequest =
          product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
    } else {
      product = [];
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  getProdactnotcat() async {

    Map<String, Object?> data = {
      "Categoris_id": 2,
    };
    var result = await prodactData.getProdact(data);
    print("============================================== $result");
    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

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
      getProdact(selectedCategoryId);
      return;
    }

    isSearching = true;

 

    Map data = {
      "query": query,
      'Categorie_id': 2,
    };
    var result = await prodactData.search(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

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
    getCategoris();
    print("==========================================");
    getProdactnotcat();
    print(
        "==========================================Product=====================");

    super.onInit();
  }

  String selectedCategoryId = "";
  void selectCategory(String uuid) {
    selectedCategoryId = uuid;
    getProdact(uuid);
    update();
  }

  refreshData() async {
    selectedCategoryId = "";
    await getCategoris();
    await getProdactnotcat();
  }
}
