import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustemEditInvoiceDialog extends StatefulWidget {
  final TextEditingController? Mycontroller;
  final Function() onPressed;
  // final String? Function(String?) valid;
  final Function() onback;
  final String lableText;
  final Key? form;
  final String title;

  const CustemEditInvoiceDialog(
      {super.key,
      this.Mycontroller,
      required this.onPressed,
      required this.onback,
      this.form,
      required this.title, required this.lableText});

  @override
  State<CustemEditInvoiceDialog> createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<CustemEditInvoiceDialog> {
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
            // TextFormField(
            //   controller: widget.Mycontroller,
            //   readOnly: true,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return "الرجاء اختيار تاريخ الدفع";
            //     }
            //     return null;
            //   },
            //   decoration: InputDecoration(
            //     labelText: "تاريخ الدفع",
            //     filled: true,
            //     fillColor: Colors.grey[100],
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: Colors.grey),
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     suffixIcon: Icon(
            //       Icons.calendar_today,
            //       color: AppColor.backgroundcolor,
            //     ),
            //   ),
            //   onTap: () async {
            //     DateTime? pickedDate = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime(2000),
            //       lastDate: DateTime(2100),
            //     );
            //     if (pickedDate != null) {
            //       widget.Mycontroller?.text =
            //           "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            //     }
            //   },
            // ),
            // SizedBox(height: 10),
            TextFormField(
              controller: widget.Mycontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.lableText,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: Icon(
                  Icons.attach_money,
                  color: AppColor.backgroundcolor,
                ),
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
          child: Text("Add".tr),
        ),
      ],
    );
  }
}
