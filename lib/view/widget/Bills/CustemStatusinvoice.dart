import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemstatusinvoice extends StatelessWidget {
  final String status;
  const Custemstatusinvoice({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.help_outline;
    Color color = Colors.grey;
    String label = "غير معروف";

    switch (status) {
      case 'paid':
        icon = Icons.check_circle;
        color = Colors.green;
        label = "Sincere".tr;
        break;
      case 'unpaid':
        icon = Icons.error_outline;
        color = Colors.orange;
        label = "Not Sincere".tr;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}
