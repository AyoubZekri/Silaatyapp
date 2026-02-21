import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';

class ProductActionsBottomSheet extends StatelessWidget {
  final VoidCallback onReturn;
  final VoidCallback onEdit;

  const ProductActionsBottomSheet({
    super.key,
    required this.onReturn,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    bool isRTL = Get.locale?.languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _actionTile(
              icon: Icons.keyboard_return,
              title: 'return_product'.tr,
              color: Colors.blue,
              onTap: onReturn,
            ),
            _actionTile(
              icon: Icons.edit,
              title: 'edit_product'.tr,
              color: Colors.orange,
              onTap: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'select_operation'.tr,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.grey,
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
