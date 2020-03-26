import 'dart:async';

import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/utils/map_styles/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime;
  final Completer<GoogleMapController> _controller = Completer();

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
          var circles = Set<Marker>();

          if (state is HomeLoadedLocationsState) {
            state.response.locations.map((location) {
              circles.add(
                Marker(
                  markerId: MarkerId(location.id.toString()),
                  position: LatLng(
                    double.parse(location.coordinates.latitude),
                    double.parse(location.coordinates.longitude),
                  ),
                ),
              );
            });
          }

          return Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: _cameraPosition,
                markers: circles,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                compassEnabled: true,
                onMapCreated: _onMapCreated,
              ),
              state is HomeLoadingState
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(),
                    )
                  : Container()
            ],
          );
        },
      ),
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
