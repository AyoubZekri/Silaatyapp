import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Custemaccount extends StatelessWidget {
  final void Function()? onTap;
  final String body;
  final String topage;

  const Custemaccount(
      {super.key, this.onTap, required this.body, required this.topage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          body,
          style: TextStyle(
              fontSize: 18, color: AppColor.grey, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            topage,
            style: TextStyle(
                fontSize: 18,
                color: AppColor.backgroundcolor,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
