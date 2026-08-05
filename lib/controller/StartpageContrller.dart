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

  String date_experiment = "";

  Statusrequest statusrequest = Statusrequest.none;

  getUser() async {
    statusrequest = Statusrequest.loadeng;
    update();
    String? loginType = myServices.sharedPreferences?.getString("loginType") ?? "admin";
    bool isSeller = loginType == "saller";

    var response = await logenData.getUser(isSeller);
    print("==============================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {

        if (loginType == "saller") {
          var sellerData = response["data"]["data"];
          var parentData = sellerData["parent"];
          
          Status = parentData['Status'];

          String imageUrl = parentData["logo_stor"] ?? "";
          String fileName = imageUrl.split("/").last;
          String localPath = "${Applink.image}/storage/$imageUrl";
          
          if (imageUrl.isNotEmpty) {
            localPath = await downloadAndCacheImage(localPath, fileName);
            myServices.sharedPreferences!.setString("logo_stor", localPath);
          }

          myServices.sharedPreferences!.setInt("id", parentData['id']);
          myServices.sharedPreferences!.setInt("sellerid", sellerData['id']);
          myServices.sharedPreferences!.setString("email", sellerData['email']);
          myServices.sharedPreferences!.setString("name", sellerData["name"]);
          myServices.sharedPreferences!.setString("phone", parentData["phone_number"] ?? "");
          myServices.sharedPreferences!.setString("family_name", parentData["family_name"] ?? "");
          myServices.sharedPreferences!.setInt("user_notify_status", parentData["user_notify_status"] ?? 0);
          
          if (parentData["adresse"] != null) {
            myServices.sharedPreferences!.setString("adresse", parentData["adresse"]);
          }
          if (parentData["account_type"] != null) {
            myServices.sharedPreferences!.setInt("account_type", parentData["account_type"]);
          }
          myServices.sharedPreferences!.setInt("Status", parentData["Status"]);
          
          if (parentData["date_experiment"] != null) {
            myServices.sharedPreferences!.setString("date_experiment", parentData["date_experiment"]);
            date_experiment = parentData["date_experiment"];
          }
          if (parentData["sell_type"] != null) {
            myServices.sharedPreferences!.setInt("sell_type", int.tryParse(parentData["sell_type"]?.toString() ?? '0') ?? 0);
          }
        } else {
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
          if (user["account_type"] != null) {
            myServices.sharedPreferences!.setInt("account_type", user["account_type"]);
          }
          myServices.sharedPreferences!.setInt("Status", user["Status"]);
          print("==================================${user["date_experiment"]}");
          if (user["date_experiment"] != null) {
            myServices.sharedPreferences!
                .setString("date_experiment", user["date_experiment"]);
            date_experiment = user["date_experiment"];
          }
          print(
              "==================================${user["max_sellers"]} ${user["sell_type"]} ${user["sell_type"]}");

          if (user["sell_type"] != null) {
            myServices.sharedPreferences!.setInt(
                "sell_type", int.tryParse(user["sell_type"].toString()) ?? 0);
          }
          if (user["max_sellers"] != null) {
            myServices.sharedPreferences!.setInt(
                "max_sellers", int.tryParse(user["max_sellers"].toString()) ?? 0);
          }
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
