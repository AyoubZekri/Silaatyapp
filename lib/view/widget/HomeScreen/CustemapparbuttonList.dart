import 'package:Silaaty/controller/HomeScreen/HomeScreenController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/HomeScreen/CustemApparButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustemapparbuttonList extends StatelessWidget {
  const CustemapparbuttonList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomescreencontrollerImp>(
      builder: (controller) => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // لون الظل
              blurRadius: 10, // مدى التمويه
              offset: const Offset(0, -4), // اتجاه الظل (سالب يعني للأعلى)
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          color: AppColor.white,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(controller.Screen.length, ((i) {
                  return Custemapparbutton(
                    onPressed: () {
                      controller.ChangePage(i);
                    },
                    icondata: controller.IconsScreen[i]["icon"],
                    active: controller.currentpage == i,
                  );
                }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
