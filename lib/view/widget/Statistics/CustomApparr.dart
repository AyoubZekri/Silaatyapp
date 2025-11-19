import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Customapparr extends StatelessWidget {
  final String period;
  final String revenue;
  final String profit;

  const Customapparr({
    super.key,
    required this.period,
    required this.revenue,
    required this.profit,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              if (period.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Get.locale?.languageCode == 'en' ? 35 : 0,
                        right: Get.locale?.languageCode == 'ar' ? 35 : 0),
                    child: Text(period,
                        textAlign: Get.locale?.languageCode == 'ar'
                            ? TextAlign.right
                            : TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              if (revenue.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: Text(revenue,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              if (profit.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Text(profit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: const Color.fromARGB(255, 216, 215, 215)))),
        )
      ],
    );
  }
}
