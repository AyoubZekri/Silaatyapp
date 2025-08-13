import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Custemtextfildprofail extends StatelessWidget {
  final String hintText;
  final String label;
  final double contentPaddingvertical;

  final String? Function(String?) valid;
  final TextEditingController? MyController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final void Function()? onTap;
  const Custemtextfildprofail(
      {super.key,
      required this.hintText,
      required this.label,
      required this.valid,
      this.MyController,
      required this.keyboardType,
      this.obscureText,
      this.onTap,
      required this.contentPaddingvertical});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            obscureText:
                obscureText == null || obscureText == false ? false : true,
            controller: MyController,
            validator: valid,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 12),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 30, vertical: contentPaddingvertical),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.black),
                  borderRadius: BorderRadius.circular(50)),
              //  suffixIcon: InkWell(onTap: onTap, child: Icon(iconData))
            ),
          ),
        ],
      ),
    );
  }
}
