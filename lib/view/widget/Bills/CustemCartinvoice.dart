import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemcartinvoice extends StatefulWidget {
  final String Title;
  final String Status;
  final String Price;
  final String day;
  final String Mon;

  final void Function()? onTap;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const Custemcartinvoice({
    super.key,
    required this.Title,
    required this.Status,
    required this.Price,
    this.onTap,
    this.onEdit,
    this.onDelete,
    required this.day,
    required this.Mon,
  });

  @override
  State<Custemcartinvoice> createState() => _CustemcartinvoiceState();
}

class _CustemcartinvoiceState extends State<Custemcartinvoice> {
  bool showActions = false;

  @override
  Widget build(BuildContext context) {
    final isEn = Get.locale?.languageCode == 'en';

    return GestureDetector(
      onTap: () {
        if (showActions) {
          setState(() {
            showActions = false;
          });
        } else {
          widget.onTap?.call();
        }
      },
      onLongPress: () {
        setState(() {
          showActions = !showActions;
        });
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: isEn ? 15 : null,
            left: !isEn ? 15 : null,
            top: 20,
            bottom: 20,
            child: AnimatedOpacity(
              opacity: showActions ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        widget.onEdit?.call();
                        if (mounted) {
                          setState(() {
                            showActions = false;
                          });
                        }
                      }),
                  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.onDelete?.call();
                        if (mounted) {
                          setState(() {
                            showActions = false;
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: isEn
                ? EdgeInsets.only(right: showActions ? 100 : 0)
                : EdgeInsets.only(left: showActions ? 100 : 0),
            child: Stack(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 0.4, color: AppColor.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.day,
                                  style: const TextStyle(height: 1)),
                              const SizedBox(height: 2),
                              Text(widget.Mon,
                                  style: const TextStyle(height: 1)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.Title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontSize: 20)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    "${widget.Price} ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  Text(
                                    "DA".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
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
                Positioned(
                  top: 10,
                  left: isEn ? null : 15,
                  right: isEn ? 15 : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.Status == "Sincere".tr
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: isEn
                            ? const Radius.circular(0)
                            : const Radius.circular(15),
                        topRight: isEn
                            ? const Radius.circular(15)
                            : const Radius.circular(0),
                        bottomRight: isEn
                            ? const Radius.circular(0)
                            : const Radius.circular(8),
                        bottomLeft: isEn
                            ? const Radius.circular(8)
                            : const Radius.circular(0),
                      ),
                    ),
                    child: Text(
                      widget.Status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
