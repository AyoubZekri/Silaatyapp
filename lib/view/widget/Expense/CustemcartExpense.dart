import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class CustemcartExpense extends StatefulWidget {
  final String name;
  final double price;
  final String description;
  final void Function()? onTap;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const CustemcartExpense({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CustemcartExpense> createState() => _CustemcartExpenseState();
}

class _CustemcartExpenseState extends State<CustemcartExpense> with SingleTickerProviderStateMixin {
  bool showActions = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showActions) {
          setState(() => showActions = false);
        } else {
          widget.onTap?.call();
        }
      },
      onLongPress: () {
        setState(() => showActions = !showActions);
      },
      child: Stack(
        children: [
          // Background Actions (Edit & Delete)
          if (showActions)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 28),
                      onPressed: widget.onEdit,
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                      onPressed: widget.onDelete,
                    ),
                  ],
                ),
              ),
            ),
          
          // Foreground Card
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: Get.locale?.languageCode == 'en'
                ? EdgeInsets.only(right: showActions ? 110 : 0)
                : EdgeInsets.only(left: showActions ? 110 : 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.backgroundcolor.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Decorative Background Icon / Watermark
                    Positioned(
                      right: Get.locale?.languageCode != 'en' ? null : -20,
                      left: Get.locale?.languageCode != 'en' ? -20 : null,
                      bottom: -20,
                      child: Icon(
                        Icons.receipt_long_outlined,
                        size: 120,
                        color: AppColor.backgroundcolor.withOpacity(0.03),
                      ),
                    ),
                    
                    // Main Card Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon Container
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor.backgroundcolor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 32,
                              color: AppColor.backgroundcolor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Text and Price Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    
                                    // Price Tag
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColor.backgroundcolor.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${widget.price} د.ج",
                                        style: const TextStyle(
                                          color: AppColor.backgroundcolor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
