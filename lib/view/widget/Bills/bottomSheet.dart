import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';

class ProductActionsBottomSheet extends StatelessWidget {
  final VoidCallback onReturn;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductActionsBottomSheet({
    super.key,
    required this.onReturn,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),

            _actionTile(
              icon: Icons.keyboard_return,
              title: 'إرجاع المنتج',
              color: Colors.blue,
              onTap: () {
                Get.back();
                onReturn();
              },
            ),

            _actionTile(
              icon: Icons.edit,
              title: 'تعديل المنتج',
              color: Colors.orange,
              onTap: () {
                Get.back();
                onEdit();
              },
            ),

            _actionTile(
              icon: Icons.delete,
              title: 'حذف المنتج',
              color: Colors.red,
              onTap: () {
                Get.back();
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: const [
        Expanded(
          child: Text(
            'اختر العملية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_back_ios, size: 16),
    );
  }
}
