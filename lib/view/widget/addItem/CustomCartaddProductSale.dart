import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/constant/imageassets.dart';

class Customcartaddproductsale extends StatelessWidget {
  final String uuid;
  final String? imgitems;
  final String Title;
  final String Price;
  final String Body;

  final bool image;
  final bool isLoading;
  final bool isSelected;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onTap;

  const Customcartaddproductsale({
    super.key,
    required this.uuid,
    this.imgitems,
    required this.Title,
    required this.Price,
    required this.image,
    this.isLoading = false,
    required this.isSelected,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.onTap,
    required this.Body,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColor.primarycolor.withOpacity(0.07) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected
              ? AppColor.primarycolor
              : AppColor.primarycolor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: image ? 100 : 50,
              width: image ? 100 : 50,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.4, color: AppColor.grey),
                image: isLoading
                    ? null
                    : DecorationImage(
                        image: (imgitems?.isNotEmpty ?? false)
                            ? FileImage(File(imgitems!))
                            : const AssetImage(Appimageassets.test2)
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                color: isLoading ? Colors.white : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان الرئيسي بدون حاوية
                  isLoading
                      ? Container(
                          height: 16,
                          width: 150,
                          color: Colors.white,
                        )
                      : Text(
                          Title,
                          style: image
                              ? Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontSize: 20)
                              : Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontSize: 22),
                          overflow: TextOverflow.ellipsis,
                        ),
                  const SizedBox(height: 10),

                  isLoading
                      ? Container(
                          height: 16,
                          width: 100,
                          color: Colors.white,
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.backgroundcolor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Quantity:".tr,
                                style: const TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                Body,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 5),

                  if (image)
                    isLoading
                        ? Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.white,
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor.backgroundcolor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Price:".tr,
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "$Price",
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "DA".tr,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        InkWell(onTap: onTap, child: cardContent),
        Positioned(
          top: 8,
          left: Get.locale?.languageCode == 'ar' ? 15 : null,
          right: Get.locale?.languageCode == 'ar' ? null : 15,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                color: AppColor.grey,
                onPressed: onDecrement,
              ),
              Text(
                "$quantity",
                style: const TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                color: AppColor.grey,
                onPressed: onIncrement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
