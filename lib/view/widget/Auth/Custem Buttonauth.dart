import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custembuttonauth extends StatelessWidget {
  final void Function()? onPressed;
  final String Textname;
  const Custembuttonauth({super.key, this.onPressed, required this.Textname});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 13),
        onPressed: onPressed,
        child: Text(
          Textname,
          style: TextStyle(color: Colors.white,),
        ),
        color: AppColor.backgroundcolor,
      ),
    );
  }
}
