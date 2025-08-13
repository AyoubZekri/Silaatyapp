import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custemtexttitle extends StatelessWidget {
  final String title;
  const Custemtexttitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        style:const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.black),
      ),
    );
  }
}
