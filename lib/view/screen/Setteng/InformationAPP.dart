import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Privacypolicy/CustemTitleorBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Informationapp extends StatefulWidget {
  const Informationapp({super.key});

  @override
  State<Informationapp> createState() => _InformationappState();
}

class _InformationappState extends State<Informationapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('informationApp'.tr,
             style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColor.backgroundcolor, fontSize: 24)),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(
          color: AppColor.backgroundcolor,
        ),
      ),
      body: Container(
        margin:const EdgeInsets.all(20),
        child: ListView(
          children: [
            Custemtitleorbody(
              Body: "26".tr,
            )
          ],
        ),
      ),
    );
  }
}
