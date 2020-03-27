import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class CircleChart extends StatelessWidget {
  final Latest latest;

  const CircleChart({Key key, this.latest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildChart(context);
  }

  Widget buildChart(BuildContext context) {
    int sum = latest.recovered + latest.confirmed + latest.deaths;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                sections: <PieChartSectionData>[
                  PieChartSectionData(
                    value: getPercent(latest.confirmed, sum),
                    color: Colors.yellow,
                    titleStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.black),
                    title:
                        "${getPercent(latest.confirmed, sum).toStringAsFixed(0)} %",
                  ),
                  PieChartSectionData(
                    value: getPercent(latest.deaths, sum),
                    color: Colors.red,
                    titleStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white),
                    title:
                        "${getPercent(latest.deaths, sum).toStringAsFixed(0)} %",
                  ),
                  PieChartSectionData(
                    value: getPercent(latest.recovered, sum),
                    color: Colors.green,
                    titleStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white),
                    title:
                        "${getPercent(latest.recovered, sum).toStringAsFixed(0)} %",
                  ),
                ],
                sectionsSpace: 0,
                centerSpaceRadius: 20,
                borderData: FlBorderData(
                  show: false,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Colors.yellow,
                text: S.of(context).confirmedTitle,
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.red,
                text: S.of(context).deathsTitle,
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.green,
                text: S.of(context).recoveredTitle,
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getPercent(int number, int sum) {
    return (number / sum) * 100;
  }
}
