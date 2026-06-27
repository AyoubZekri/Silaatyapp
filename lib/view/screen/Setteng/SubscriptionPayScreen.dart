import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Silaaty/controller/Setteng/SubscriptionPayController.dart';

class SubscriptionPayScreen extends StatefulWidget {
  const SubscriptionPayScreen({super.key});

  @override
  State<SubscriptionPayScreen> createState() => _SubscriptionPayScreenState();
}

class _SubscriptionPayScreenState extends State<SubscriptionPayScreen> {
  final controller = Get.put(SubscriptionPayController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          title: Text(
            "دفع الاشتراك والتجديد".tr,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111827)),
            onPressed: () => Get.back(),
          ),
        ),
        body: GetBuilder<SubscriptionPayController>(builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColor.backgroundcolor, Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.backgroundcolor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "حالة الاشتراك الحالي".tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: "Cairo",
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.status == 2
                                  ? "فترة تجريبية".tr
                                  : DateTime.parse(controller.expiryDate)
                                          .isBefore(DateTime.now())
                                      ? "منتهي".tr
                                      : "نشط".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${"تاريخ الانتهاء: ".tr} ${controller.expiryDate}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: "Cairo",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. الخطوة 1: اختر خطة الاشتراك
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "1. اختر خطة الاشتراك المناسبة:".tr,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // بطاقات الباقات التفاعلية
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.plans.length,
                  itemBuilder: (context, index) {
                    final plan = controller.plans[index];
                    final isSelected = controller.selectedPlanIndex == index;

                    return GestureDetector(
                      onTap: () {
                        controller.changePlanIndex(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColor.backgroundcolor
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColor.backgroundcolor.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: isSelected
                                      ? AppColor.backgroundcolor
                                      : Colors.grey[400],
                                  size: 24,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plan["title"],
                                        style: TextStyle(
                                          color: const Color(0xFF111827),
                                          fontFamily: "Cairo",
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        plan["desc"],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: "Cairo",
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      plan["price"],
                                      style: TextStyle(
                                        color: AppColor.backgroundcolor,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      plan["period"],
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontFamily: "Cairo",
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (plan["badge"] != null)
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    plan["badge"],
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontFamily: "Cairo",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_user_rounded,
                              color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Text(
                            "ما تحصل عليه في كافة باقات صلاتي".tr,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      ...controller.features.map((feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFF10B981),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      color: Color(0xFF4B5563),
                                      fontFamily: "Cairo",
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // زر الدفع (يظهر بلون تفاعلي بناءً على ملء البيانات)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          controller.createPayment();
                        },
                        icon: const Icon(FontAwesomeIcons.creditCard, size: 24),
                        label: Text(
                          "${controller.status == 2 ? "بدء" : "تجديد"} الاشتراك والدفع"
                              .tr,
                          style: const TextStyle(
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  Widget _buildPaymentDetailRow({
    required String label,
    required String value,
    String? copyText,
    required VoidCallback onCopy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontFamily: "Cairo",
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.copy_rounded,
                    color: AppColor.backgroundcolor, size: 20),
                onPressed: onCopy,
                tooltip: "نسخ".tr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
