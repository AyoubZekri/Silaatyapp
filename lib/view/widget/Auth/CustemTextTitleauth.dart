import 'package:flutter/material.dart';

class Custemtexttitleauth extends StatelessWidget {
  const Custemtexttitleauth({super.key, required this.Title});
  final String Title;

  @override
  Widget build(BuildContext context) {
    return   Text(
                Title
                ,style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              );
  }
}