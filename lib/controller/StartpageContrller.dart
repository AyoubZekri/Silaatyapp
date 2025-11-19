import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/logen_data.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../core/services/Services.dart';

class Startpagecontrller extends GetxController {
  LoginData logenData = LoginData(Get.find());
  // List data = [];
  late int Status;
  Myservices myServices = Get.find();

  Statusrequest statusrequest = Statusrequest.none;

  getUser() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await logenData.getUser();
    print("==============================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        Status = response['data']["data"][0]['Status'];
        var user = response["data"]["data"][0];
        String imageUrl = user["logo_stor"] ?? "";
        String fileName = imageUrl.split("/").last;
        String localPath = "${Applink.image}/storage/$imageUrl";
        print("==================================$localPath");

        print("==================================$fileName");
        if (imageUrl.isNotEmpty) {
          localPath = await downloadAndCacheImage(localPath, fileName);
        }
        print("==================================$localPath");
        myServices.sharedPreferences!.setString("logo_stor", localPath);

        myServices.sharedPreferences!.setInt("id", user['id']);
        myServices.sharedPreferences!.setString("email", user['email']);
        myServices.sharedPreferences!.setString("name", user["name"]);
        myServices.sharedPreferences!.setString("phone", user["phone_number"]);
        myServices.sharedPreferences!
            .setString("family_name", user["family_name"]);
        myServices.sharedPreferences!
            .setInt("user_notify_status", user["user_notify_status"]);
        if (user["adresse"] != null)
          myServices.sharedPreferences!.setString("adresse", user["adresse"]);
        myServices.sharedPreferences!.setInt("Status", user["Status"]);
        if (user["date_experiment"] != null) {
          myServices.sharedPreferences!
              .setString("date_experiment", user["date_experiment"]);
        }
      }
    }

    update();
  }

  Future<String> downloadAndCacheImage(String imageUrl, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      File file = File(filePath);

      await file.parent.create(recursive: true);

      if (await file.exists()) {
        return filePath;
      }

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }

      return "";
    } catch (e) {
      return "";
    }
  }
}
