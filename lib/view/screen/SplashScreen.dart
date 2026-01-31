import 'package:Silaaty/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../controller/StartpageContrller.dart';
import '../../core/constant/imageassets.DART';
import '../../core/services/Services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Startpagecontrller contrller = Get.put(Startpagecontrller());
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  final Myservices myServices = Get.find();

  bool animate = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    String? token = myServices.sharedPreferences?.getString("token");

    if (token != null && token.isNotEmpty) {
      await contrller.getUser();
    }

    _controller.forward();

    await Future.delayed(const Duration(seconds: 3));
    setState(() => animate = true);

    await Future.delayed(const Duration(milliseconds: 0));

    if (token != null && token.isNotEmpty) {
      String? experimentDateString =
          myServices.sharedPreferences!.getString("date_experiment") ?? "";
      print("=========================$experimentDateString");
      int? status = myServices.sharedPreferences!.getInt("Status");
      if (experimentDateString.isNotEmpty) {
        DateTime experimentDate = DateTime.parse(experimentDateString);

        DateTime currentDate = DateTime.now();
        DateTime today =
            DateTime(currentDate.year, currentDate.month, currentDate.day);

        if ((today.isAfter(experimentDate) && status! <= 2||
            today.isAtSameMomentAs(experimentDate) && status! <= 2)) {
          await myServices.sharedPreferences!.clear();
          Get.offAllNamed(Approutes.Login);
        } else {
          Get.offAllNamed(Approutes.HomeScreen);
        }
      } else {
        Get.offAllNamed(Approutes.HomeScreen);
      }
    } else {
      Get.offAllNamed(Approutes.Login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: animate ? 0.0 : 1.0,
            child: Container(color: Colors.white),
          ),
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  Appimageassets.logo,
                  height: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
