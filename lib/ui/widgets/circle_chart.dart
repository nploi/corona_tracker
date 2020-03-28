import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/latest.dart';
import 'package:flutter/material.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final Latest latest;
  final bool animate;

  const DonutAutoLabelChart(this.latest, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      _createDataFromLatest(context, latest),
      animate: animate,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
      ),
    );
  }

  List<charts.Series<LinearSales, String>> _createDataFromLatest(
      BuildContext context, Latest latest) {
    final confirmed = S.of(context).confirmedTitle;
    final deaths = S.of(context).deathsTitle;
    final recovered = S.of(context).recoveredTitle;

    Map<String, dynamic> colors = {
      confirmed: charts.MaterialPalette.yellow.shadeDefault,
      deaths: charts.MaterialPalette.red.shadeDefault,
      recovered: charts.MaterialPalette.green.shadeDefault,
    };

    final data = [
      LinearSales(confirmed, latest.confirmed),
      LinearSales(deaths, latest.deaths),
      LinearSales(recovered, latest.recovered),
    ];

    return [
      charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.label,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        colorFn: (LinearSales sales, _) => colors[sales.label],
        labelAccessorFn: (LinearSales row, _) => '${row.label}: ${row.sales}',
      )
    ];
  }
}

class LinearSales {
  final String label;
  final int sales;

  LinearSales(this.label, this.sales);
}
