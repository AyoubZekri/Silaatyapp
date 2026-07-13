import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class CustemSaleTypeDropdownAnimated extends StatelessWidget {
  final RxInt selectedSaleType;
  final Function(int) onSelect;
  final int allowedSellType;
  final RxBool isExpanded = false.obs;

  late final Map<int, String> saleTypes = {
    1: "تجزئة".tr,
    if (allowedSellType >= 2) 2: "نصف جملة".tr,
    if (allowedSellType >= 3) 3: "جملة".tr,
  };

  CustemSaleTypeDropdownAnimated({
    super.key,
    required this.selectedSaleType,
    required this.onSelect,
    required this.allowedSellType,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => isExpanded.value = !isExpanded.value,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: AppColor.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      saleTypes[selectedSaleType.value] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: isExpanded.value ? 0.5 : 0,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded.value ? saleTypes.length * 55.0 : 0.0,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: saleTypes.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value),
                    onTap: () {
                      onSelect(entry.key);
                      isExpanded.value = false;
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}
