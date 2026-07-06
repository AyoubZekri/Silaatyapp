import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/Colorapp.dart';

class Handlingview extends StatelessWidget {
  final Statusrequest statusrequest;
  final String? title;
  final IconData? iconData;
  final Widget widget;
  final Future<void> Function()? onRefresh;

  const Handlingview({
    super.key,
    required this.statusrequest,
    required this.widget,
    this.title,
    this.iconData,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (statusrequest) {
      case Statusrequest.loadeng:
      case Statusrequest.none:
        content = Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: AppColor.backgroundcolor.withOpacity(0.1),
              valueColor:
                  const AlwaysStoppedAnimation(AppColor.backgroundcolor),
            ),
          ),
        );
        break;

      case Statusrequest.serverfailure:
        content = _errorView(
          icon: Icons.dns_rounded,
          message: "خطأ في الخادم".tr,
        );
        break;

      case Statusrequest.offlinefailure:
        content = _errorView(
          icon: Icons.wifi_off_rounded,
          message: "لا يوجد اتصال بالإنترنت".tr,
        );
        break;

      case Statusrequest.failure:
        content = _errorView(
          icon: iconData ?? Icons.folder_open_rounded,
          message: title ?? 'لا توجد بيانات لعرضها'.tr,
        );
        break;
      default:
        content = widget;
    }

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppColor.backgroundcolor,
        child: content,
      );
    }
    return content;
  }

  Widget _errorView({
    required IconData icon,
    required String message,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // 🔹 مهم للـ RefreshIndicator
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // يشغل كل مساحة الشاشة
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Folder card with pulse animation style
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.backgroundcolor.withOpacity(0.05),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: AppColor.backgroundcolor.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.backgroundcolor.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: 80,
                          color: AppColor.backgroundcolor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Text
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

