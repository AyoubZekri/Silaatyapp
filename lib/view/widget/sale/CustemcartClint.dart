import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class Custemcartclint extends StatelessWidget {
  final String Title;
  final String Body;
  final String Price;
  final int Status;
  final bool isStatus;

  final void Function()? onTap;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const Custemcartclint({
    super.key,
    required this.Title,
    required this.Body,
    required this.Price,
    this.onTap,
    this.onEdit,
    this.onDelete,
    required this.Status,
    required this.isStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Stack(
          children: [
            InkWell(
              onTap: onTap, // 👈 هذا هو المفتاح
              borderRadius: BorderRadius.circular(15),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.4, color: AppColor.grey),
                        ),
                        child: const Icon(Icons.person, size: 70),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontSize: 20)),
                            const SizedBox(height: 1),
                            Text(
                              Body,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  Price,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                Text(
                                  "DA".tr,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
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
      ],
    );
  }
}


