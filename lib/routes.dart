import 'package:Silaaty/view/screen/Auth/Forget%20Password/ForgenPassWord.dart';
import 'package:Silaaty/view/screen/Auth/Forget%20Password/ResetPassword.dart';
import 'package:Silaaty/view/screen/Auth/Forget%20Password/VeriFiyCode.dart';
import 'package:Silaaty/view/screen/Auth/Signup.dart';
import 'package:Silaaty/view/screen/Auth/VeriFyCodeSignUp.dart';
import 'package:Silaaty/view/screen/Auth/checkEmail.dart';
import 'package:Silaaty/view/screen/Convict/AddConvict.dart';
import 'package:Silaaty/view/screen/Convict/invoices/AddProductinvoice.dart';
import 'package:Silaaty/view/screen/Convict/invoices/Editproductinvoice.dart';
import 'package:Silaaty/view/screen/Convict/invoices/Shwoinvoice.dart';
import 'package:Silaaty/view/screen/Convict/invoices/invoicesconvict.dart';
import 'package:Silaaty/view/screen/Convict/EditConvict.dart';
import 'package:Silaaty/view/screen/Dealer/Adddealer.dart';
import 'package:Silaaty/view/screen/Dealer/Editdealer.dart';
import 'package:Silaaty/view/screen/Dealer/invoicesdealer/AddProductinvoicedealer.dart';
import 'package:Silaaty/view/screen/Dealer/invoicesdealer/EditProductinvoicedealer.dart';
import 'package:Silaaty/view/screen/Dealer/invoicesdealer/Shwoinvoicedealer.dart';
import 'package:Silaaty/view/screen/Dealer/invoicesdealer/invoicesd.dart';
import 'package:Silaaty/view/screen/Homescreen.dart';
import 'package:Silaaty/view/screen/Prodact/Additem.dart';
import 'package:Silaaty/view/screen/Prodact/edititem.dart';
import 'package:Silaaty/view/screen/Prodact/informationItem.dart';
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
import 'package:Silaaty/view/screen/Setteng/profaile.dart';
import 'package:Silaaty/view/screen/Zakate.dart';
import 'package:Silaaty/view/screen/categoris/Addcat.dart';
import 'package:Silaaty/view/screen/categoris/Editcat.dart';
import 'package:Silaaty/view/screen/categoris/ShwoCat.dart';
import 'package:get/get.dart';
import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/view/screen/Auth/login.dart';

import 'view/screen/Profaile/Settingsprivacy.dart';
import 'view/screen/RessetPassword/ForgenPassWordSetting.dart';
import 'view/screen/RessetPassword/ResetPasswordSetting.dart';
import 'view/screen/RessetPassword/Resset.dart';
import 'view/screen/SplashScreen.dart';

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
  GetPage(name: Approutes.settengPrivacy, page: () => const SettengPrivacy()),

  GetPage(name: Approutes.HomeScreen, page: () => const Homescreen()),
  GetPage(name: Approutes.informationitem, page: () => const Informationitem()),
  GetPage(name: Approutes.edititemcontroller, page: () => const Edititem()),
  GetPage(name: Approutes.Additem, page: () => const Additem()),

  GetPage(name: Approutes.profaile, page: () => const Profaile()),
  GetPage(name: Approutes.notification, page: () => const Notification()),
  GetPage(name: Approutes.Informationapp, page: () => const Informationapp()),

  GetPage(
      name: Approutes.shwonotification, page: () => const Shwonotification()),
  GetPage(name: Approutes.Privacypolicy, page: () => const Privacypolicy()),
  GetPage(name: Approutes.Zakat, page: () => const Zakat()),
  GetPage(name: Approutes.Setteng, page: () => const Setteng()),
  GetPage(name: Approutes.Dealer, page: () => const Dealer()),
  GetPage(name: Approutes.Convicts, page: () => const Convicts()),
  GetPage(name: Approutes.AddDealer, page: () => const AddDealer()),
  GetPage(name: Approutes.EditDealer, page: () => const EditDealer()),

  GetPage(name: Approutes.AddConvict, page: () => const AddConvict()),
  GetPage(name: Approutes.EditConvict, page: () => const EditConvict()),
  GetPage(name: Approutes.invoice, page: () => const Invoices()),
  GetPage(name: Approutes.shwoinvoice, page: () => const Shwoinvoice()),
  GetPage(
      name: Approutes.Addproductinvoice, page: () => const Addproductinvoice()),
  GetPage(
      name: Approutes.Editproductinvoice,
      page: () => const Editproductinvoice()),

  GetPage(name: Approutes.invoicesdealer, page: () => const Invoicesd()),
  GetPage(
      name: Approutes.shwoinvoicedealer, page: () => const Shwoinvoicedealer()),
  GetPage(
      name: Approutes.addproductinvoicedealer,
      page: () => const Addproductinvoicedealer()),
  GetPage(
      name: Approutes.Editproductinvoicedealer,
      page: () => const Editproductinvoicedealer()),
  GetPage(name: Approutes.shwocat, page: () => const Shwocat()),
  GetPage(name: Approutes.addcat, page: () => const Addcat()),
  GetPage(name: Approutes.editCat, page: () => const Editcat()),

  GetPage(name: Approutes.necessary, page: () => const Necessary()),

  GetPage(name: Approutes.report, page: () => const Report()),
  GetPage(name: Approutes.shwoReport, page: () => const Shworeport()),
];
