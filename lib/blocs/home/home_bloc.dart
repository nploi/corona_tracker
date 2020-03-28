import "dart:async";
import 'dart:math';
import "package:bloc/bloc.dart";
import 'package:corona_tracker/models/models.dart';
import 'package:corona_tracker/ui/common/cluster_marker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:corona_tracker/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final Set<Marker> markers = <Marker>{};
  LocationsResponse _locationsResponse;
  Location _location;

  HomeBloc({this.homeRepository = const HomeRepository()});

  @override
  HomeState get initialState => HomeInitState();

  LocationsResponse get locationsResponse => _locationsResponse;
  Location get location => _location;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeLoadLocationsEvent) {
      yield* _handleHomeLoadLocationsEvent(event);
      return;
    }
    if (event is HomeLoadLocationEvent) {
      yield* _handleHomeLoadLocationEvent(event);
      return;
    }
  }

  Stream<HomeState> _handleHomeLoadLocationsEvent(
      HomeLoadLocationsEvent event) async* {
    yield HomeLoadingState();
    try {
      _locationsResponse = await homeRepository.getLocations();
      markers.clear();
      await makeMarkers();
      yield HomeLoadedLocationsState(_locationsResponse);
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  Future makeMarkers() async {
    for (int index = 0;
        _locationsResponse.locations != null &&
            index < _locationsResponse.locations.length;
        index++) {
      var location = _locationsResponse.locations[index];

      Color color = getColor(location.latest.confirmed);

      var icon = await getClusterMarker(
        location.latest.confirmed,
        color,
        Colors.white,
        max(150, location.latest.confirmed ~/ 150),
      );

      markers.add(
        Marker(
          markerId: MarkerId(location.id.toString()),
          icon: icon,
          anchor: const Offset(0.5, 0.5),
          onTap: () {
            add(HomeLoadLocationEvent(location.id));
          },
          position: LatLng(
            double.parse(location.coordinates.latitude),
            double.parse(location.coordinates.longitude),
          ),
        ),
      );
    }
  }

  Color getColor(int number) {
    var color = const Color(0xffFFA07A);

    if (number > 10 && number <= 100) {
      color = const Color(0xffF08080);
    } else if (number > 100 && number <= 1000) {
      color = const Color(0xffCD5C5C);
    } else if (number > 1000 && number <= 10000) {
      color = const Color(0xffDC143C);
    } else if (number > 10000 && number <= 50000) {
      color = const Color(0xffFF0000);
    } else if (number > 50000) {
      color = const Color(0xff8B0000);
    }
    return color;
  }

  Stream<HomeState> _handleHomeLoadLocationEvent(
      HomeLoadLocationEvent event) async* {
    yield HomeLoadingState();
    try {
      _location = await homeRepository.getLocation(id: event.locationId);
      yield HomeLoadedLocationState(_location);
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
