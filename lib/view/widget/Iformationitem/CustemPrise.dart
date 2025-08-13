import 'package:flutter/material.dart';

class Custemprise extends StatelessWidget {
  final String price;
  const Custemprise({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Price:",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          price,
          style: Theme.of(context).textTheme.headlineLarge,
        )
      ],
    );
  }
}
