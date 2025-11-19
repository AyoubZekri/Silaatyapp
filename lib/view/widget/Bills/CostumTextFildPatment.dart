import 'package:flutter/material.dart';

class Costumtextfildpatment extends StatelessWidget {
  final String hintText;
  final String label;
  final IconData iconData;
  final String? Function(String?) valid;
  final TextEditingController? MyController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool enabled;

  final void Function()? onTap;

  const Costumtextfildpatment(
      {super.key,
      this.onTap,
      required this.hintText,
      required this.label,
      required this.iconData,
      this.MyController,
      required this.valid,
      required this.keyboardType,
      this.obscureText,required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
          obscureText:
              obscureText == null || obscureText == false ? false : true,
          keyboardType: keyboardType,
          validator: valid,
          controller: MyController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              errorStyle: const TextStyle(fontSize: 12),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabled: enabled,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              suffixIcon: InkWell(
                onTap: onTap,
                child: Icon(iconData),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ))),
    );
  }
}
