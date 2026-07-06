import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';

class Custembuttonauth extends StatelessWidget {
  final void Function()? onPressed;
  final String Textname;
  final bool isLoading;
  
  const Custembuttonauth({
    super.key, 
    this.onPressed, 
    required this.Textname,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        onPressed: isLoading ? () {} : onPressed,
        color: AppColor.backgroundcolor,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                Textname,
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
