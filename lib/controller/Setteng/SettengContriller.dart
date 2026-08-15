import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/logen_data.dart';
import 'package:Silaaty/view/widget/Setteng/custemLanguge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/functions/Snacpar.dart';

class Settengcontriller extends GetxController {
  GotoProfaile() {
    Get.toNamed(Approutes.profaile);
  }

  GotoNotification() {
    Get.toNamed(Approutes.notification);
  }

  GotoPrivacypolicy() {
    Get.toNamed(Approutes.Privacypolicy);
  }

  GotoInformationapp() {
    Get.toNamed(Approutes.Informationapp);
  }

  // GotoZakat() {
  //   Get.toNamed(Approutes.Zakat);
  // }

  gotoProfail() {
    Get.toNamed(Approutes.profail);
  }

  ChangePassword() {
    Get.toNamed(Approutes.reset);
  }

  LoginData loginData = LoginData(Get.find());
  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  log() {
    myServices.sharedPreferences?.clear();
  }

  logout() async {
    // statusrequest = Statusrequest.loadeng;
    // update();

    // var response = await loginData.logout();
    // print("==================================================$response");
    // if (response == Statusrequest.serverfailure) {
    //   showSnackbar("error".tr, "noInternet".tr, Colors.red);
    // }
    // statusrequest = handlingData(response);
    // if (statusrequest == Statusrequest.success && response["status"] == 1) {
    myServices.sharedPreferences?.clear();
    // showSnackbar("success".tr, "logout_success".tr, Colors.green);

    Get.offAllNamed(Approutes.Login);
    // } else {
    //   print(response);
    //   // showSnackbar("error".tr, "error_occurred".tr, Colors.green);
    //   statusrequest = Statusrequest.failure;
    // }
    update();
  }

  Future<void> selectBluetoothPrinter() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if ((statuses[Permission.bluetoothConnect] != PermissionStatus.granted &&
            statuses[Permission.bluetoothScan] != PermissionStatus.granted) ||
        statuses[Permission.locationWhenInUse] != PermissionStatus.granted) {
      if (statuses[Permission.bluetoothConnect] ==
              PermissionStatus.permanentlyDenied ||
          statuses[Permission.bluetoothScan] ==
              PermissionStatus.permanentlyDenied ||
          statuses[Permission.locationWhenInUse] ==
              PermissionStatus.permanentlyDenied) {
        showSnackbar(
            "تنبيه".tr,
            "تم رفض الصلاحية نهائياً. سيتم فتح الإعدادات لتفعيلها يدوياً.".tr,
            Colors.red);
        await openAppSettings();
      } else {
        showSnackbar(
            "تنبيه".tr,
            "يجب إعطاء صلاحية الموقع والأجهزة المجاورة للوصول للطابعات".tr,
            Colors.orange);
      }
      bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!bluetoothEnabled) {
        showSnackbar(
            "تنبيه".tr, "الرجاء تفعيل البلوتوث أولاً".tr, Colors.orange);
        return;
      }

      // Request permissions dynamically before fetching paired devices.

      return;
    }

    final List<BluetoothInfo> pairedDevices =
        await PrintBluetoothThermal.pairedBluetooths;

    if (pairedDevices.isEmpty) {
      showSnackbar("تنبيه".tr, "لا توجد طابعات مقترنة".tr, Colors.orange);
      return;
    }

    BluetoothInfo? selectedPrinter = await Get.dialog<BluetoothInfo>(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text("اختر الطابعة".tr, textAlign: TextAlign.center),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pairedDevices.length,
            itemBuilder: (context, index) {
              final device = pairedDevices[index];
              return ListTile(
                leading:
                    const Icon(Icons.print, color: AppColor.backgroundcolor),
                title: Text(device.name),
                subtitle: Text(device.macAdress),
                onTap: () => Get.back(result: device),
              );
            },
          ),
        ),
      ),
    );

    if (selectedPrinter != null) {
      myServices.sharedPreferences
          ?.setString("mac_printer_address", selectedPrinter.macAdress);
      myServices.sharedPreferences
          ?.setString("mac_printer_name", selectedPrinter.name);

      await PrintBluetoothThermal.disconnect;

      showSnackbar("نجاح".tr, "تم تحديد الطابعة بنجاح".tr, Colors.green);
      update();
    }
  }

  void showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  "Langugs".tr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Custemlanguge(
                  Langugs: "ar", long: "Arabic".tr, image: Appimageassets.ALG),
              const SizedBox(
                height: 10,
              ),
              Custemlanguge(
                  Langugs: "en", long: "English".tr, image: Appimageassets.en)
            ],
          ),
        );
      },
    );
  }

  // عرض إعدادات الطباعة المجمعة
  void showPrinterSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GetBuilder<Settengcontriller>(
          builder: (controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Printer Settings".tr,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- تحديد الطابعة ---
                    Text("تحديد الطابعة".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.bluetooth, color: Colors.blue),
                      title: Text(controller.myServices.sharedPreferences
                              ?.getString("mac_printer_name") ??
                          "اختر طابعة بلوتوث".tr),
                      subtitle: Text(controller.myServices.sharedPreferences
                              ?.getString("mac_printer_address") ??
                          "غير محدد".tr),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.back();
                        controller.selectBluetoothPrinter();
                      },
                    ),
                    const Divider(),

                    // --- نوع الطابعة ---
                    Text("نوع الطابعة".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.receipt, color: Colors.blue),
                      title: Text("طابعة (ESC/POS)".tr),
                      trailing: controller.myServices.sharedPreferences
                                  ?.getString("printer_mode") !=
                              "label"
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        controller.myServices.sharedPreferences
                            ?.setString("printer_mode", "receipt");
                        controller.update();
                        showSnackbar(
                            "نجاح".tr, "تم حفظ الإعداد".tr, Colors.green);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.label, color: Colors.green),
                      title: Text("طابعة (TSPL)".tr),
                      trailing: controller.myServices.sharedPreferences
                                  ?.getString("printer_mode") ==
                              "label"
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        controller.myServices.sharedPreferences
                            ?.setString("printer_mode", "label");
                        controller.update();
                        showSnackbar(
                            "نجاح".tr, "تم حفظ الإعداد".tr, Colors.green);
                      },
                    ),
                    const Divider(),

                    // --- مقاس ورق الفواتير ---
                    Text("مقاس ورق الفواتير".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.straighten, color: Colors.blue),
                      title: Text("58mm (Standard)".tr),
                      trailing: controller.myServices.sharedPreferences
                                  ?.getInt("printer_width") ==
                              460
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        controller.myServices.sharedPreferences
                            ?.setInt("printer_width", 460);
                        controller.update();
                        showSnackbar(
                            "نجاح".tr, "تم حفظ الإعداد".tr, Colors.green);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.straighten, color: Colors.green),
                      title: Text("80mm (Large)".tr),
                      trailing: controller.myServices.sharedPreferences
                                  ?.getInt("printer_width") ==
                              640
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        controller.myServices.sharedPreferences
                            ?.setInt("printer_width", 640);
                        controller.update();
                        showSnackbar(
                            "نجاح".tr, "تم حفظ الإعداد".tr, Colors.green);
                      },
                    ),
                    const Divider(),

                    // --- نوع ورق الباركود ---
                    Text("نوع ورق الباركود".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading:
                          const Icon(Icons.receipt_long, color: Colors.blue),
                      title: Text("ورق فواتير (متصل)".tr),
                      subtitle: Text(
                          "ورق متواصل بدون فجوات - مناسب للفواتير".tr,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      trailing: controller.myServices.sharedPreferences
                                  ?.getString("barcode_paper_type") !=
                              "label"
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        controller.myServices.sharedPreferences
                            ?.setString("barcode_paper_type", "receipt");
                        controller.update();
                        showSnackbar(
                            "نجاح".tr, "تم حفظ الإعداد".tr, Colors.green);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.label_outline, color: Colors.orange),
                      title: Text("ورق ملصقات (ملصقات)".tr),
                      subtitle: Text(
                          "ورق فيه فجوات بين كل ملصق - الطابعة تتوقف عند الفجوة"
                              .tr,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      trailing: controller.myServices.sharedPreferences
                                  ?.getString("barcode_paper_type") ==
                              "label"
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        controller.myServices.sharedPreferences
                            ?.setString("barcode_paper_type", "label");
                        controller.update();
                        showSnackbar(
                            "نجاح".tr, "تم حفظ الإعداد".tr, Colors.green);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
