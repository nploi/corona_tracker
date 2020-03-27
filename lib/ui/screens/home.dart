import 'dart:async';
import 'dart:math';

import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/models/locations_response.dart';
import 'package:corona_tracker/ui/common/cluster_marker.dart';
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
    BlocProvider.of<HomeBloc>(context).listen((state) {});
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
              GoogleMap(
                initialCameraPosition: _cameraPosition,
                markers: markers,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                compassEnabled: true,
                onMapCreated: _onMapCreated,
              ),
//              ListView(
//                children: response.locations == null
//                    ? []
//                    : response.locations.map((location) {
//                        return ListTile(
//                          title: Text(location.country),
//                        );
//                      }).toList(),
//              ),
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
