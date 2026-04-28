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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // العنوان (Name)
            Expanded(
              flex: 3,
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

            const SizedBox(width: 4),

            // السعر (Price)
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (da != null)
                  //   Text(
                  //     da!,
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headlineMedium!
                  //         .copyWith(color: colorp, fontSize: fontSize - 2),
                  //   ),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      price,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: colorp, fontSize: fontSize),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // الكمية (Qty)
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

            const SizedBox(width: 8),

            // القيمة (Total Value)
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (da != null)
                  //   Text(
                  //     da!,
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headlineMedium!
                  //         .copyWith(color: colorp, fontSize: fontSize - 2),
                  //   ),
                  // const SizedBox(width: 2),
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
