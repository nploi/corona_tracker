import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/latest.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final Latest latest;
  final bool animate;

  const DonutAutoLabelChart(this.latest, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: charts.PieChart(
            _createDataFromLatest(context, latest),
            animate: animate,
            defaultRenderer: charts.ArcRendererConfig(
              arcWidth: 60,
              arcRendererDecorators: [
                charts.ArcLabelDecorator(),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Indicator(
              color: Colors.yellow,
              text: S.of(context).confirmedTitle,
              isSquare: true,
            ),
            const SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.red,
              text: S.of(context).deathsTitle,
              isSquare: true,
            ),
            const SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.green,
              text: S.of(context).recoveredTitle,
              isSquare: true,
            ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ],
    );
  }

  List<charts.Series<LinearSales, String>> _createDataFromLatest(
      BuildContext context, Latest latest) {
    int sum = latest.recovered + latest.confirmed + latest.deaths;

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
        measureFn: (LinearSales sales, _) => sales.number,
        data: data,
        colorFn: (LinearSales sales, _) => colors[sales.label],
        labelAccessorFn: (LinearSales row, _) =>
            getPercent(row.number, sum).toStringAsFixed(0) + ' %',
      )
    ];
  }

  double getPercent(int number, int sum) {
    return (number / sum) * 100;
  }
}

class LinearSales {
  final String label;
  final int number;

  LinearSales(this.label, this.number);
}
