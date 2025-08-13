import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemcartbutton extends StatelessWidget {
  final String Title;
  final void Function()? ontap;
  final IconData iconData;
  const Custemcartbutton(
      {super.key, required this.Title, this.ontap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      iconData,
                      color: AppColor.backgroundcolor,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      Title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Icon(
                  Get.locale?.languageCode == 'ar'
                      ? Icons.keyboard_arrow_left
                      : Icons.keyboard_arrow_right,
                ),
              ],
            ),
          const  SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
