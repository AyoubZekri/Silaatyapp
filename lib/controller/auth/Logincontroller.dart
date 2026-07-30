import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Auth/logen_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasource/Remote/Auth/Forgetpassword/checkemail.dart';

class Logincontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController Email;
  late TextEditingController Password;
  bool issobscureText = true;
  String loginType = "مشرف"; // "مشرف" = Admin, "بائع" = Seller

  showPassword() {
    issobscureText = !issobscureText;
    update();
  }

  changeLoginType(String type) {
    loginType = type;
    update();
  }

  Checkemaildata checkemaildata = Checkemaildata(Get.find());
  Myservices myServices = Get.find();
  LoginData logenData = LoginData(Get.find());
  List data = [];
  Statusrequest statusrequest = Statusrequest.none;

  Login() async {
    var formData = formstate.currentState;
    if (formData!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      String? fcmToken;
      bool isSeller = loginType == "بائع";

      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("Error getting FCM Token: $e");
        fcmToken = "";
      }
      print("FCM Token: $fcmToken");
      var response = await logenData.postdata(
          Password.text, Email.text, fcmToken ?? "", isSeller);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }
      statusrequest = handlingData(response);
      print("=============================== Controller $response ");
      if (statusrequest == Statusrequest.success) {
        if (response["status"] == 1) {
          var sellerData = response["data"]["sellerData"];
          var parent = sellerData != null ? sellerData["parent"] : null;

          if (loginType == "بائع" && parent == null) {
            statusrequest = Statusrequest.none;
            update();
            showSnackbar("تحذير".tr, "الحساب نوعه ليس بائع".tr, Colors.orange);
            return;
          }

          if (loginType == "مشرف" && parent != null) {
            statusrequest = Statusrequest.none;
            update();
            showSnackbar("تحذير".tr, "نوع الحساب ليس مشرف".tr, Colors.orange);
            return;
          }
          if (isSeller) {
            myServices.sharedPreferences!.setString("loginType", "saller");

            print(response["data"]["token"]);
            myServices.sharedPreferences!
                .setInt("id", response['data']["sellerData"]["parent"]['id']);
            myServices.sharedPreferences!
                .setInt("sellerid", response['data']["sellerData"]['id']);

            myServices.sharedPreferences!
                .setString("email", response['data']["sellerData"]['email']);
            myServices.sharedPreferences!
                .setString("name", response["data"]["sellerData"]["name"]);
            myServices.sharedPreferences!.setString("phone",
                response["data"]["sellerData"]["parent"]["phone_number"]);
            myServices.sharedPreferences!.setString("family_name",
                response["data"]["sellerData"]["parent"]["family_name"]);
            myServices.sharedPreferences!.setInt("user_notify_status",
                response["data"]["sellerData"]["parent"]["user_notify_status"]);
            if (response["data"]["sellerData"]["parent"]["adresse"] != null) {
              myServices.sharedPreferences!.setString("adresse",
                  response["data"]["sellerData"]["parent"]["adresse"]);
            }

            String imageUrl =
                response["data"]["sellerData"]["parent"]["logo_stor"] ?? "";
            if (imageUrl.isNotEmpty) {
              String fileName = imageUrl.split("/").last;
              String localPath = "${Applink.image}/storage/$imageUrl";
              localPath = await downloadAndCacheImage(localPath, fileName);
              if (localPath.isNotEmpty) {
                myServices.sharedPreferences!.setString("logo_stor", localPath);
              }
            }

            myServices.sharedPreferences!.setInt(
                "Status", response["data"]["sellerData"]["parent"]["Status"]);
            if (response["data"]["sellerData"]["parent"]["date_experiment"] !=
                null) {
              myServices.sharedPreferences!.setString("date_experiment",
                  response["data"]["sellerData"]["parent"]["date_experiment"]);
            }
            if (response["data"]["sellerData"]["parent"]["sell_type"] != null) {
              myServices.sharedPreferences!.setInt(
                  "sell_type",
                  int.tryParse(response["data"]["sellerData"]["parent"]
                              ["sell_type"] ??
                          0.toString()) ??
                      0);
            }

            myServices.sharedPreferences!
                .setString("token", response["data"]["token"]);
            myServices.sharedPreferences!.setString("step", "2");
            DateTime? experimentDate;

            final experimentDateStr =
                response["data"]["sellerData"]["parent"]["date_experiment"];

            if (experimentDateStr != null &&
                experimentDateStr.toString().isNotEmpty) {
              try {
                experimentDate = DateTime.parse(experimentDateStr);
              } catch (e) {
                experimentDate = null;
              }
            }

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final status = response['data']["sellerData"]["parent"]['Status'];

            if (status == 3 ||
                status == 5 ||
                status == 7 ||
                status == 8 ||
                status == 9 ||
                status == 10 ||
                status == 11 ||
                status == 13) {
              Get.offAllNamed(Approutes.upgradeRequiredPage);
            } else if (status == 6 || status == 14) {
              Get.offAllNamed(Approutes.Homesaller,
                  arguments: {"fromlogin": 1});
            } else if (status == 2 || status == 4 || status == 12) {
              if (experimentDate != null) {
                DateTime expireDate = DateTime(
                  experimentDate.year,
                  experimentDate.month,
                  experimentDate.day,
                );

                bool isValid = today.isBefore(expireDate);

                if (isValid) {
                  Get.offAllNamed(Approutes.Homesaller,
                      arguments: {"fromlogin": 1});
                } else {
                  Get.offAllNamed(Approutes.activationExpiredPage);
                }
              } else {
                Get.offAllNamed(Approutes.activationExpiredPage);
              }
            } else {
              Get.offAllNamed(Approutes.activationExpiredPage);
            }
          } else {
            myServices.sharedPreferences!.setString("loginType", "admin");
            print(response["data"]["user"]["token"]);
            myServices.sharedPreferences!
                .setInt("id", response['data']["user"]["user"]['id']);
            myServices.sharedPreferences!
                .setString("email", response['data']["user"]["user"]['email']);
            myServices.sharedPreferences!
                .setString("name", response["data"]["user"]["user"]["name"]);
            myServices.sharedPreferences!.setString(
                "phone", response["data"]["user"]["user"]["phone_number"]);
            myServices.sharedPreferences!.setString(
                "family_name", response["data"]["user"]["user"]["family_name"]);
            myServices.sharedPreferences!.setInt("user_notify_status",
                response["data"]["user"]["user"]["user_notify_status"]);
            if (response["data"]["user"]["user"]["adresse"] != null) {
              myServices.sharedPreferences!.setString(
                  "adresse", response["data"]["user"]["user"]["adresse"]);
            }

            if (response["data"]["user"]["user"]["logo_stor"] != null) {
              myServices.sharedPreferences!.setString(
                  "logo_stor", response["data"]["user"]["user"]["logo_stor"]);
            }

            myServices.sharedPreferences!
                .setInt("Status", response["data"]["user"]["user"]["Status"]);
            if (response["data"]["user"]["user"]["date_experiment"] != null) {
              myServices.sharedPreferences!.setString("date_experiment",
                  response["data"]["user"]["user"]["date_experiment"]);
            }
            if (response["data"]["user"]["user"]["sell_type"] != null) {
              myServices.sharedPreferences!.setInt(
                  "sell_type",
                  int.tryParse(response["data"]["user"]["user"]["sell_type"]
                          .toString()) ??
                      1);
            }
            if (response["data"]["user"]["user"]["max_sellers"] != null) {
              myServices.sharedPreferences!.setInt(
                  "max_sellers",
                  int.tryParse(response["data"]["user"]["user"]["max_sellers"]
                          .toString()) ??
                      0);
            }
            myServices.sharedPreferences!
                .setString("token", response["data"]["user"]["token"]);
            myServices.sharedPreferences!.setString("step", "2");
            DateTime? experimentDate;

            final experimentDateStr =
                response["data"]["user"]["user"]["date_experiment"];

            if (experimentDateStr != null &&
                experimentDateStr.toString().isNotEmpty) {
              try {
                experimentDate = DateTime.parse(experimentDateStr);
              } catch (e) {
                experimentDate = null;
              }
            }

            final today = DateTime.now();
            final status = response['data']["user"]["user"]['Status'];

            if (status == 0 || status == 1) {
              Get.offNamed(Approutes.VerifiycodeSignUp, arguments: {
                "email": Email.text,
              });
              reset();
            } else if (status == 5 ||
                status == 6 ||
                status == 13 ||
                status == 14) {
              Get.offAllNamed(Approutes.HomeScreen,
                  arguments: {"fromlogin": 1});
            } else if (status == 2 ||
                status == 3 ||
                status == 4 ||
                status == 11 ||
                status == 12) {
              if (experimentDate != null) {
                DateTime now = DateTime.now();
                DateTime todayDay = DateTime(now.year, now.month, now.day);
                DateTime expireDate = DateTime(
                  experimentDate.year,
                  experimentDate.month,
                  experimentDate.day,
                );
                bool isValid = todayDay.isBefore(expireDate);

                if (isValid) {
                  Get.offAllNamed(Approutes.HomeScreen,
                      arguments: {"fromlogin": 1});
                } else {
                  Get.offAllNamed(Approutes.activationExpiredPage);
                }
              } else {
                Get.offAllNamed(Approutes.activationExpiredPage);
              }
            } else {
              showSnackbar("error".tr, "contact_admin".tr, Colors.red);
            }
          }
        } else {
          // This is the else block for if (response["status"] == 1)
          if (response["message"] == "حسابك ليس مشرف") {
            showSnackbar("تحذير".tr, "نوع الحساب ليس مشرف".tr, Colors.orange);
          } else if (response["message"] == "حسابك ليس بائع") {
            showSnackbar("تحذير".tr, "الحساب نوعه ليس بائع".tr, Colors.orange);
          } else {
            showSnackbar(
                "Warning".tr, "email_password_wrong".tr, Colors.orange);
          }
        }
      } else {
        // This is the else block for if (statusrequest == Statusrequest.success)
        showSnackbar("Warning".tr, "email_password_wrong".tr, Colors.orange);
      }
      update();
    } else {
      print("Not valid");
    }
  }

  GoToSignUp() {
    Get.offNamed(Approutes.SignUp);
  }

  GoToForgenPassword() {
    Get.offNamed(Approutes.forgenPassword);
  }

  reset() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await checkemaildata.postdata(Email.text);
    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == 1) {
        showSnackbar("success".tr, "code_sent".tr, Colors.green);
      } else {
        showSnackbar("Warning".tr, "email_not_found".tr, Colors.orange);

        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // getUser() async {
  //   statusrequest = Statusrequest.loadeng;
  //   update();
  //   var response = await logenData.getUser();
  //   print("==============================$response");
  //   statusrequest = handlingData(response);
  //   // if (statusrequest == Statusrequest.success) {
  //   //   if (response["status"] == 1) {
  //   //     final model = Categoris_Model.fromJson(response);
  //   //     Categoris = model.data?.catdata ?? [];
  //   //     if (Categoris.isEmpty) {
  //   //       statusrequest = Statusrequest.failure;
  //   //     }
  //   //   }
  //   // }

  //   update();
  // }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   print("token:$token");
    // });

    Email = TextEditingController();
    Password = TextEditingController();
    // getUser();
    super.onInit();
  }

  @override
  void dispose() {
    Email.dispose();
    Password.dispose();
    super.dispose();
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
