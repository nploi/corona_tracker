import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class DashPatternTimeLineChart extends StatelessWidget {
  final TimeLines timeLines;
  final bool animate;

  const DashPatternTimeLineChart(this.timeLines, {this.animate = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: charts.TimeSeriesChart(
            _createDataFromTimeLines(context, timeLines),
            animate: animate,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Indicator(
              color: Colors.yellow,
              text: S.of(context).confirmedTitle,
            ),
            const SizedBox(
              width: 10,
            ),
            Indicator(
              color: Colors.red,
              text: S.of(context).deathsTitle,
            ),
            const SizedBox(
              width: 10,
            ),
            Indicator(
              color: Colors.green,
              text: S.of(context).recoveredTitle,
            ),
          ],
        ),
      ],
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
      buildSeries(
        id: "Confirmed",
        color: charts.MaterialPalette.yellow.shadeDefault,
        data: confirmedData,
      ),
      buildSeries(
        id: "Deaths",
        color: charts.MaterialPalette.red.shadeDefault,
        data: deathsData,
      ),
      buildSeries(
        id: "Recovered",
        color: charts.MaterialPalette.green.shadeDefault,
        data: recoveredData,
      ),
    ];
  }

  static charts.Series<TimeSeriesSales, DateTime> buildSeries(
      {String id, List<TimeSeriesSales> data, charts.Color color}) {
    return charts.Series<TimeSeriesSales, DateTime>(
      id: id,
      colorFn: (_, __) => color,
      domainFn: (TimeSeriesSales sales, _) => sales.date,
      measureFn: (TimeSeriesSales sales, _) => sales.number,
      data: data,
    );
  }
}

class TimeSeriesSales {
  final DateTime date;
  final int number;

  TimeSeriesSales(this.date, this.number);
}
