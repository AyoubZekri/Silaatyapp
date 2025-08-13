import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustemDatePickerField extends StatefulWidget {
  final String hintText;
  final String label;
  final IconData iconData;
  final TextEditingController controller;

  const CustemDatePickerField({
    super.key,
    required this.hintText,
    required this.label,
    required this.iconData,
    required this.controller,
  });

  @override
  State<CustemDatePickerField> createState() => _CustemDatePickerFieldState();
}

class _CustemDatePickerFieldState extends State<CustemDatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColor.grey),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Icon(widget.iconData, color: AppColor.backgroundcolor),
          const SizedBox(width: 10),
          Container(height: 30, width: 1, color: AppColor.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
