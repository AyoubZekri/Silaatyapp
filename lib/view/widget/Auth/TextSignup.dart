import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class custemTextsignup extends StatelessWidget {
  final String Textoen;
  final String TextoTwo;
  final Function()? onTap;

  const custemTextsignup(
      {super.key,
      required this.Textoen,
      required this.TextoTwo,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Textoen,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColor.grey),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            TextoTwo,
            style: TextStyle(color: AppColor.backgroundcolor),
          ),
        )
      ],
    );
  }
}
