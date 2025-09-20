import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/Services.dart';

class Custemlanguge extends StatelessWidget {
  final String Langugs;
  final String long;
  final String image;

  const Custemlanguge(
      {super.key,
      required this.Langugs,
      required this.long,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final currentLang = Get.locale?.languageCode;
    final bool isSelected = currentLang == Langugs;
    Myservices myServices = Get.find();

    return GestureDetector(
      onTap: () {
        myServices.sharedPreferences!.setString("lang", Langugs);
        Get.updateLocale(Locale(Langugs));
        Get.back();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: Card(
          color: isSelected
              // ignore: deprecated_member_use
              ? AppColor.backgroundcolor.withOpacity(0.2)
              : Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  long,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color:
                            isSelected ? AppColor.primarycolor : Colors.black,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
