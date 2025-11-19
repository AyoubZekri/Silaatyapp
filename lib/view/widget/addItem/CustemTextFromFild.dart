import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custemtextfromfild extends StatelessWidget {
  final String hintText;
  final String label;
  final IconData iconData;
  final bool enabled;
  // ignore: non_constant_identifier_names
  final TextEditingController? MyController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  const Custemtextfromfild(
      {super.key,
      required this.hintText,
      required this.label,
      required this.iconData,
      // ignore: non_constant_identifier_names
      this.MyController,
      this.keyboardType,
      this.obscureText,required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: AppColor.grey,
          ),
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        children: [
          Icon(
            iconData,
            color: AppColor.backgroundcolor,
          ),
          const SizedBox(width: 10),
          Container(
            height: 30,
            width: 1,
            color: AppColor.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  obscureText: obscureText == null || obscureText == false
                      ? false
                      : true,
                  controller: MyController,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    enabled: enabled,
                    labelText: label,
                    labelStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
