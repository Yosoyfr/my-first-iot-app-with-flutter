import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;

class LineChart extends StatelessWidget {
  const LineChart({Key? key, required this.spots, required this.height})
      : super(key: key);

  final List<fl.FlSpot> spots;

  static const Gradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF976FF4),
      Color(0xFFE0D1FC),
    ],
  );

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      child: fl.LineChart(
        fl.LineChartData(
          backgroundColor: const Color(0xFF5B1BED),
          minX: 0,
          maxX: 10,
          minY: -10,
          maxY: 50,
          titlesData: _LineTitles().getTitleData(),
          gridData: fl.FlGridData(
            show: true,
            drawHorizontalLine: false,
            getDrawingVerticalLine: (value) {
              return fl.FlLine(
                color: const Color(0xFF976FF4),
                dashArray: [10, 10],
                strokeWidth: 0.4,
              );
            },
            drawVerticalLine: true,
          ),
          borderData: fl.FlBorderData(show: false),
          lineBarsData: [
            fl.LineChartBarData(
              isCurved: true,
              gradient: gradient,
              barWidth: 4,
              dotData: fl.FlDotData(
                show: false,
              ),
              spots: this.spots,
            )
          ],
        ),
      ),
    );
  }
}

class _LineTitles {
  getTitleData() => fl.FlTitlesData(
        show: true,
        bottomTitles: fl.AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: fl.AxisTitles(
          sideTitles: fl.SideTitles(showTitles: false),
        ),
        topTitles: fl.AxisTitles(
          sideTitles: fl.SideTitles(showTitles: false),
        ),
        leftTitles: fl.AxisTitles(
          sideTitles: leftTitles,
        ),
      );
  fl.SideTitles get bottomTitles => fl.SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 2,
        getTitlesWidget: bottomTitleWidgets,
      );

  fl.SideTitles get leftTitles => fl.SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 2,
        getTitlesWidget: leftTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, fl.TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFFA582F6),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value % 2 == 0) {
      String text = '${value.toInt()}';
      return Padding(
        child: Text(text, style: style),
        padding: const EdgeInsets.only(top: 10.0),
      );
    }
    return const Padding(
      child: Text(''),
      padding: EdgeInsets.only(top: 10.0),
    );
  }

  Widget leftTitleWidgets(double value, fl.TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFFA582F6),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value % 10 == 0) {
      String text = '${value.toInt()}';
      return Padding(
        child: Text(text, style: style),
        padding: const EdgeInsets.only(top: 10.0),
      );
    }
    return const Padding(
      child: Text(''),
      padding: EdgeInsets.only(top: 10.0),
    );
  }
}
