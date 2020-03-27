import 'package:corona_tracker/models/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeLineChart extends StatelessWidget {
  final TimeLines timeLines;

  const TimeLineChart({Key key, this.timeLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        buildData(),
      ),
    );
  }

  LineChartData buildData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      lineBarsData: buildLinesBarData(),
//      lineTouchData: LineTouchData(
//        touchTooltipData: LineTouchTooltipData(
//          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//        ),
//        touchCallback: (LineTouchResponse touchResponse) {
//          print(touchResponse);
//        },
//        handleBuiltInTouches: true,
//      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: const Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 100:
                return '100';
              case 1000:
                return '1k';
              case 10000:
                return '10k';
              case 50000:
                return '50k';
              case 100000:
                return '100k';
              case 1000000:
                return '1000k';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      maxX: timeLines.confirmed.timeline.keys.length.toDouble(),
      maxY:
          getMaxValue(timeLines.confirmed.timeline.values.toList()).toDouble(),
      minX: 0,
      minY: 0,
    );
  }

  int getMaxValue(List<dynamic> values) {
    var max = 0;
    for (int index = 0; index < values.length; index++) {
      if (values[index] > max) {
        max = values[index];
      }
    }
    return max;
  }

  List<LineChartBarData> buildLinesBarData() {
    LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: buildSpots(timeLines.confirmed),
      isCurved: true,
      colors: [Colors.yellow],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: buildSpots(timeLines.deaths),
      isCurved: true,
      colors: [Colors.red],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        Color(0x00aa4cfc),
      ]),
    );
    LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: buildSpots(timeLines.recovered),
      isCurved: true,
      colors: const [Colors.green],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      belowBarData: const BarAreaData(
        show: false,
      ),
    );

    List<LineChartBarData> lines = [];
    if (timeLines.confirmed.timeline != null &&
        timeLines.confirmed.timeline.isNotEmpty) {
      lines.add(lineChartBarData1);
    }
    if (timeLines.deaths.timeline != null &&
        timeLines.deaths.timeline.isNotEmpty) {
      lines.add(lineChartBarData2);
    }
    if (timeLines.recovered.timeline != null &&
        timeLines.recovered.timeline.isNotEmpty) {
      lines.add(lineChartBarData3);
    }
    return lines;
  }

  List<FlSpot> buildSpots(TimeLine timeLine) {
    int x = -1;
    return timeLine.timeline.values.map((value) {
      x++;
      return FlSpot(x.toDouble(), value.toDouble());
    }).toList();
  }
}
