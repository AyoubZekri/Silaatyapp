import 'dart:io';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:get/get.dart';
import '../../core/services/Services.dart';

class Profailcontroller extends GetxController {
  final myServices = Get.find<Myservices>();

  String? name;
  String? email;
  int? Supscription;
  String? dateexperiment;
  File? logoFile;

  @override
  void onInit() {
    name = myServices.sharedPreferences?.getString("name");
    email = myServices.sharedPreferences?.getString("email");
    Supscription = myServices.sharedPreferences?.getInt("Status");
    dateexperiment = myServices.sharedPreferences?.getString("date_experiment");

    final logoPath = myServices.sharedPreferences?.getString("logo_stor");

    if (logoPath != null && logoPath.isNotEmpty) {
      final file = File(logoPath);
      if (file.existsSync()) {
        logoFile = file;
      } else {
        logoFile = null;
      }
    }

    super.onInit();
  }

  gotoprofaileedit() {
    Get.toNamed(Approutes.profaile);
  }

  String get loginType => myServices.sharedPreferences?.getString("loginType") ?? "admin";

  bool get isPermanentAccess {
    if (loginType == "saller") {
      return Supscription == 6 || Supscription == 14;
    } else {
      return Supscription == 5 || Supscription == 6 || Supscription == 13 || Supscription == 14;
    }
  }
}
