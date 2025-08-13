import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custemtextbody extends StatelessWidget {
  const Custemtextbody({super.key, required this.Body});

  final String Body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        Body,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColor.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
