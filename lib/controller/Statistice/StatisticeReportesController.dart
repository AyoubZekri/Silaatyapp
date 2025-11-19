import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Statisticereportescontroller extends GetxController {
  String? filterController;
  DateTime? customStartDate;
  DateTime? customEndDate;

  final Map<String, String> ranges = {
    "custom": "مخصص".tr,
    "today": "اليوم".tr,
    "yesterday": "أمس".tr,
    "last_7_days": "آخر 7 أيام".tr,
    "last_30_days": "آخر 30 يوم".tr,
    "this_month": "هذا الشهر".tr,
    "last_month": "الشهر الماضي".tr,
    "this_year": "هذه السنة".tr,
    "last_year": "السنة الماضية".tr,
  };

  gotoPublicFinance() {
    // نضرة مالية عامة
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("خطأ", "يرجى تحديد فترة زمنية  .", Colors.red);
      return;
    }
    Get.toNamed(
      Approutes.publicfinance,
      arguments: filterController == "custom"
          ? {"from": customStartDate, "to": customEndDate}
          : {"filter": filterController},
    );
    filterController = null;
    customStartDate = null;
    customEndDate = null;
  }

  // gotoExpenses() {
  //   // المصروفات
  // }

  gotoLowStock() {
    Get.toNamed(
      Approutes.lowstock,
    );
  }

  gotoStockBalance() {
    // رصيد المخزون
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("خطأ", "يرجى تحديد فترة زمنية .", Colors.red);
      return;
    }
    Get.toNamed(
      Approutes.stockbalance,
      arguments: filterController == "custom"
          ? {"from": customStartDate, "to": customEndDate}
          : {"filter": filterController},
    );
    filterController = null;
    customStartDate = null;
    customEndDate = null;
  }

  gotoStockValue() {
    // قيمة المخزون
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("خطأ", "يرجى تحديد فترة زمنية .", Colors.red);
      return;
    }
    Get.toNamed(
      Approutes.stockvalue,
      arguments: filterController == "custom"
          ? {"from": customStartDate, "to": customEndDate}
          : {"filter": filterController},
    );
  }

  gotoCustomerSales() {
    // مبيعات العملاء
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "يرجى تحديد فترة زمنية .".tr, Colors.red);
      return;
    }
    Get.toNamed(
      Approutes.customersales,
      arguments: filterController == "custom"
          ? {"from": customStartDate, "to": customEndDate}
          : {"filter": filterController},
    );
  }

  gotoSupplierReports() {
    // تقارير الموردون
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "يرجى تحديد فترة زمنية .".tr, Colors.red);
      return;
    }
    Get.toNamed(
      Approutes.supplierreports,
      arguments: filterController == "custom"
          ? {"from": customStartDate, "to": customEndDate}
          : {"filter": filterController},
    );
  }
}
