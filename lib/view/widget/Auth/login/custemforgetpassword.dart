import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Custemforgetpassword extends StatelessWidget {
  final void Function()? onTap;
  const Custemforgetpassword({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child:  Text(
          "4".tr,
          style:const TextStyle(color: AppColor.backgroundcolor),
          textAlign: TextAlign.end,
        ));
  }
}
