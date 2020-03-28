import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corona_tracker/models/models.dart';
import 'package:flutter/material.dart';

class DashPatternTimeLineChart extends StatelessWidget {
  final TimeLines timeLines;
  final bool animate;

  const DashPatternTimeLineChart(this.timeLines, {this.animate = true});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createDataFromTimeLines(context, timeLines),
      animate: animate,
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>>
      _createDataFromTimeLines(BuildContext context, TimeLines timeLines) {
    final confirmedData = timeLines.confirmed.timeline.entries
        .map((item) => TimeSeriesSales(
            DateTime.parse(item.key.toString()), item.value.toInt()))
        .toList();

    final deathsData = timeLines.deaths.timeline.entries
        .map((item) => TimeSeriesSales(
            DateTime.parse(item.key.toString()), item.value.toInt()))
        .toList();

    final recoveredData = timeLines.recovered.timeline.entries
        .map((item) => TimeSeriesSales(
            DateTime.parse(item.key.toString()), item.value.toInt()))
        .toList();

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: "Confirmed",
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.date,
        measureFn: (TimeSeriesSales sales, _) => sales.number,
        data: confirmedData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.date,
        measureFn: (TimeSeriesSales sales, _) => sales.number,
        data: deathsData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.date,
        measureFn: (TimeSeriesSales sales, _) => sales.number,
        data: recoveredData,
      )
    ];
  }
}

class TimeSeriesSales {
  final DateTime date;
  final int number;

  TimeSeriesSales(this.date, this.number);
}
