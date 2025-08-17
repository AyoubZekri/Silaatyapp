import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';

import 'package:Silaaty/data/model/Categoris_model.dart';
import 'package:Silaaty/data/model/Product_Model.dart' as Prodact;
import 'package:get/get.dart';

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

  Future<void> GotoIformationItem(int? id) async {
    final result = await Get.toNamed(
      Approutes.informationitem,
      arguments: {"id": id},
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
    statusrequestcat = Statusrequest.loadeng;
    update();
    var response = await categorisData.viewdata();
    print("============================================== $response");
    statusrequestcat = handlingData(response);
    if (statusrequestcat == Statusrequest.success && response["status"] == 1) {
      final model = Categoris_Model.fromJson(response);
      categories = model.data?.catdata ?? [];
    } else {
      statusrequestcat = Statusrequest.failure;
    }
    update();
  }

  getProdact(int? id) async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {
      "Categorie_id": 2,
      'Categoris_id': id,
    };
    var response = await prodactData.getCatProdactbytype(data);
    print("============================================== $response");
    print("$id");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final model = Prodact.Product_Model.fromJson(response);
        product = model.data ?? [];
        if (product.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  getProdactnotcat() async {
    statusrequest = Statusrequest.loadeng;
    update();
    Map data = {
      "Categoris_id": 2,
    };
    var response = await prodactData.getProdact(data);
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final model = Prodact.Product_Model.fromJson(response);
        product = model.data ?? [];
        if (product.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
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

    statusrequest = Statusrequest.loadeng;
    update();

    Map data = {
      "query": query,
      'categorie': 2,
    };
    var response = await prodactData.search(data);
    print("🔍 Search Response: $response");
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        final model = Prodact.Product_Model.fromJson(response);
        product = model.data ?? [];
      } else {
        statusrequest = Statusrequest.failure;
      }
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

  int selectedCategoryId = 0;
  void selectCategory(int id) {
    selectedCategoryId = id;
    getProdact(id);
    update();
  }

  refreshData() async {
    selectedCategoryId = 0;
    await getCategoris();
    await getProdactnotcat();
  }
}
