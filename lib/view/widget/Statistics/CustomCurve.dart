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
    final List<FlSpot> curveSpots = [];
    if (period == "day") {
      if (spots.isNotEmpty) {
        double xMapped = hourToX(spots.first.x.toInt());
        if (xMapped != 0) {
          curveSpots.add(FlSpot(xMapped - 1 / 2, 0));
        } else {
          curveSpots.add(FlSpot(xMapped, 0));
        }

        for (var s in spots) {
          double xMapped = hourToX(s.x.toInt());
          curveSpots.add(FlSpot(xMapped, s.y));
        }

        double xMappedfin = hourToX(spots.last.x.toInt());
        if (xMappedfin + 0.5 < _getMaxX()) {
          curveSpots.add(FlSpot(xMappedfin + 0.5, 0));
        } else {
          curveSpots.add(FlSpot(xMappedfin, 0));
        }
      }
    } else {
      if (spots.isNotEmpty) {
        if (spots.first != 0) {
          curveSpots.add(FlSpot(spots.first.x - 1 / 2, 0));
        } else {
          curveSpots.add(FlSpot(spots.first.x, 0));
        }
        curveSpots.addAll(spots);
        if (spots.last.x + 1 / 2 < _getMaxX()) {
          curveSpots.add(FlSpot(spots.last.x + 1 / 2, 0));
        } else {
          curveSpots.add(FlSpot(spots.last.x, 0));
        }
      }
      ;
    }

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
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) =>
                      _buildBottomTitle(value.toInt()),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      _formatY(value),
                      style: const TextStyle(fontSize: 11),
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
              border: const Border(
                bottom: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: curveSpots,
                isCurved: false,
                barWidth: 3,
                preventCurveOverShooting: true,
                color: Colors.blueAccent,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3,
                      color: Colors.blueAccent,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blueAccent.withOpacity(0.2),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}k";
    }
    return value.toStringAsFixed(0);
  }

  // ✅ Bottom X labels by period
  Widget _buildBottomTitle(int value) {
    switch (period) {
      case 'day':
        const times = [
          "8AM",
          "10AM",
          "12PM",
          "2PM",
          "4PM",
          "6PM",
          "8PM",
          "10PM"
        ];
        if (value >= 0 && value < times.length) return Text(times[value]);
        break;

      case 'week':
        const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        if (value >= 0 && value < days.length) return Text(days[value]);
        break;

      case 'month':
        if (value % 5 == 0) return Text("$value d");
        break;

      case 'year':
        const months = ["Jan", "Apr", "Jul", "Oct", "Dec"];
        if (value % 3 == 0 && value ~/ 3 < months.length) {
          return Text(months[value ~/ 3]);
        }
        break;
    }
    return const Text("");
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
    switch (hour) {
      case 8:
        return 0;
      case 10:
        return 1;
      case 12:
        return 2;
      case 14:
        return 3;
      case 16:
        return 4;
      case 18:
        return 5;
      case 20:
        return 6;
      case 22:
        return 7;
      default:
        return 0;
    }
  }
}
