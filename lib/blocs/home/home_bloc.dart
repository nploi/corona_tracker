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
  final Set<Marker> markers = Set<Marker>();

  HomeBloc({this.homeRepository = const HomeRepository()});

  @override
  HomeState get initialState => HomeInitState();

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
      var response = await homeRepository.getLocations();
      markers.clear();
      for (int index = 0; index < response.locations.length; index++) {
        var location = response.locations[index];
        var icon = await getClusterMarker(
          location.latest.confirmed,
          Colors.red,
          Colors.white,
          max(150, location.latest.confirmed ~/ 150),
        );
        markers.add(
          Marker(
            markerId: MarkerId(location.id.toString()),
            icon: icon,
            anchor: Offset(0.5, 0.5),
            onTap: () {},
            position: LatLng(
              double.parse(location.coordinates.latitude),
              double.parse(location.coordinates.longitude),
            ),
          ),
        );
      }
      yield HomeLoadedLocationsState(response);
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  Stream<HomeState> _handleHomeLoadLocationEvent(
      HomeLoadLocationEvent event) async* {
    yield HomeLoadingState();
    try {
      var response = await homeRepository.getLocation(id: event.locationId);
      yield HomeLoadedLocationState(response);
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
