import 'dart:async';

import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:corona_tracker/ui/widgets/widgets.dart';
import 'package:corona_tracker/utils/map_styles/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Location location;

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
          var response = BlocProvider.of<HomeBloc>(context).locationsResponse;
          var location = BlocProvider.of<HomeBloc>(context).location;
          List<Widget> charts;
          bool isLoading = state is HomeLoadingState;

          if (state is HomeLoadedLocationsState) {
            charts = [
              CircleChart(
                latest: response.latest,
              ),
            ];
          }

          if (state is HomeLoadedLocationState) {
            charts = [
              CircleChart(
                latest: state.location.latest,
              ),
              TimeLineChart(
                timeLines: state.location.timeLines,
              )
            ];
          }

          return Stack(
            children: <Widget>[
              isLoading
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: LinearProgressIndicator(),
                      ),
                    )
                  : Container(),
              Align(
                alignment: Alignment.center,
                child: SlidingUpPanel(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  minHeight: MediaQuery.of(context).size.height * 0.2,
                  body: GoogleMap(
                    initialCameraPosition: _cameraPosition,
                    markers: markers,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    compassEnabled: true,
                    onMapCreated: _onMapCreated,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                  ),
                  panelBuilder: (controller) {
                    if (isLoading) {
                      return Container();
                    }
                    bool isWorldwide = location == null;
                    return Column(
                      children: <Widget>[
                        Icon(Icons.remove),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            isWorldwide
                                ? S.of(context).worldwide
                                : location.country +
                                    (location.province.isNotEmpty
                                        ? " - ${location.province}"
                                        : ""),
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Divider(),
                        buildExpanded(
                            controller,
                            isWorldwide ? response.latest : location.latest,
                            charts),
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

  Expanded buildExpanded(
      ScrollController controller, Latest latest, List<Widget> charts) {
    return Expanded(
      child: ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildColumn(S.of(context).confirmedTitle, latest.confirmed,
                    Colors.yellow),
                buildColumn(
                    S.of(context).deathsTitle, latest.deaths, Colors.red),
                buildColumn(S.of(context).recoveredTitle, latest.recovered,
                    Colors.green),
              ],
            ),
          ),
          Divider(),
        ]..addAll(charts),
      ),
    );
  }

  Column buildColumn(String title, int number, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title),
        SizedBox(
          height: 5,
        ),
        Text(
          number.toString(),
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(color: color, fontWeight: FontWeight.w300),
        ),
      ],
    );
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
