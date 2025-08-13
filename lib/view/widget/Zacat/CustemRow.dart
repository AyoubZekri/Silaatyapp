import 'package:flutter/material.dart';

class Custemrow extends StatelessWidget {
  final String Title;
  final String Prise;
  final String? DA;
  final double fontSize;
  final Color color;
  final Color colorp;
  final VoidCallback? onDoubleTap;

  const Custemrow({
    super.key,
    required this.Title,
    required this.Prise,
    this.DA,
    required this.fontSize,
    required this.color,
    required this.colorp,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: color, fontSize: fontSize),
          ),
          Row(
            children: [
              if (DA != null)
                Text(
                  DA!,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: colorp, fontSize: fontSize),
                ),
              const SizedBox(width: 3),
              Text(
                Prise,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: colorp, fontSize: fontSize),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
