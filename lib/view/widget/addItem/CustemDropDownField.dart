import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

class CustemDropDownField<T> extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;

  const CustemDropDownField({
    super.key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColor.grey),
        borderRadius: BorderRadius.circular(40),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  hintText,
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
          items: items,
          value: value,
          onChanged: onChanged,
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
    );
  }
}
