import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custembutton extends StatelessWidget {
  final String text;
  final double vertical;
  final double horizontal;
  final double paddingvertical;

  final void Function()? onPressed;

  const Custembutton({super.key, required this.text, this.onPressed, required this.vertical, required this.horizontal, required this.paddingvertical});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: vertical ,horizontal: horizontal ),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        color: AppColor.backgroundcolor,
        border: Border.all(
          width: 2,
          color: AppColor.grey,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: paddingvertical),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child:  Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColor.primarycolor),
        ),
      ),
    );
  }
}
