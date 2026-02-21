import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionExpiredPage extends StatefulWidget {
  const SubscriptionExpiredPage({super.key});

  @override
  State<SubscriptionExpiredPage> createState() =>
      _SubscriptionExpiredPageState();
}

class _SubscriptionExpiredPageState extends State<SubscriptionExpiredPage> {
  @override
  Widget build(BuildContext context) {
    Myservices myservices = Get.find();

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Column(
          children: [
            // Alert Icon Section
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundcolor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundcolor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColor.backgroundcolor.withOpacity(0.4),
                            width: 4),
                      ),
                      child: Icon(
                        Icons.notification_important,
                        size: 56,
                        color: AppColor.backgroundcolor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Container (White Bottom Sheet)
            Container(
              width: double.infinity,
              height: Get.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Drag Indicator
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    margin: const EdgeInsets.only(bottom: 24),
                  ),

                  Text(
                    "انتهى اشتراكك".tr,
                    style: TextStyle(
                      color: Color(0xFF221610),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "لقد انتهت فترة صلاحية اشتراكك الحالي. يرجى التجديد للاستمرار في استخدام التطبيق ."
                        .tr,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Plan Details Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundcolor.withOpacity(0.05),
                      border: Border.all(
                          color: AppColor.backgroundcolor.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الباقة السابقة".tr,
                              style: TextStyle(
                                color: AppColor.backgroundcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "الخطة المجانية".tr,
                              style: TextStyle(
                                color: Color(0xFF221610),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "تاريخ الانتهاء".tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              myservices.sharedPreferences!
                                      .getString("date_experiment") ??
                                  "",
                              style: TextStyle(
                                color: Color(0xFF221610),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Call to Action Buttons
                  Column(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColor.backgroundcolor.withOpacity(0.3),
                              width: 2),
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: "codedev39@gmail.com",
                          );

                          try {
                            await launchUrl(
                              emailUri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("تعذر فتح تطبيق البريد".tr),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        icon: const Icon(FontAwesomeIcons.envelope,
                            color: Color(0xFF4850E5)),
                        label: Text(
                          "تواصل مع الدعم عبر البريد".tr,
                          style: TextStyle(
                            color: AppColor.backgroundcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColor.backgroundcolor.withOpacity(0.3),
                              width: 2),
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          // رقم واتساب مع كود الدولة بدون +
                          final phone = "213673628801"; // غيّر الرقم هنا
                          final message = Uri.encodeComponent(
                              "مرحبا، أحتاج لتجديد الإشتراك"
                                  .tr); // رسالة افتراضية

                          final Uri whatsappUri =
                              Uri.parse("https://wa.me/$phone?text=$message");

                          try {
                            await launchUrl(
                              whatsappUri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("تعذر فتح واتساب".tr),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        icon: const Icon(FontAwesomeIcons.whatsapp,
                            color: Color(0xFF4850E5)),
                        label: Text(
                          "تواصل مع الدعم عبر الواتساب".tr,
                          style: TextStyle(
                            color: AppColor.backgroundcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Additional Info
                  Text(
                    "بإمكانك التواصل مع فريق الدعم لتجديد الإشتراك".tr,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
