import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/class/Statusrequest.dart';
import '../../data/datasource/Remote/StatisticsData.dart';
import '../../data/model/FinanceReportModel.dart';

class Supplierreportscontroller extends GetxController {
  String? filter;
  DateTime? from;
  DateTime? to;
  FinanceReport? data;
  Statusrequest statusrequest = Statusrequest.none;
  Statisticsdata statisticsdata = Statisticsdata();

  getdata() async {
    update();
    var result = await statisticsdata.transactionsSales(
        from: from, to: to, filter: filter, type: 1);
    print("===================================$result");
    if (result["status"] == 1) {
      data = FinanceReport.fromJson(result);
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  String datefilter(String date) {
    print("=========================$date");

    if (filter == "today" || filter == "yesterday") {
      String normalized = date.length >= 19 ? date.substring(0, 19) : date;
      return formatSmartDate(normalized);
    } else {
      String normalized = date.length >= 10 ? date.substring(0, 10) : date;
      return formatSmartDate(normalized);
    }
  }

  String formatSmartDate(String input) {
    try {
      // تحقق من شكل الإدخال
      final hasHour =
          RegExp(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}(:\d{2})?').hasMatch(input);
      final hasDay = RegExp(r'\d{4}-\d{2}-\d{2}$').hasMatch(input);
      final hasMonth = RegExp(r'\d{4}-\d{2}$').hasMatch(input);

      const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];

      if (hasHour) {
        String normalized = input.length > 19 ? input.substring(0, 19) : input;
        final date = DateTime.parse(normalized.replaceAll(' ', 'T'));
        final dayName = days[date.weekday - 1];
        final month = months[date.month - 1];
        final hour = DateFormat('HH:mm').format(date);
        return "$dayName, ${date.day} $month - $hour";
      }

      if (hasDay) {
        final date = DateTime.parse(input);
        final dayName = days[date.weekday - 1];
        final month = months[date.month - 1];
        return "$dayName, ${date.day} $month";
      }

      if (hasMonth) {
        final parts = input.split('-');
        final year = parts[0];
        final monthNum = int.parse(parts[1]);
        final month = months[monthNum - 1];
        return "$month $year";
      }

      return input;
    } catch (e) {
      return input;
    }
  }

  @override
  void onInit() {
    final args = Get.arguments;
    filter = args?["filter"];
    from = args?["from"];
    to = args?["to"];
    getdata();
    super.onInit();
  }
}
