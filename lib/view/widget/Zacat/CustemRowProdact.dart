import 'package:flutter/material.dart';

class Custemrowprodact extends StatelessWidget {
  final String title;
  final String price;
  final String? da;
  final String q;
  final String value;
  final double fontSize;
  final Color color;
  final Color colorp;
  final void Function()? onTap;
  final void Function()? onLongPress; 

  const Custemrowprodact({
    super.key,
    this.onTap,
    this.onLongPress, 
    required this.title,
    required this.price,
    this.da,
    required this.q,
    required this.value,
    required this.fontSize,
    required this.color,
    required this.colorp,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress, 
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            // العنوان
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: color, fontSize: fontSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // السعر
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (da != null)
                    Text(
                      da!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: colorp, fontSize: fontSize),
                    ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      price,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: colorp, fontSize: fontSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // الكمية
            Expanded(
              flex: 2,
              child: Text(
                q,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: color, fontSize: fontSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            // القيمة
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (da != null)
                    Text(
                      da!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: colorp, fontSize: fontSize),
                    ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: colorp, fontSize: fontSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
