import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';

class Iconbutton extends StatelessWidget {
  final void Function()? onTap;
  final IconData iconData;
  const Iconbutton({super.key, this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        iconData,
        color: AppColor.grey,
        size: 30,
      ),
    );
  }
}
