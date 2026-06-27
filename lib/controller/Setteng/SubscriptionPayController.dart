import 'dart:async';

import 'package:Silaaty/core/functions/CheckInternat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/SubscriptionPayData.dart';
import '../../data/model/ChargilyPaymentModel.dart';
import '../../view/screen/ChargilyWebViewScreen.dart';

class SubscriptionPayController extends GetxController {
  int selectedPlanIndex = 1;
  bool isLoadingPay = false;
  Timer? _timer;
  Myservices myservices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  SubscriptionPayData subscriptionPayData = SubscriptionPayData(Get.find());
  String get expiryDate =>
      myservices.sharedPreferences!.getString("date_experiment") ?? "غير محدد";
  int get status =>
      myservices.sharedPreferences!.getInt("Status") ?? 0;
  // List<ChargilyPayment> data = [];

  final List<Map<String, dynamic>> plans = [
    {
      "title": "الخطة الشهرية",
      "price": "1,500 DA",
      "period": "شهرياً",
      "badge": null,
      "desc": "مناسبة للتجربة السريعة والبدء",
    },
    {
      "title": "الخطة السنوية",
      "price": "5,000 DA",
      "period": "سنوياً",
      "badge": "أفضل قيمة (توفير 33%)",
      "desc": "الخيار الأكثر شعبية وملاءمة لأصحاب المتاجر",
    },
    // {
    //   "title": "الخطة الدائمة",
    //   "price": "25,000 DA",
    //   "period": "مدى الحياة",
    //   "badge": "دفعة واحدة للأبد",
    //   "desc": "امتلاك كامل بدون أي تجديدات مستقبلية",
    // },
  ];

  final List<String> features = [
    "إضافة عدد لا محدود من المنتجات والمبيعات والموردين",
    "إدارة المخزون وتنبيهات تلقائية بالكميات القليلة",
    "تقارير الأرباح والخسائر والضرائب والإحصائيات المتقدمة",
    "الطباعة الحرارية المباشرة (فواتير وملصقات باركود)",
    "النسخ الاحتياطي التلقائي (محلي وسحابي) لحماية بياناتك",
    "دعم فني متكامل وتحديثات مجانية مستمرة للتطبيق",
  ];

  // Future<void> viewdata() async {
  //   statusrequest = Statusrequest.loadeng;
  //   update();

  //   var response = await subscriptionPayData.getpay();
  //   print("================Response==============: $response");

  //   statusrequest = handlingData(response);

  //   if (statusrequest == Statusrequest.success) {
  //     if (response["status"] == 1) {
  //       data.clear();

  //       var rawData = response['data'];

  //       if (rawData is Map<String, dynamic>) {
  //         data.add(ChargilyPayment.fromJson(rawData));
  //       }
  //     } else {
  //       statusrequest = Statusrequest.failure;
  //     }
  //   }

  //   update();
  // }

  Future<void> createPayment() async {
    isLoadingPay = true;
    update();

    try {
      final type = selectedPlanIndex;

      final response = await subscriptionPayData.chargilycreate({
        "type": type,
      });

      if (response["status"] == true) {
        final checkoutUrl = response["checkout_url"];
        final paymentId = response["payment_id"];

        await _openCheckout(checkoutUrl, paymentId);
      }
    } catch (e) {
      print(e);
      showSnackbar("error".tr, "فشل إنشاء الدفع".tr, Colors.red);
    }

    isLoadingPay = false;
    update();
  }

  Future<void> _openCheckout(String url, int paymentId) async {
    print("========$url");
    await Get.to(
      () => ChargilyWebViewScreen(
        url: url,
      ),
    );

    _trackPayment(paymentId);
  }

  void _trackPayment(int paymentId) {
    print("(=================================================)");
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        if (!(await checkInternet())) {
          return;
        }
        final response = await subscriptionPayData.getstatus(paymentId);
        print("=========================$response");

        if (response["status"] == "paid") {
          timer.cancel();
          // await viewdata();
        } else if (response["status"] == "failed") {
          timer.cancel();
        }
      },
    );
  }

  @override
  void onInit() {
    // viewdata();
    super.onInit();
  }



  void changePlanIndex(int index) {
    selectedPlanIndex = index;
    update();
  }
}
