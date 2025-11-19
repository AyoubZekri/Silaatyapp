// import 'package:Silaaty/core/class/Statusrequest.dart';
// import 'package:Silaaty/core/constant/routes.dart';
// import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
// import 'package:Silaaty/core/services/Services.dart';
// import 'package:Silaaty/data/datasource/Remote/Prodact/Prodact_data.dart';
// import 'package:Silaaty/data/datasource/Remote/Zakat/Zakat_data.dart';
// import 'package:Silaaty/data/model/Product_Model_Zakat.dart';
// import 'package:Silaaty/data/model/Zakat_Model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/functions/Snacpar.dart';

// class Zacatcontroller extends GetxController {
//   Future<void> GotoProdactDitails(int? id) async {
//     await Get.toNamed(Approutes.informationitem, arguments: {"id": id});
//   }

//   final cashliquidityController = TextEditingController();
//   late double totalzakat;
//   GlobalKey<FormState> formstate = GlobalKey<FormState>();

//   ZakatData zakatdata = ZakatData();
//   ProdactData prodactData = ProdactData(Get.find());

//   Myservices myservices = Get.find();

//   List<Data_model> zakat = [];
//   List<Data> productzakat = [];
//   var SumTotalPrise;

//   Statusrequest statusrequest = Statusrequest.none;
//   getZakat() async {
//     update();
//     var result = await zakatdata.getZakat();
//     print("===================================$result");
//     if (result["status"] == 1) {
//       final model = Zakat_Model.fromJson(result);
//       zakat = model.data ?? [];
//       statusrequest = Statusrequest.success;
//     } else {
//       statusrequest = Statusrequest.failure;
//     }
//     update();
//   }

//   addliquidity(String uuid) async {
//     if (formstate.currentState!.validate()) {
//       update();
//       Map<String, Object?> data = {
//         'zakat_Cash_liquidity': cashliquidityController.text,
//         "uuid": uuid
//       };
//       var result = await zakatdata.addCashliquidity(data);

//       print("==================================================$result");
//       if (result["status"] == 1) {
//         statusrequest = Statusrequest.success;

//         cashliquidityController.clear();
//         getZakat();
//         showSnackbar("success".tr, "operationSuccess".tr, Colors.green);
//       } else {
//         showSnackbar("error".tr, "operationFailed".tr, Colors.red);
//       }
//     }
//   }

//   @override
//   void onInit() {
//     getZakat();

//     super.onInit();
//   }
// }
