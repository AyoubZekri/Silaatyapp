import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class Custemdropdawnanimated extends StatelessWidget {
  final List<String> customers;
  final RxString selectedCustomer;
  final Function(String) onSelect;
  final RxBool isExpanded = false.obs;

  Custemdropdawnanimated({
    super.key,
    required this.customers,
    required this.selectedCustomer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: Column(
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
                    Text(
                      selectedCustomer.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selectedCustomer.value == "العميل"
                            ? AppColor.grey
                            : Colors.black,
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
              height: isExpanded.value ? customers.length * 55 : 0,
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
                  children: customers.map((value) {
                    return ListTile(
                      title: Text(value),
                      onTap: () {
                        onSelect(value);
                        isExpanded.value = false;
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
