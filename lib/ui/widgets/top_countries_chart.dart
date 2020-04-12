import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopCountriesChart extends StatelessWidget {
  final bool animate;
  final List<Location> locationsGroup;

  TopCountriesChart(
      {@required this.locationsGroup, Key key, this.animate = true})
      : assert(locationsGroup != null && locationsGroup.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createDataFromLocations(context),
      animate: animate,
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
        charts.ChartTitle(
          S.of(context).topAffectedCountries,
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
      ],
      primaryMeasureAxis: const charts.NumericAxisSpec(

          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            desiredTickCount: 4,
          ),
          renderSpec: charts.GridlineRendererSpec(
              lineStyle: charts.LineStyleSpec(
            dashPattern: [4, 4],
          ))),
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport(locationsGroup[0].country, 4),
      ),
    );
  }

  List<charts.Series<OrdinalSales, String>> _createDataFromLocations(
      BuildContext context) {
    final data = locationsGroup
        .map((location) =>
            OrdinalSales(location.country, location.latest.confirmed))
        .toList();
    var settings = BlocProvider.of<SettingsBloc>(context).settings;
    return [
      charts.Series<OrdinalSales, String>(
        id: 'top_countries_chart',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.country,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          var color = charts.MaterialPalette.black;
          if (settings.isDarkMode()) {
            color = charts.MaterialPalette.white;
          }
          return TextStyleSpec(
            color: color,
          );
        },
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String country;
  final int sales;

  OrdinalSales(this.country, this.sales);
}
