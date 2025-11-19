import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/constant/Colorapp.dart';

class Costumcartdetailspayment extends StatelessWidget {
  final String title;
  final String body;

  const Costumcartdetailspayment(
      {super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                body,
                style: TextStyle(color: AppColor.black),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.grey[400],
            height: 1,
          ),
        ],
      ),
    );
  }
}
