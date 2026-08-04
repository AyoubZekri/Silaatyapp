import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/FormatQuantity.dart';
import 'package:Silaaty/data/datasource/Remote/invoiceData.dart';
import 'package:Silaaty/data/datasource/Remote/SellerStockData.dart';
import 'package:Silaaty/data/model/InvoiceModel.dart';
import 'package:Silaaty/view/widget/Sellers/CustemStockTransferDialog.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constant/Colorapp.dart';
import '../core/constant/routes.dart';

class SellerInvoicesController extends GetxController {
  int selectedIndex = 3;
  late Map seller;

  Statusrequest statusrequest = Statusrequest.none;
  Invoicedata invoicedata = Invoicedata(Get.find());
  SellerStockData sellerStockData = SellerStockData(Get.find());
  InvoiceData? invoice;

  @override
  void onInit() {
    seller = Get.arguments ?? {};
    showInvoice();
    super.onInit();
  }

  showInvoice() async {
    statusrequest = Statusrequest.loadeng;
    update();

    try {
      final sellerId = seller['id'];
      if (sellerId != null) {
        final result = await invoicedata.getSellerInvoices(sellerId);
        if (result['data'] != null) {
          final data = result['data'];
          
          List<InvoiceItem> invoiceList = [];
          if (data['invoices'] != null) {
            invoiceList = (data['invoices'] as List).map((i) => InvoiceItem.fromJson(i)).toList();
          }

          invoice = InvoiceData(
            transaction: null, // Since these aren't bound to one transaction
            invoices: invoiceList,
            sumPrice: (data['sum_price'] ?? 0.0).toDouble(),
            sumPaymentPrice: (data['sum_payment_Price'] ?? 0.0).toDouble(),
          );
        }
      }
    } catch (e) {
      print("Error fetching seller invoices: $e");
    }

    statusrequest = Statusrequest.success;
    update();
  }

  String getRemainingAmount() {
    final total = invoice?.sumPrice ?? 0.0;
    final paid = invoice?.sumPaymentPrice ?? 0.0;
    double remaining = total - paid;
    
    remaining = double.parse(remaining.toStringAsFixed(3));
    
    return formavalue(remaining <= 0 ? 0 : remaining);
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  String getMonthAbbreviation(String? date) {
    if (date == null || date.length < 7) return '';
    final month = date.substring(5, 7);
    const months = {
      '01': 'Jan', '02': 'Feb', '03': 'Mar', '04': 'Apr',
      '05': 'May', '06': 'Jun', '07': 'Jul', '08': 'Aug',
      '09': 'Sep', '10': 'Oct', '11': 'Nov', '12': 'Dec',
    };
    return months[month] ?? '';
  }

  refreshData() async {
    await showInvoice();
    update();
  }

  gotoNewSale() {
    // Navigate to create a new sale.
  }

  deleteInvoice(String uuid) {
    // Implement delete logic here
  }
  
  gotoShowInvoice(InvoiceItem invoice) {
    Get.toNamed(
      Approutes.shwoinvoice,
      arguments: {"invoice": invoice},
    );
  }

  void openSendStockDialog() async {
    try {
      final String sellerUuid = seller['id'].toString();
      
      final products = await sellerStockData.getAdminProducts();
      
      if (products.isEmpty) {
        showSnackbar("تنبيه".tr, "لا توجد منتجات متوفرة في المستودع الرئيسي".tr, Colors.orange);
        return;
      }

      Get.bottomSheet(
        CustemStockTransferDialog(
          title: "تزويد المخزون".tr,
          products: products,
          isReturn: false,
          onSubmit: (String productUuid, double quantity) async {
            Get.back();
            try {
              bool result = await sellerStockData.sendStockToSeller(sellerUuid, productUuid, quantity);
              if (result) {
                showSnackbar("نجاح".tr, "تم إرسال المنتجات للبائع بنجاح".tr, Colors.green);
              } else {
                showSnackbar("خطأ".tr, "حدث خطأ أثناء الإرسال".tr, Colors.red);
              }
            } catch(e) {
              showSnackbar("خطأ".tr, e.toString(), Colors.red);
            }
          },
          onTransferAll: () async {
            Get.back();
            try {
              int successCount = 0;
              for (var product in products) {
                String productUuid = product['uuid'];
                double quantity = double.tryParse(product['product_quantity'].toString()) ?? 0.0;
                if (quantity > 0) {
                  bool result = await sellerStockData.sendStockToSeller(sellerUuid, productUuid, quantity);
                  if (result) successCount++;
                }
              }
              if (successCount > 0) {
                showSnackbar("نجاح".tr, "تم تزويد كل المنتجات المتاحة بنجاح".tr, Colors.green);
              } else {
                showSnackbar("تنبيه".tr, "لم يتم نقل أي منتجات".tr, Colors.orange);
              }
            } catch (e) {
              showSnackbar("خطأ".tr, e.toString(), Colors.red);
            }
          },
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      print("Error opening send stock dialog: $e");
    }
  }

  void openReturnStockDialog() async {
    try {
      final String sellerUuid = seller['id'].toString();

      final products = await sellerStockData.getSellerStock(sellerUuid);
      
      if (products.isEmpty) {
        showSnackbar("تنبيه".tr, "لا توجد منتجات متوفرة عند هذا البائع".tr, Colors.orange);
        return;
      }

      Get.bottomSheet(
        CustemStockTransferDialog(
          title: "استرجاع منتجات".tr,
          products: products,
          isReturn: true,
          onSubmit: (String productUuid, double quantity) async {
            Get.back();
            try {
              bool result = await sellerStockData.returnStockFromSeller(sellerUuid, productUuid, quantity);
              if (result) {
                showSnackbar("نجاح".tr, "تم استرجاع المنتجات من البائع بنجاح".tr, Colors.green);
              } else {
                showSnackbar("خطأ".tr, "حدث خطأ أثناء الاسترجاع".tr, Colors.red);
              }
            } catch(e) {
              showSnackbar("خطأ".tr, e.toString(), Colors.red);
            }
          },
          onTransferAll: () async {
            Get.back();
            try {
              int successCount = 0;
              for (var product in products) {
                String productUuid = product['product_uuid'];
                double quantity = double.tryParse(product['quantity'].toString()) ?? 0.0;
                if (quantity > 0) {
                  bool result = await sellerStockData.returnStockFromSeller(sellerUuid, productUuid, quantity);
                  if (result) successCount++;
                }
              }
              if (successCount > 0) {
                showSnackbar("نجاح".tr, "تم استرجاع كل المنتجات المتاحة بنجاح".tr, Colors.green);
              } else {
                showSnackbar("تنبيه".tr, "لم يتم استرجاع أي منتجات".tr, Colors.orange);
              }
            } catch (e) {
              showSnackbar("خطأ".tr, e.toString(), Colors.red);
            }
          },
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      print("Error opening return stock dialog: $e");
    }
  }

  void showTransfersBottomSheet() async {
    try {
      final String sellerUuid = seller['id'].toString();
      final transfers = await sellerStockData.getSellerTransfers(sellerUuid);
      
      Get.bottomSheet(
        Container(
          height: MediaQuery.of(Get.context!).size.height * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Text(
                "سجل التحويلات".tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.backgroundcolor,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: transfers.isEmpty
                    ? Center(child: Text("لا توجد تحويلات".tr))
                    : ListView.separated(
                        itemCount: transfers.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          var t = transfers[index];
                          double qty = double.tryParse(t['quantity_sent'].toString()) ?? 0.0;
                          bool isReturn = qty < 0;
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (isReturn ? Colors.orange : Colors.green).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isReturn ? Icons.assignment_return : Icons.add_shopping_cart,
                                color: isReturn ? Colors.orange : Colors.green,
                              ),
                            ),
                            title: Text(
                              t['product_name']?.toString() ?? "منتج غير معروف",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(t['created_at']?.toString().substring(0, 16) ?? ""),
                            trailing: Text(
                              "${qty.abs()} ${t['type'] == 1 ? "قطعة".tr : "كلغ".tr}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isReturn ? Colors.orange : Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      showSnackbar("خطأ".tr, e.toString(), Colors.red);
    }
  }
}
