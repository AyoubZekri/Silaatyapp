import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Custemtypestatistice extends StatelessWidget {
  final void Function()? onPressed;
  final bool activte;
  final String title;

  const Custemtypestatistice({
    super.key,
    this.onPressed,
    required this.activte,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: (MediaQuery.of(context).size.width - 30) / 4,
      // decoration: BoxDecoration(
      //   color: color,
      //   borderRadius: BorderRadius.circular(20),
      // ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        // child: Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(
                    color: activte == true
                        ? AppColor.backgroundcolor
                        : Colors.grey,
                  )),
              const SizedBox(height: 8),
              if (activte == true)
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: AppColor.backgroundcolor))),
                )
            ],
          ),
        ),
      ),
    );
  }
}
