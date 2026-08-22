import 'package:Silaaty/controller/Expense/ExpenseController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Expense/CustemcartExpense.dart';
import 'package:Silaaty/view/widget/Expense/CustemExpenseDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  Expensecontroller controller = Get.put(Expensecontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Expensecontroller>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(
            color: AppColor.backgroundcolor,
          ),
          title: Text(
            'Expenses'.tr,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColor.backgroundcolor,
                  fontSize: 24,
                ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => CustomExpenseDialog(
                      nameController: controller.nameController,
                      priceController: controller.priceController,
                      descriptionController: controller.descriptionController,
                      formKey: controller.formstate,
                      title: "Add Expense".tr,
                      onSubmit: () {
                        controller.addExpense();
                      },
                      onCancel: () {
                        Get.back();
                      },
                    ));
          },
          backgroundColor: AppColor.backgroundcolor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshdata();
          },
          child: Handlingview(
            statusrequest: controller.statusrequest,
            iconData: Icons.account_balance_wallet_outlined,
            title: "No Expenses Added".tr,
            widget: Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundcolor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.backgroundcolor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Expenses".tr,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${controller.totalExpenses} د.ج",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.expense.length,
                      itemBuilder: (context, index) {
                        final exp = controller.expense[index];
                        return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 300 + (index * 2)),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(50 * (1 - value), 0),
                                  child: child,
                                ),
                              );
                            },
                            child: CustemcartExpense(
                              name: exp.name ?? "",
                              price: exp.price ?? 0.0,
                              description: exp.description ?? "",
                              onEdit: () {
                                controller.nameEditController.text =
                                    exp.name ?? "";
                                controller.priceEditController.text =
                                    (exp.price ?? 0.0).toString();
                                controller.descriptionEditController.text =
                                    exp.description ?? "";
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomExpenseDialog(
                                          nameController:
                                              controller.nameEditController,
                                          priceController:
                                              controller.priceEditController,
                                          descriptionController: controller
                                              .descriptionEditController,
                                          formKey: controller.formstate,
                                          title: "Edit Expense".tr,
                                          onSubmit: () {
                                            controller.EditExpense(exp.uuid);
                                          },
                                          onCancel: () {
                                            Get.back();
                                          },
                                        ));
                              },
                              onTap: () {
                                // Maybe go to expense details if needed, similar to Gotoinforeport
                              },
                              onDelete: () {
                                Get.defaultDialog(
                                  backgroundColor: AppColor.white,
                                  title: "تنبيه".tr,
                                  titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.backgroundcolor),
                                  middleText: "هل تريد حذف المصروف؟".tr,
                                  onConfirm: () {
                                    controller.deleteExpense(exp.uuid);
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                  buttonColor: AppColor.backgroundcolor,
                                  confirmTextColor: AppColor.primarycolor,
                                  cancelTextColor: AppColor.backgroundcolor,
                                );
                              },
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
