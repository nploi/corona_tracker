import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/latest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'indicator.dart';

class DonutChart extends StatelessWidget {
  final Latest latest;
  final bool animate;

  const DonutChart(this.latest, {this.animate = true});

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
              text: S.of(context).activeTitle,
            ),
            const SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.red,
              text: S.of(context).deathsTitle,
            ),
            const SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.green,
              text: S.of(context).recoveredTitle,
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
    int activeNumber = latest.confirmed - latest.recovered - latest.deaths;
    final active = S.of(context).activeTitle;
    final deaths = S.of(context).deathsTitle;
    final recovered = S.of(context).recoveredTitle;

    Map<String, dynamic> colors = {
      active: charts.MaterialPalette.yellow.shadeDefault,
      deaths: charts.MaterialPalette.red.shadeDefault,
      recovered: charts.MaterialPalette.green.shadeDefault,
    };

    final data = [
      LinearSales(active, activeNumber),
      LinearSales(deaths, latest.deaths),
      LinearSales(recovered, latest.recovered),
    ];

    var settings = BlocProvider.of<SettingsBloc>(context).settings;

    return [
      charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.label,
        measureFn: (LinearSales sales, _) => sales.number,
        data: data,
        colorFn: (LinearSales sales, _) => colors[sales.label],
        outsideLabelStyleAccessorFn: (LinearSales sales, _) {
          var color = charts.MaterialPalette.black;
          if (settings.isDarkMode()) {
            color = charts.MaterialPalette.white;
          }
          return TextStyleSpec(
            color: color,
          );
        },
        insideLabelStyleAccessorFn: (LinearSales sales, _) {
          var color = charts.MaterialPalette.black;
          if (sales.label != active) {
            color = charts.MaterialPalette.white;
          }
          return TextStyleSpec(
            color: color,
          );
        },
        labelAccessorFn: (LinearSales row, _) =>
            getPercent(row.number, latest.confirmed).toStringAsFixed(0) + ' %',
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
