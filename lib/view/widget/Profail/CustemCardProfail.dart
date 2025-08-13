import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custemcardprofail extends StatelessWidget {
  final String Title;
  final IconData iconData;
  const Custemcardprofail(
      {super.key, required this.Title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),
    );
  }
}
