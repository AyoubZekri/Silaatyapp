import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'CustemTextFromQuntety.dart';

class Customaddquntetyproductdialog extends StatefulWidget {
  final TextEditingController? Mycontroller;
  final Function() onPressed;
  final int value;

  // final String? Function(String?) valid;
  final Function() onback;
  final Function(int) onChanged;
  final Key? form;
  final String title;

  const Customaddquntetyproductdialog(
      {super.key,
      this.Mycontroller,
      required this.onPressed,
      required this.onback,
      required this.value,
      this.form,
      required this.title,
      required this.onChanged});

  @override
  State<Customaddquntetyproductdialog> createState() =>
      _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<Customaddquntetyproductdialog> {
  late TextEditingController _controller;
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;

    _controller = widget.Mycontroller ?? TextEditingController();
    _controller.text = _value.toString();

    _controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    if (!mounted) return;
    final parsed = int.tryParse(_controller.text);
    if (parsed != null && parsed != _value) {
      setState(() {
        _value = parsed;
      });
      widget.onChanged(_value);
    }
  }

  void _updateValue(int newValue) {
    if (!mounted) return;
    setState(() {
      _value = newValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text = _value.toString();
      });
    });
    widget.onChanged(_value);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    if (widget.Mycontroller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

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
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColor.backgroundcolor),
        ),
      ),
      content: Form(
        key: widget.form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.grey, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        // labelText: widget.label,
                        labelStyle: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                        hintText: "Quantity".tr,
                        hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.grey),
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (_value > 0) _updateValue(_value - 1);
                        },
                        icon: Icon(Icons.arrow_back_ios,
                            color: AppColor.grey, size: 16),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          _updateValue(_value + 1);
                        },
                        icon: Icon(Icons.arrow_forward_ios,
                            color: AppColor.grey, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onback,
          child: Text("إلغاء".tr),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.backgroundcolor,
            foregroundColor: AppColor.white,
          ),
          onPressed: widget.onPressed,
          child: Text(
            "Add".tr,
            style: TextStyle(color: AppColor.white),
          ),
        ),
      ],
    );
  }
}
