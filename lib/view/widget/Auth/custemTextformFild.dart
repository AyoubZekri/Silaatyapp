import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Custemtextformfild extends StatelessWidget {
  final String hintText;
  final String label;
  final double contentPaddingvertical;

  final IconData iconData;
  final String? Function(String?) valid;
  final TextEditingController? MyController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final void Function()? onTap;
  const Custemtextformfild(
      {super.key,
      required this.hintText,
      required this.label,
      required this.iconData,
      required this.valid,
      this.MyController,
      required this.keyboardType,
      this.obscureText,
      required this.onTap,
      required this.contentPaddingvertical});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        obscureText: obscureText == null || obscureText == false ? false : true,
        controller: MyController,
        validator: valid,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 30, vertical: contentPaddingvertical),
            label: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  label,
                )),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.black),
                borderRadius: BorderRadius.circular(50)),
            suffixIcon: InkWell(onTap: onTap, child: Icon(iconData))),
      ),
    );
  }
}
