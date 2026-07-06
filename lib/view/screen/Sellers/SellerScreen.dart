import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Silaaty/controller/SellerController.dart';
import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/core/class/handlingview.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SellerController());

    return Scaffold(
      backgroundColor: AppColor.primarycolor,
      appBar: AppBar(
        title: Text(
          "إدارة البائعين".tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.white,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.backgroundcolor,
        onPressed: () {
          Get.find<SellerController>().openAddDialog();
          _showSellerDialog(context, isAdd: true);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: GetBuilder<SellerController>(builder: (controller) {
        return Handlingview(
          statusrequest: controller.statusrequest == Statusrequest.success &&
                  controller.sellers.isEmpty
              ? Statusrequest.failure
              : controller.statusrequest,
          // onRetry: () {
          //   controller.getSellers();
          // },
          widget: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.sellers.length,
            itemBuilder: (context, index) {
              var seller = controller.sellers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.backgroundcolor.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColor.backgroundcolor,
                            AppColor.primarycolor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.backgroundcolor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.storefront_rounded,
                            color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seller['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  seller['email'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.primarycolor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      AppColor.primarycolor.withOpacity(0.5)),
                            ),
                            child: Text(
                              "حساب بائع".tr,
                              style: const TextStyle(
                                color: AppColor.backgroundcolor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit_rounded,
                                color: Colors.blue, size: 20),
                            onPressed: () {
                              controller.openEditDialog(seller);
                              _showSellerDialog(context,
                                  isAdd: false, id: seller['id']);
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_rounded,
                                color: Colors.red, size: 20),
                            onPressed: () {
                              Get.defaultDialog(
                                backgroundColor: AppColor.white,
                                title: "Alert".tr,
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.backgroundcolor),
                                middleText:
                                    "هل أنت متأكد من حذف هذا البائع؟".tr,
                                onConfirm: () {
                                  Get.back();
                                  controller.deleteSeller(seller['id']);
                                },
                                onCancel: () {},
                                buttonColor: AppColor.backgroundcolor,
                                confirmTextColor: AppColor.primarycolor,
                                cancelTextColor: AppColor.backgroundcolor,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showSellerDialog(BuildContext context, {required bool isAdd, int? id}) {
    final controller = Get.find<SellerController>();
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Form(
            key: controller.formState,
            child: SingleChildScrollView(
              child: GetBuilder<SellerController>(
                builder: (controller) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      isAdd ? "إضافة بائع جديد".tr : "تعديل بيانات البائع".tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColor.backgroundcolor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: controller.nameController,
                      validator: (val) =>
                          val!.isEmpty ? "الحقل مطلوب".tr : null,
                      decoration: InputDecoration(
                        labelText: "الاسم".tr,
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColor.backgroundcolor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              color: AppColor.backgroundcolor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.emailController,
                      validator: (val) {
                        if (val!.isEmpty) return "الحقل مطلوب".tr;
                        if (!GetUtils.isEmail(val))
                          return "بريد إلكتروني غير صالح".tr;
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "البريد الإلكتروني".tr,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColor.backgroundcolor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              color: AppColor.backgroundcolor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.passwordController,
                      validator: (val) {
                        if (isAdd && val!.isEmpty) return "الحقل مطلوب".tr;
                        if (val!.isNotEmpty && val.length < 6)
                          return "كلمة المرور قصيرة (6 رموز على الأقل)".tr;
                        return null;
                      },
                      obscureText: controller.isPasswordHidden,
                      decoration: InputDecoration(
                        labelText: isAdd
                            ? "كلمة المرور".tr
                            : "كلمة المرور (اختياري)".tr,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColor.backgroundcolor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColor.backgroundcolor,
                          ),
                          onPressed: () {
                            controller.showPassword();
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              color: AppColor.backgroundcolor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.backgroundcolor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed:
                            controller.statusrequest == Statusrequest.loadeng
                                ? () {}
                                : () {
                                    if (isAdd) {
                                      controller.addSeller();
                                    } else {
                                      controller.updateSeller(id!);
                                    }
                                  },
                        child: controller.statusrequest == Statusrequest.loadeng
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                isAdd ? "إضافة البائع".tr : "حفظ التعديلات".tr,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
