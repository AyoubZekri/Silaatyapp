import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custemtitle extends StatelessWidget {
  final String tatli;
  const Custemtitle({super.key, required this.tatli});

  @override
  Widget build(BuildContext context) {
    return Text(
      tatli,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColor.backgroundcolor),
      textAlign: TextAlign.center,
    );
  }
}
