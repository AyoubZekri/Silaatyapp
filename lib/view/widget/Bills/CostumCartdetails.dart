import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/constant/Colorapp.dart';

class Costumcartdetails extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String body;

  const Costumcartdetails(
      {super.key,
      required this.iconData,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title)
                ],
              ),
              Text(
                body,
                style: TextStyle(color: AppColor.black),
              )
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
