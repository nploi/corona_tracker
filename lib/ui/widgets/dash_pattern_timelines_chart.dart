import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corona_tracker/generated/l10n.dart';
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
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 1,
          cellPadding: const EdgeInsets.all(4.0),
        )
      ],
      primaryMeasureAxis: const charts.NumericAxisSpec(
          showAxisLine: true,
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
          ),
          renderSpec: charts.GridlineRendererSpec(
              lineStyle: charts.LineStyleSpec(
            dashPattern: [4, 4],
          ))),
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
        id: S.of(context).confirmedTitle,
        color: charts.MaterialPalette.yellow.shadeDefault,
        data: confirmedData,
      ),
      buildSeries(
        id: S.of(context).deathsTitle,
        color: charts.MaterialPalette.red.shadeDefault,
        data: deathsData,
      ),
      buildSeries(
        id: S.of(context).recoveredTitle,
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
