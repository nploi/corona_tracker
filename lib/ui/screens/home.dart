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
            ];
          }
          if (location != null) {
            print(location.toJson());
          }

          return Stack(
            children: <Widget>[
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
              Align(
                alignment: Alignment.center,
                child: SlidingUpPanel(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  minHeight: MediaQuery.of(context).size.height * 0.2,
                  body: GoogleMap(
                    initialCameraPosition: _cameraPosition,
                    markers: markers,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    compassEnabled: true,
                    onMapCreated: _onMapCreated,
                  ),
                  panelBuilder: (controller) {
                    if (state is HomeLoadingState) {
                      return CircularProgressIndicator();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildColumn(S.of(context).confirmedTitle, latest.confirmed),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(S.of(context).deathsTitle),
                  Text(latest.deaths.toString())
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(S.of(context).recoveredTitle),
                  Text(latest.recovered.toString())
                ],
              ),
            ],
          ),
          Divider(),
        ]..addAll(charts),
      ),
    );
  }

  Column buildColumn(String title, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[Text(title), Text(number.toString())],
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
