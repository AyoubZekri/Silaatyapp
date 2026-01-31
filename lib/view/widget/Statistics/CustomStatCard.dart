import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceDetailRow extends StatefulWidget {
  final String period;
  final String revenue;
  final String profit;
  final String profit2;
  final String totalSales;
  final String expenses;
  final String itemsSold;
  final String profitRate;
  final bool animated;
  final String labelTotalSales;
  final String labelExpenses;
  final String labelItemsSold;
  final String labelProfit;
  final String labelProfitRate;

  const FinanceDetailRow({
    super.key,
    required this.period,
    required this.revenue,
    required this.profit,
    required this.totalSales,
    required this.expenses,
    required this.itemsSold,
    required this.profitRate,
    required this.labelTotalSales,
    required this.labelExpenses,
    required this.labelItemsSold,
    required this.labelProfit,
    required this.labelProfitRate,
    required this.animated,
    required this.profit2,
  });

  @override
  State<FinanceDetailRow> createState() => _FinanceDetailRowState();
}

class _FinanceDetailRowState extends State<FinanceDetailRow>
    with TickerProviderStateMixin {
  bool open = false;
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.animated == true
            ? InkWell(
                onTap: () {
                  setState(() => open = !open);
                  open ? _controller.forward() : _controller.reverse();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                          open
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          size: 22),
                      if (widget.period.isNotEmpty)
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: Get.locale?.languageCode == 'en' ? 20 : 0,
                                right:
                                    Get.locale?.languageCode == 'ar' ? 20 : 0),
                            child: Text(widget.period,
                                textAlign: Get.locale?.languageCode == 'ar'
                                    ? TextAlign.right
                                    : TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (widget.revenue.isNotEmpty)
                        Expanded(
                          flex: 2,
                          child: Text(wrapEveryNWithDots(widget.revenue, 14,7),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.green)),
                        ),
                      if (widget.profit.isNotEmpty)
                        Expanded(
                          flex: 1,
                          child: Text(wrapEveryNWithDots(widget.profit, 14,7),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.blue)),
                        ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [
                    Icon(
                        open
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 22),
                    if (widget.period.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: Get.locale?.languageCode == 'en' ? 20 : 0,
                              right: Get.locale?.languageCode == 'ar' ? 20 : 0),
                          child: Text(widget.period,
                              textAlign: Get.locale?.languageCode == 'ar'
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (widget.revenue.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: Text(wrapEveryNWithDots(widget.revenue, 14,7),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.green)),
                      ),
                    if (widget.profit.isNotEmpty)
                      Expanded(
                        flex: widget.revenue.isNotEmpty ? 1 : 2,
                        child: Text(wrapEveryNWithDots(widget.profit, 14,7),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.blue)),
                      ),
                  ],
                ),
              ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          child: open
              ? FadeTransition(
                  opacity: _fade,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 5),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        linecontainer(),
                        if (widget.totalSales.isNotEmpty) ...[
                          detailRow(widget.labelTotalSales, widget.totalSales),
                          linecontainer(),
                        ],
                        if (widget.expenses.isNotEmpty) ...[
                          detailRow(widget.labelExpenses, widget.expenses),
                          linecontainer(),
                        ],
                        if (widget.itemsSold.isNotEmpty) ...[
                          detailRow(widget.labelItemsSold, widget.itemsSold),
                          linecontainer(),
                        ],
                        if (widget.profit2.isNotEmpty) ...[
                          detailRow(widget.labelProfit, widget.profit2),
                          linecontainer(),
                        ],
                        if (widget.profitRate.isNotEmpty)
                          detailRow(widget.labelProfitRate, widget.profitRate),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        linecontainer(),
      ],
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
          )),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget linecontainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: Color.fromARGB(255, 216, 215, 215)))),
    );
  }
}

String wrapEveryNWithDots(String text, int maxChars, int wrap) {
  if (text.isEmpty || maxChars <= 0 || wrap <= 0) return '';

  final truncated = text.length > maxChars
      ? text.substring(0, maxChars)
      : text;

  final buffer = StringBuffer();

  for (int i = 0; i < truncated.length; i++) {
    buffer.write(truncated[i]);

    if ((i + 1) % wrap == 0 && i + 1 < truncated.length) {
      buffer.write('\n');
    }
  }

  if (text.length > maxChars) {
    buffer.write('...');
  }

  return buffer.toString();
}

