import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Custemtitleorbody extends StatelessWidget {
  final String Body;
  final String? title;
  final String? email;

  const Custemtitleorbody({
    super.key,
    this.title,
    required this.Body,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
        Text(
          title!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        email != null
            ? RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16, height: 1.5),
                  children: [
                    TextSpan(
                      text: "$Body ",
                    ),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        color: AppColor.backgroundcolor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: email,
                          );
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("لا يوجد تطبيق بريد مثبت على الجهاز"),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                    ),
                  ],
                ),
              )
            : Text(
                Body,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.grey,
                  height: 1.5,
                ),
              ),
      ],
    );
  }
}
