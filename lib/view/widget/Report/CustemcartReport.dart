import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemcartreport extends StatefulWidget {
  final String Body;
  final void Function()? onTap;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const Custemcartreport({
    super.key,
    required this.Body,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<Custemcartreport> createState() => _CustemcartreportState();
}

class _CustemcartreportState extends State<Custemcartreport> {
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
            duration: Duration(milliseconds: 200),
            padding: Get.locale?.languageCode == 'en'
                ? EdgeInsets.only(right: showActions ? 100 : 0)
                : EdgeInsets.only(left: showActions ? 100 : 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(width: 0.4, color: AppColor.grey),
                      ),
                      child: Icon(
                        Icons.feedback,
                        size: 50,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
