import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Custembutonauth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const Custembutonauth(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: ,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColor.backgroundcolor),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal:80),
        onPressed: onPressed,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color:AppColor.primarycolor,
          ),
        ),
      ),
    );
  }
}
