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
    return Column(
      children: <Widget>[
        Expanded(
          child: charts.BarChart(
            _createDataFromLocations(context),
            animate: animate,
            behaviors: [
              charts.SlidingViewport(),
              charts.PanAndZoomBehavior(),
            ],
            domainAxis: charts.OrdinalAxisSpec(
              viewport: charts.OrdinalViewport(locationsGroup[0].country, 4),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(S.of(context).topAffectedCountries)
      ],
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
        labelAccessorFn: (OrdinalSales sales, _) => "111111",
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
