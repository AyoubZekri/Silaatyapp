import 'package:Silaaty/controller/Profaile/transaction/transactionController.dart';
import 'package:Silaaty/core/class/handlingview.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:Silaaty/view/widget/Profaile/custemCartDealer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/Home/custemSearch.dart';

class Dealer extends StatefulWidget {
  const Dealer({super.key});

  @override
  State<Dealer> createState() => _DealerState();
}

class _DealerState extends State<Dealer> {
  Transactioncontroller controller = Get.put(Transactioncontroller());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Transactioncontroller>(builder: (controller) {
      return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            iconTheme: const IconThemeData(
              color: AppColor.backgroundcolor,
            ),
            title: Text(
              'Dealer'.tr,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColor.backgroundcolor,
                    fontSize: 24,
                  ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.GotoAddDealer();
            },
            backgroundColor: AppColor.backgroundcolor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: Column(
              children: [
                Custemsearch(
                  Search: "Search".tr,
                  onChanged: (text) {
                    controller.query = text;
                    controller.getTransactions();
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: Handlingview(
                  statusrequest: controller.statusrequest,
                  widget: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.transaction.length,
                    itemBuilder: (context, index) {
                      final tran = controller.transaction[index];
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
                          child: Custemcartdealer(
                            Title: tran.transaction!.name!,
                            Body: tran.transaction!.phoneNumber!,
                            Price:
                                "${(tran.sumPrice ?? 0) < 0 ? 0 : tran.sumPrice}",
                            Status: tran.transaction!.Status!,
                            isStatus: false,
                            onEdit: () {
                              controller.GotoEditDealer();
                            },
                            onTap: () {
                              controller.GotoinvoiceDealer(
                                  tran.transaction!.id!);
                            },
                            onDelete: () {
                              Get.defaultDialog(
                                backgroundColor: AppColor.white,
                                title: "تنبيه",
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.backgroundcolor),
                                middleText: "هل تريد حذف المنتج؟",
                                onConfirm: () {
                                  controller
                                      .deletetransaction(tran.transaction!.id!);
                                },
                                onCancel: () {},
                                buttonColor: AppColor.backgroundcolor,
                                confirmTextColor: AppColor.primarycolor,
                                cancelTextColor: AppColor.backgroundcolor,
                              );
                            },
                          ));
                    },
                  ),
                )),
              ],
            ),
          ));
    });
  }
}
