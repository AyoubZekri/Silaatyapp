import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custemfilterdialog<T> extends StatefulWidget {
  final Function() onConfirm;
  final Function() onCancel;
  final String title;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;

  const Custemfilterdialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    required this.hintText,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  State<Custemfilterdialog<T>> createState() => _CustemfilterdialogState<T>();
}

class _CustemfilterdialogState<T> extends State<Custemfilterdialog<T>> {
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
      content: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: AppColor.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.hintText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: widget.items,
            value: widget.value,
            onChanged: (value) {
              widget.onChanged(value);
            },
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(255, 203, 201, 201),
                ),
              ),
              elevation: 8,
            ),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 24,
              iconEnabledColor: Colors.black,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text("Cancel".tr),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.backgroundcolor,
          ),
          child:
              Text("تأكيد".tr, style: const TextStyle(color: AppColor.white)),
        ),
      ],
    );
  }
}
