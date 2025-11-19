// import 'package:Silaaty/controller/Setteng/ZacatController.dart';
// import 'package:Silaaty/core/class/handlingview.dart';
// import 'package:Silaaty/core/constant/Colorapp.dart';
// import 'package:Silaaty/core/functions/valiedinput.dart';
// import 'package:Silaaty/view/widget/Zacat/CustemRow.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// import '../../core/constant/imageassets.DART';

// class Zakat extends StatefulWidget {
//   const Zakat({super.key});

//   @override
//   State<Zakat> createState() => _ZakatState();
// }

// class _ZakatState extends State<Zakat> {
//   Zacatcontroller controller = Get.put(Zacatcontroller());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       appBar: AppBar(
//         title: Text('Zakat'.tr,
//             style: Theme.of(context)
//                 .textTheme
//                 .headlineMedium!
//                 .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
//         backgroundColor: AppColor.white,
//         iconTheme: const IconThemeData(
//           color: AppColor.backgroundcolor,
//         ),
//       ),
//       body: Container(
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           child: GetBuilder<Zacatcontroller>(builder: (controller) {
//             if (controller.zakat.isEmpty) {
//               return Center(
//                 child: Lottie.asset(Appimageassets.loading, width: 190),
//               );
//             }

//             controller.totalzakat =
//                 (controller.zakat[0].zakatTotalAssetValue ?? 0) +
//                     (controller.zakat[0].zakatCashLiquidity ?? 0) +
//                     (controller.zakat[0].zakattotaldebortsvalue ?? 0) -
//                     (controller.zakat[0].zakattotaldebortsvalue ?? 0);

//             return Handlingview(
//                 statusrequest: controller.statusrequest,
//                 widget: ListView(
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.all(20),
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             // ignore: deprecated_member_use
//                             color: Colors.black.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 8,
//                             offset: const Offset(0, 0),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Custemrow(
//                             Title: "Total Asset Value".tr,
//                             Prise:
//                                 (controller.zakat[0].zakatTotalAssetValue ?? 0)
//                                     .toString(),
//                             DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Total Debts Value".tr,
//                             Prise: controller.zakat[0].zakattotaldebortsvalue ??
//                                 "0,00",
//                             DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Total Debtors Value".tr,
//                             Prise: controller.zakat[0].zakattotaldebortsvalue ??
//                                 "0,00",
//                             DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Liquidity".tr,
//                             Prise: controller.zakat[0].zakatCashLiquidity
//                                 .toString(),
//                             DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "zakat_mal".tr,
//                             Prise: controller.totalzakat.toString(),
//                             DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Current Nisab".tr,
//                             Prise: controller.zakat[0].zakatNisab.toString(),
//                             DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Above Nisab?".tr,
//                             Prise: controller.totalzakat >=
//                                     (controller.zakat[0].zakatNisab ?? 0)
//                                 ? "Yes".tr
//                                 : "no".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Zakat Due Amount".tr,
//                             Prise: "${controller.zakat[0].zakatDueAmount!} %",
//                             // DA: "DA".tr,
//                             fontSize: 20,
//                             color: AppColor.backgroundcolor,
//                             colorp: AppColor.grey,
//                           ),
//                           const SizedBox(height: 15),
//                           Container(
//                             color: Colors.grey[400],
//                             height: 1,
//                             width: double.infinity,
//                           ),
//                           const SizedBox(height: 15),
//                           Form(
//                               key: controller.formstate,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     controller:
//                                         controller.cashliquidityController,
//                                     keyboardType: TextInputType.number,
//                                     validator: (val) {
//                                       return validInput(
//                                           val!, 20, 0, "username");
//                                     },
//                                     decoration: InputDecoration(
//                                       errorStyle: const TextStyle(fontSize: 12),
//                                       labelText: "Cash Liquidity".tr,
//                                       suffixText: "DA".tr,
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton.icon(
//                                     onPressed: () {
//                                       controller.addliquidity(controller.zakat[0].uuid!);
//                                     },
//                                     icon: const Icon(
//                                       Icons.save,
//                                       color: AppColor.white,
//                                     ),
//                                     label: Text(
//                                       "save".tr,
//                                     ),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColor.backgroundcolor,
//                                       foregroundColor: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 12, horizontal: 20),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           const SizedBox(height: 15),
//                           Custemrow(
//                             Title: "Zakat Due".tr,
//                             Prise: controller.totalzakat >=
//                                     (controller.zakat[0].zakatNisab ?? 0)
//                                 ? (controller.zakat[0].zakatDue ?? 0).toString()
//                                 : "0.00",
//                             DA: "DA".tr,
//                             fontSize: 24,
//                             color: AppColor.grey,
//                             colorp: AppColor.grey,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.all(20),
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             // ignore: deprecated_member_use
//                             color: Colors.black.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 8,
//                             offset: const Offset(0, 0),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.info_outline, color: Colors.red),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child: Text(
//                             "noteDesperateClients".tr,
//                             style: TextStyle(
//                               color: Colors.red[700],
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           )),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.all(20),
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             // ignore: deprecated_member_use
//                             color: Colors.black.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 8,
//                             offset: const Offset(0, 0),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.info_outline, color: Colors.red),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child: Text(
//                             "zakatWarningNote".tr,
//                             style: TextStyle(
//                               color: Colors.red[700],
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           )),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ));
//           })),
//     );
//   }
// }
