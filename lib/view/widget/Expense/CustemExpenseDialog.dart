import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/functions/valiedinput.dart';

class CustomExpenseDialog extends StatefulWidget {
  final TextEditingController? nameController;
  final TextEditingController? priceController;
  final TextEditingController? descriptionController;
  final Function() onSubmit;
  final Function() onCancel;
  final Key? formKey;
  final String title;

  const CustomExpenseDialog({
    super.key,
    this.nameController,
    this.priceController,
    this.descriptionController,
    required this.onSubmit,
    required this.onCancel,
    this.formKey,
    required this.title,
  });

  @override
  State<CustomExpenseDialog> createState() => _CustomExpenseDialogState();
}

class _CustomExpenseDialogState extends State<CustomExpenseDialog> {
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
      content: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: widget.nameController,
                keyboardType: TextInputType.text,
                validator: (val) {
                  return validInput(val!, 100, 1, "Username");
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 12),
                  labelText: "Expense Name".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: widget.priceController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  return validInput(val!, 100, 1, "number");
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 12),
                  labelText: "Price".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: widget.descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                minLines: 2,
                validator: (val) {
                  return validInput(val!, 1000, 1, "Username");
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 12),
                  labelText: "Description".tr,
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
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
