import 'package:Silaaty/view/screen/Auth/Forget%20Password/ForgenPassWord.dart';
import 'package:Silaaty/view/screen/Auth/Forget%20Password/ResetPassword.dart';
import 'package:Silaaty/view/screen/Auth/Forget%20Password/VeriFiyCode.dart';
import 'package:Silaaty/view/screen/Auth/Signup.dart';
import 'package:Silaaty/view/screen/Auth/VeriFyCodeSignUp.dart';
import 'package:Silaaty/view/screen/Auth/checkEmail.dart';
import 'package:Silaaty/view/screen/Statistice/CustomerSales.dart';
import 'package:Silaaty/view/screen/Statistice/LowStock.dart';
import 'package:Silaaty/view/screen/Statistice/StockValue.dart';
import 'package:Silaaty/view/screen/Statistice/SupplierReports.dart';
import 'package:Silaaty/view/screen/invoices/Shwoinvoice.dart';
import 'package:Silaaty/view/screen/invoices/invoicesconvict.dart';
import 'package:Silaaty/view/screen/Dashboard/Client.dart';
import 'package:Silaaty/view/screen/Dashboard/InvoicesallClient.dart';
import 'package:Silaaty/view/screen/Dashboard/Sale.dart';
import 'package:Silaaty/view/screen/NavigationBar.dart';
import 'package:Silaaty/view/screen/Prodact/AddProductSale.dart';
import 'package:Silaaty/view/screen/Prodact/Additem.dart';
import 'package:Silaaty/view/screen/Prodact/Payment.dart';
import 'package:Silaaty/view/screen/Prodact/edititem.dart';
import 'package:Silaaty/view/screen/Prodact/informationItem.dart';
import 'package:Silaaty/view/screen/Prodact/items.dart';
import 'package:Silaaty/view/screen/Profaile/Convicts.dart';
import 'package:Silaaty/view/screen/Profaile/Dealer.dart';
import 'package:Silaaty/view/screen/Profaile/necessary.dart';
import 'package:Silaaty/view/screen/Report/Report.dart';
import 'package:Silaaty/view/screen/Report/ShwoReport.dart';
import 'package:Silaaty/view/screen/RessetPassword/VeriFiyCodeSetting.dart';
import 'package:Silaaty/view/screen/Setteng.dart';
import 'package:Silaaty/view/screen/Setteng/InformationAPP.dart';
import 'package:Silaaty/view/screen/Setteng/Notification/Notification.dart';
import 'package:Silaaty/view/screen/Setteng/Notification/ShwoNotification.dart';
import 'package:Silaaty/view/screen/Setteng/Privacypolicy.dart';
import 'package:Silaaty/view/screen/Setteng/Profail.dart';
import 'package:Silaaty/view/screen/Setteng/profaile.dart';
import 'package:Silaaty/view/screen/Zakate.dart';
import 'package:Silaaty/view/screen/categoris/Addcat.dart';
import 'package:Silaaty/view/screen/categoris/Editcat.dart';
import 'package:Silaaty/view/screen/categoris/ShwoCat.dart';
import 'package:Silaaty/view/screen/profailedata.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/view/screen/Auth/login.dart';

import 'view/screen/Convict/AddConvict.dart';
import 'view/screen/Convict/EditConvict.dart';
import 'view/screen/Dealer/Adddealer.dart';
import 'view/screen/Dealer/Editdealer.dart';
import 'view/screen/RessetPassword/ForgenPassWordSetting.dart';
import 'view/screen/RessetPassword/ResetPasswordSetting.dart';
import 'view/screen/RessetPassword/Resset.dart';
import 'view/screen/SplashScreen.dart';
import 'view/screen/Statistice/PublicFinance.dart';
import 'view/screen/Statistice/StatisticeReports.dart';
import 'view/screen/Statistice/StockBalance.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: "/", page: () => const SplashScreen()),
  //  name: "/",page: () => const Checkout()),
  GetPage(name: Approutes.Login, page: () => const Login()),
  GetPage(name: Approutes.splashScreen, page: () => const SplashScreen()),

  GetPage(name: Approutes.SignUp, page: () => const Signup()),
  GetPage(
      name: Approutes.VerifiycodeSignUp, page: () => const VerifiycodeSignUp()),
  GetPage(name: Approutes.VerFiyCode, page: () => const Verifiycode()),
  GetPage(name: Approutes.forgenPassword, page: () => const ForgenPassword()),
  GetPage(name: Approutes.resePassword, page: () => const ResetPassword()),
  GetPage(name: Approutes.checkemail, page: () => const CheckEmail()),

  GetPage(name: Approutes.reset, page: () => const Resset()),
  GetPage(
      name: Approutes.verifiycodesetting,
      page: () => const Verifiycodesetting()),
  GetPage(
      name: Approutes.forgenpasswordsetting,
      page: () => const Forgenpasswordsetting()),
  GetPage(
      name: Approutes.resetpasswordsetting,
      page: () => const Resetpasswordsetting()),

  GetPage(name: Approutes.HomeScreen, page: () => const Homescreen()),
  GetPage(name: Approutes.informationitem, page: () => const Informationitem()),
  GetPage(name: Approutes.edititemcontroller, page: () => const Edititem()),
  GetPage(name: Approutes.Additem, page: () => const Additem()),
  GetPage(name: Approutes.item, page: () => const Items()),

  GetPage(name: Approutes.profaile, page: () => const Profaile()),
  GetPage(name: Approutes.notification, page: () => const Notification()),
  GetPage(name: Approutes.Informationapp, page: () => const Informationapp()),

  GetPage(
      name: Approutes.shwonotification, page: () => const Shwonotification()),
  GetPage(name: Approutes.Privacypolicy, page: () => const Privacypolicy()),
  // GetPage(name: Approutes.Zakat, page: () => const Zakat()),
  GetPage(name: Approutes.Setteng, page: () => const Setteng()),
  GetPage(name: Approutes.Dealer, page: () => const Dealer()),
  GetPage(name: Approutes.Convicts, page: () => const Convicts()),
  GetPage(name: Approutes.AddDealer, page: () => const AddDealer()),
  GetPage(name: Approutes.EditDealer, page: () => const EditDealer()),

  GetPage(name: Approutes.AddConvict, page: () => const AddConvict()),
  GetPage(name: Approutes.EditConvict, page: () => const EditConvict()),
  GetPage(name: Approutes.invoice, page: () => const Invoices()),
  GetPage(name: Approutes.shwoinvoice, page: () => const Shwoinvoice()),
  GetPage(name: Approutes.shwocat, page: () => const Shwocat()),
  GetPage(name: Approutes.addcat, page: () => const Addcat()),
  GetPage(name: Approutes.editCat, page: () => const Editcat()),

  GetPage(name: Approutes.necessary, page: () => const Necessary()),

  GetPage(name: Approutes.report, page: () => const Report()),
  GetPage(name: Approutes.shwoReport, page: () => const Shworeport()),

  GetPage(name: Approutes.invoicesall, page: () => const Invoicesall()),
  GetPage(name: Approutes.newSale, page: () => NewSale()),
  GetPage(name: Approutes.profail, page: () => Profail()),
  GetPage(name: Approutes.statisticereports, page: () => Statisticereports()),
  GetPage(name: Approutes.profailedata, page: () => Profailedata()),
  GetPage(name: Approutes.addProductSale, page: () => AddProductSale()),
  GetPage(name: Approutes.payment, page: () => Payment()),
  GetPage(name: Approutes.client, page: () => Client()),
  GetPage(name: Approutes.publicfinance, page: () => Publicfinance()),

  GetPage(name: Approutes.customersales, page: () => Customersales()),
  GetPage(name: Approutes.lowstock, page: () => Lowstock()),
  GetPage(name: Approutes.stockbalance, page: () => Stockbalance()),
  GetPage(name: Approutes.stockvalue, page: () => Stockvalue()),
  GetPage(name: Approutes.supplierreports, page: () => Supplierreports()),

];
