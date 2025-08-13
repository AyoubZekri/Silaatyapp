import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemcartdealer extends StatefulWidget {
  final String Title;
  final String Body;
  final String Price;
  final int Status;
  final bool isStatus;

  final void Function()? onTap;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const Custemcartdealer({
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
  State<Custemcartdealer> createState() => _CustemcartdealerState();
}

class _CustemcartdealerState extends State<Custemcartdealer> {
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
          if (showActions)
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
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
                            border:
                                Border.all(width: 0.4, color: AppColor.grey),
                          ),
                          child: const Icon(Icons.person, size: 70),
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
                              const SizedBox(height: 1),
                              Text(
                                widget.Body,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "Price: ${widget.Price} DA",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.isStatus)
                  Positioned(
                    top: 10,
                    left: isEn ? null : 15,
                    right: isEn ? 15 : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            widget.Status == 0 ? Colors.green : Colors.orange,
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
                        widget.Status == 0 ? "hopeless" : "hopeful",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
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
