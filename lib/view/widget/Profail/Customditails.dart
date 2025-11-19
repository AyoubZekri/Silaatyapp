import 'package:flutter/material.dart';

class Customditails extends StatelessWidget {
  final String Title;
  final String body;
  const Customditails({super.key, required this.Title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                body,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
