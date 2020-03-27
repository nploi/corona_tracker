import 'dart:async';
import 'dart:math';

import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/models/locations_response.dart';
import 'package:corona_tracker/ui/common/cluster_marker.dart';
import 'package:corona_tracker/utils/map_styles/map_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime;
  final Completer<GoogleMapController> _controller = Completer();
  ScrollController _scrollController;

  final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(10.7622028, 106.6786009),
    zoom: 1,
  );

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomeLoadLocationsEvent());
    BlocProvider.of<SettingsBloc>(context).listen((state) {
      if (state is SettingsUpdatedState) {
        if (!_controller.isCompleted) {
          var style = getMapStyle(ThemeMode.values[state.settings.themeMode]);
          _controller.future
              .then((controller) => controller.setMapStyle(style));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          var markers = BlocProvider.of<HomeBloc>(context).markers;
          var response = LocationsResponse();

          if (state is HomeLoadedLocationsState) {
            response = state.response;
          }

          return Stack(
            children: <Widget>[
//              GoogleMap(
//                initialCameraPosition: _cameraPosition,
//                markers: markers,
//                myLocationEnabled: true,
//                mapToolbarEnabled: false,
//                compassEnabled: true,
//                onMapCreated: _onMapCreated,
//              ),
              state is HomeLoadingState
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: LinearProgressIndicator(),
                      ),
                    )
                  : Container(),
              state is HomeLoadingState
                  ? Container()
                  : Align(
                      alignment: Alignment.center,
                      child: SlidingUpPanel(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        maxHeight: MediaQuery.of(context).size.height * 0.9,
                        minHeight:  MediaQuery.of(context).size.height * 0.2,
                        body: GoogleMap(
                          initialCameraPosition: _cameraPosition,
                          markers: markers,
                          myLocationEnabled: true,
                          mapToolbarEnabled: false,
                          compassEnabled: true,
                          onMapCreated: _onMapCreated,
                        ),
                        panelBuilder: (controller) {
                          return Column(
                            children: <Widget>[
                              Icon(Icons.remove),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Worldwide",
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: ListView(
                                  controller: _scrollController,
                                  padding: EdgeInsets.zero,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text("Confirmed"),
                                            Text(response.latest.confirmed
                                                .toString())
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text("Recovered"),
                                            Text(response.latest.recovered
                                                .toString())
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text("Deaths"),
                                            Text(response.latest.deaths
                                                .toString())
                                          ],
                                        ),
                                      ],
                                    ),
                                    buildChart(response),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget buildChart(LocationsResponse response) {
    int sum = response.latest.recovered +
        response.latest.confirmed +
        response.latest.deaths;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PieChart(
        PieChartData(
          sections: <PieChartSectionData>[
            PieChartSectionData(
              value: getPercent(response.latest.confirmed, sum),
              color: Colors.yellow,
              title:
                  "${getPercent(response.latest.confirmed, sum).toStringAsFixed(0)} %",
            ),
            PieChartSectionData(
              value: getPercent(response.latest.recovered, sum),
              color: Colors.green,
              title:
                  "${getPercent(response.latest.recovered, sum).toStringAsFixed(0)} %",
            ),
            PieChartSectionData(
              value: getPercent(response.latest.deaths, sum),
              color: Colors.red,
              title:
                  "${getPercent(response.latest.deaths, sum).toStringAsFixed(0)} %",
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 20,
          borderData: FlBorderData(
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
        ),
      ),
    );
  }

  double getPercent(int number, int sum) {
    print((number / sum) * 100);
    return (number / sum) * 100;
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
      var style = getMapStyle(ThemeMode
          .values[BlocProvider.of<SettingsBloc>(context).settings.themeMode]);
      _controller.future.then((controller) => controller.setMapStyle(style));
    }
  }
}
