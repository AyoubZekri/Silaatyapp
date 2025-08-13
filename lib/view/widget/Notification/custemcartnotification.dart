import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemcartnotification extends StatefulWidget {
  final String Title;
  final String Body;
  final void Function()? onTap;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const Custemcartnotification({
    super.key,
    required this.Title,
    required this.Body,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<Custemcartnotification> createState() => _CustemcartnotificationState();
}

class _CustemcartnotificationState extends State<Custemcartnotification> {
  bool showActions = false;

  @override
  Widget build(BuildContext context) {
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
                    icon:const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          AnimatedPadding(
            duration:const Duration(milliseconds: 200),
            padding: Get.locale?.languageCode == 'en'
                ? EdgeInsets.only(right: showActions ? 50 : 0)
                : EdgeInsets.only(left: showActions ? 50 : 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
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
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        size: 40,
                        color: AppColor.backgroundcolor,
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
                          const SizedBox(height: 1),
                          Text(
                            widget.Body,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
