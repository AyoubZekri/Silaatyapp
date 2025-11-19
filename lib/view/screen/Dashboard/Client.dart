import 'package:Silaaty/controller/Profaile/transaction/transactionController.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingview.dart';
import '../../widget/Home/custemSearch.dart';
import '../../widget/sale/CustemcartClint.dart';

class Client extends StatefulWidget {
  const Client({super.key});

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
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
            'Convicts'.tr,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColor.backgroundcolor,
                  fontSize: 24,
                ),
          ),
        ),
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
                  iconData: Icons.people,
                  title: controller.query.isNotEmpty
                      ? "لم يتم العثور على عملاء مطابق للبحث".tr
                      : "لم تتم إضافة عملاء".tr,
                  widget: ListView.builder(
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
                          child: Custemcartclint(
                            Title: tran.transaction!.name!,
                            Body: tran.transaction!.phoneNumber!,
                            Price:
                                "${(tran.sumPrice ?? 0) < 0 ? 0 : tran.sumPrice}",
                            onTap: () {
                              print("Tapped on ${tran.transaction!.name!}");
                              controller.GotoBacksale(
                                  tran.transaction!.uuid!,
                                  tran.transaction!.name!,
                                  tran.transaction!.familyName!);
                            },
                            Status: tran.transaction!.Status!,
                            isStatus: true,
                          ));
                    },
                  ),
                )),
              ],
            )),
      );
    });
  }
}
