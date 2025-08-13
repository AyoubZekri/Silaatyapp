import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Titleandbody extends StatelessWidget {
  const Titleandbody({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
                children: [
                  Text(
                    "Verify Your Email",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    "An 5-digit code has been sent to",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Ayoubzekri@gmail.com",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColor.black),
                  ),
                ],
              );
  }
}