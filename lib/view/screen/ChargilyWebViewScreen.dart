import 'package:Silaaty/core/constant/routes.dart';
import 'package:Silaaty/core/functions/Snacpar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constant/Colorapp.dart';

class ChargilyWebViewScreen extends StatefulWidget {
  final String url;

  const ChargilyWebViewScreen({
    super.key,
    required this.url,
  });

  @override
  State<ChargilyWebViewScreen> createState() => _ChargilyWebViewScreenState();
}

class _ChargilyWebViewScreenState extends State<ChargilyWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          final url = request.url;

          print("URL => $url");

          if (url.contains("/payments/success/")) {
            Get.offAllNamed(Approutes.HomeScreen);

            showSnackbar("success".tr, "تم الدفع بنجاح".tr, Colors.green);

            return NavigationDecision.prevent;
          }

          if (url.contains("/payments/failure/")) {
            Get.back();
            showSnackbar("error".tr, "فشل الدفع".tr, Colors.red);

            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الدفع'.tr,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColor.backgroundcolor, fontSize: 24),
        ),
        backgroundColor: AppColor.primarycolor,
        iconTheme: const IconThemeData(color: AppColor.backgroundcolor),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
