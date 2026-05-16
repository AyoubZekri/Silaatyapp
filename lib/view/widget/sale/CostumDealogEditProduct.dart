import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') return newValue;
    if (RegExp(r'^\d*\.?\d{0,3}$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class CustemQuantityDialog extends StatefulWidget {
  final TextEditingController controller;
  final Function() onConfirm;
  final Function() onCancel;
  final String title;
  final bool isDecimal;

  const CustemQuantityDialog({
    super.key,
    required this.controller,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    this.isDecimal = false,
  });

  @override
  State<CustemQuantityDialog> createState() => _CustemQuantityDialogState();
}

class _CustemQuantityDialogState extends State<CustemQuantityDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Center(
        child: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.backgroundcolor,
          ),
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: widget.isDecimal
              ? [DecimalTextInputFormatter()]
              : [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: "الكمية الجديدة",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(30),
            ),
            suffixIcon: const Icon(
              Icons.edit,
              color: AppColor.backgroundcolor,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "أدخل الكمية";
            }
            if (double.tryParse(value) == null ||
                double.parse(value) <= 0) {
              return "الكمية غير صالحة";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text("Cancel".tr),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.backgroundcolor,
          ),
          child: Text("Edit".tr,
              style: const TextStyle(color: AppColor.white)),
        ),
      ],
    );
  }
}
