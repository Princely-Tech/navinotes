import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:navinotes/packages.dart';

class MyStoreLineChart extends StatelessWidget {
  const MyStoreLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 3000,
          maxX: 4,
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                maxIncluded: true,
                minIncluded: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return _text('\$0');
                    case 3000:
                      return _text('\$3,000');
                  }
                  return const Text('');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return _text('Apr 24');
                    case 1:
                      return _text('Apr 26');
                    case 2:
                      return _text('Apr 28');
                    case 3:
                      return _text('Apr 30');
                    case 4:
                      return _text('May 02');
                  }
                  return _text('');
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.symmetric(
              horizontal: BorderSide(color: AppTheme.lightGray),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: AppTheme.vividRose,
              barWidth: 3,
              dotData: FlDotData(show: false), // Hide spots
              spots: [
                const FlSpot(0, 1000),
                const FlSpot(1, 1500),
                const FlSpot(2, 1200),
                const FlSpot(3, 1800),
                const FlSpot(4, 2000),
              ],
            ),

            // Dashed red line
            LineChartBarData(
              isCurved: true,
              color: AppTheme.softSkyBlue,
              barWidth: 3,
              dotData: FlDotData(show: false), // Hide spots
              dashArray: [5, 5], // Makes it dashed!
              
              spots: [
                const FlSpot(0, 800),
                const FlSpot(1, 1000),
                const FlSpot(2, 1500),
                const FlSpot(3, 1400),
                const FlSpot(4, 1700),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String data) {
    return Text(
      data,
      style: TextStyle(color: AppTheme.steelMist, fontSize: 12.0),
    );
  }
}
