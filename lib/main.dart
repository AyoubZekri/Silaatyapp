import 'package:Silaaty/core/functions/callback.dart';
import 'package:Silaaty/core/functions/fcm.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/Bindings/Initialbindings.dart';
import 'package:Silaaty/core/localizations/ChengeLocal.dart';
import 'package:Silaaty/core/localizations/Translation.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/routes.dart';
import 'package:firebase_core/firebase_core.dart';


final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await initialServices();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  await FcmHelper.initFCM();

  // final syncService = SyncService();
  // syncService.initSyncListener();
  await AndroidAlarmManager.initialize();

  final syncForeground = SyncForegroundService();
  syncForeground.start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    Get.put(RefreshService());
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: controller.themeData,
      locale: controller.language,
      initialBinding: Initialbindings(),
      getPages: routes,
    );
  }
}
