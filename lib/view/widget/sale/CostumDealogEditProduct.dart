import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustemQuantityDialog extends StatefulWidget {
  final TextEditingController controller;
  final Function() onConfirm;
  final Function() onCancel;
  final String title;

  const CustemQuantityDialog({
    super.key,
    required this.controller,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
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
          keyboardType: TextInputType.number,
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
            if (int.tryParse(value) == null || int.parse(value) <= 0) {
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
