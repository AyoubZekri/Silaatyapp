import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Privacypolicy/CustemtitleorBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Privacypolicy extends StatefulWidget {
  const Privacypolicy({super.key});

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title:  Text('Privacy Policy'.tr,
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
          children:  [
            Custemtitleorbody(
              title: "15".tr,
              Body:"16".tr,
            ),
            Custemtitleorbody(
              title: "المعلومات التي نجمعها".tr,
              Body: "17".tr
            ),
            Custemtitleorbody(
              title: "18".tr,
              Body: "19".tr,
            ),
            Custemtitleorbody(
              title: "20".tr,
              Body: "21".tr
            ),
            Custemtitleorbody(
              title: "22".tr,
              Body: "23".tr
            ),
            Custemtitleorbody(
              title: "24".tr,
              Body:"25".tr,
              email: "codedev39@gmail.com",
            ),
          ],
        ),
      ),
    );
  }
}
