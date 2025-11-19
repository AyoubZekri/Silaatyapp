import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Costumtitlepayment extends StatelessWidget {
  final IconData iconData;
  final String title;

  const Costumtitlepayment(
      {super.key, required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: AppColor.backgroundcolor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(title)
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.grey[300],
            height: 1,
          ),
        ],
      ),
    );
  }
}
