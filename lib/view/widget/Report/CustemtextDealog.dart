import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/functions/valiedinput.dart';

class CustomReportDialog extends StatefulWidget {
  final TextEditingController? controller;
  final Function() onSubmit;
  final Function() onCancel;
  final Key? formKey;
  final String title;

  const CustomReportDialog({
    super.key,
    this.controller,
    required this.onSubmit,
    required this.onCancel,
    this.formKey,
    required this.title,
  });

  @override
  State<CustomReportDialog> createState() => _CustomReportDialogState();
}

class _CustomReportDialogState extends State<CustomReportDialog> {
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
          style:const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.backgroundcolor,
          ),
        ),
      ),
      content: Form(
        key: widget.formKey,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          maxLines: 6,
          minLines: 4,
          validator: (val) {
            return validInput(val!, 100, 1, "Username");
          },
          decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 12),
            labelText: "content Report".tr,
            alignLabelWithHint: true,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text("Cansel".tr),
        ),
        ElevatedButton(
          onPressed: widget.onSubmit,
          child: Text("save".tr),
        ),
      ],
    );
  }
}
