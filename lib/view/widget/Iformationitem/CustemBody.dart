import 'package:flutter/material.dart';

class Custembody extends StatelessWidget {
  final String body;
  const Custembody({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Text(
      body,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
