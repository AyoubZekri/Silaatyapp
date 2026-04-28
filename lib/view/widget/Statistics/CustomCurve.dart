import 'package:Silaaty/core/constant/Colorapp.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomCurve extends StatelessWidget {
  final List<FlSpot> spots;
  final String period; // 'day', 'week', 'month', 'year'

  const CustomCurve({
    super.key,
    required this.spots,
    this.period = 'day',
  });

  @override
  Widget build(BuildContext context) {
    // 1. Sort the incoming spots by X to prevent any zigzag overlapping
    List<FlSpot> sortedSpots = List.from(spots);
    sortedSpots.sort((a, b) => a.x.compareTo(b.x));

    final List<FlSpot> curveSpots = [];
    if (period == "day") {
      if (sortedSpots.isNotEmpty) {
        double xMappedFirst = hourToX(sortedSpots.first.x.toInt());
        if (xMappedFirst > 0) {
          curveSpots.add(FlSpot(xMappedFirst - 0.5, 0));
        } else {
          curveSpots.add(FlSpot(xMappedFirst, 0));
        }

        for (var s in sortedSpots) {
          double xMapped = hourToX(s.x.toInt());
          curveSpots.add(FlSpot(xMapped, s.y));
        }

        double xMappedLast = hourToX(sortedSpots.last.x.toInt());
        if (xMappedLast + 0.5 < _getMaxX()) {
          curveSpots.add(FlSpot(xMappedLast + 0.5, 0));
        } else {
          curveSpots.add(FlSpot(xMappedLast, 0));
        }
      }
    } else {
      if (sortedSpots.isNotEmpty) {
        if (sortedSpots.first.x > 0) {
          curveSpots.add(FlSpot(sortedSpots.first.x - 0.5, 0));
        } else {
          curveSpots.add(FlSpot(sortedSpots.first.x, 0));
        }
        curveSpots.addAll(sortedSpots);
        if (sortedSpots.last.x + 0.5 < _getMaxX()) {
          curveSpots.add(FlSpot(sortedSpots.last.x + 0.5, 0));
        } else {
          curveSpots.add(FlSpot(sortedSpots.last.x, 0));
        }
      }
    }

    // 2. Guarantee final spots are sorted correctly for FlChart
    curveSpots.sort((a, b) => a.x.compareTo(b.x));

    return Container(
      padding: const EdgeInsets.only(right: 30),
      color: AppColor.white,
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: _getMaxY(),
            minX: 0,
            maxX: _getMaxX(),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: _getInterval(),
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _buildBottomTitle(value.toInt()),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: _getLeftInterval(),
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    return Text(
                      _formatY(value),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                left: BorderSide(color: Colors.grey.shade400, width: 1),
                top: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      spot.y.toStringAsFixed(2),
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: curveSpots,
                isCurved: true,
                curveSmoothness: 0.35,
                barWidth: 3,
                preventCurveOverShooting: true,
                color: Colors.blueAccent,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.blueAccent,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blueAccent.withOpacity(0.15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _getInterval() {
    switch (period) {
      case 'day': return 1;
      case 'week': return 1;
      case 'month': return 5;
      case 'year': return 3;
      default: return 1;
    }
  }

  double _getLeftInterval() {
    double maxY = _getMaxY();
    if (maxY <= 5) return 1;
    if (maxY <= 50) return 10;
    if (maxY <= 500) return 100;
    if (maxY <= 5000) return 1000;
    if (maxY <= 50000) return 10000;
    if (maxY <= 500000) return 100000;
    return maxY / 5; // aim for ~5 labels
  }

  // ✅ Dynamic maxY depending on data
  double _getMaxY() {
    if (spots.isEmpty) return 1;
    final maxVal = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return 1;
    return maxVal * 1.2;
  }

  // ✅ Format Y axis, 1000 = 1k
  String _formatY(double value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    }
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}k";
    }
    return value.toStringAsFixed(0);
  }

  // ✅ Bottom X labels by period
  Widget _buildBottomTitle(int value) {
    const style = TextStyle(fontSize: 11, color: Colors.grey);
    switch (period) {
      case 'day':
        const times = [
          "8AM", "10AM", "12PM", "2PM", "4PM", "6PM", "8PM", "10PM"
        ];
        if (value >= 0 && value < times.length) return Text(times[value], style: style);
        break;

      case 'week':
        const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        if (value >= 0 && value < days.length) return Text(days[value], style: style);
        break;

      case 'month':
        if (value > 0 && value <= 30) return Text("$value d", style: style);
        break;

      case 'year':
        const months = ["Jan", "Apr", "Jul", "Oct", "Dec"];
        if (value % 3 == 0 && value ~/ 3 < months.length) {
          return Text(months[value ~/ 3], style: style);
        }
        break;
    }
    return const SizedBox.shrink();
  }

  double _getMaxX() {
    switch (period) {
      case 'day':
        return 7;
      case 'week':
        return 6;
      case 'month':
        return 30;
      case 'year':
        return 12;
      default:
        return spots.isNotEmpty ? spots.last.x : 8;
    }
  }

  double hourToX(int hour) {
    if (hour < 8) return 0;
    if (hour > 22) return 7;
    return (hour - 8) / 2.0;
  }
}
