import "dart:async";
import "package:bloc/bloc.dart";
import 'package:corona_tracker/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:corona_tracker/repositories/home_repository.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  LocationsResponse _locationsResponse;
  Location _location;
  final Map<String, Latest> _locationsGroup = {};

  HomeBloc({this.homeRepository = const HomeRepository()});

  @override
  HomeState get initialState => HomeInitState();

  LocationsResponse get locationsResponse => _locationsResponse;
  List<Location> get locationsGroup {
    List<Location> locations = [];
    _locationsGroup.entries.toList().forEach((entry) {
      var location = Location(country: entry.key, latest: entry.value);
      locations.add(location);
    });
    locations.sort((a, b) {
      if (a.latest.confirmed > b.latest.confirmed) {
        return -1;
      }
      if (a.latest.confirmed == b.latest.confirmed) {
        return 0;
      }
      return 1;
    });
    return locations;
  }

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
      groupLocations();
      yield HomeLoadedLocationsState(_locationsResponse);
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  void groupLocations() {
    _locationsGroup.clear();
    if (_locationsResponse.locations == null) {
      return;
    }
    _locationsResponse.locations.forEach((location) {
      if (!_locationsGroup.containsKey(location.country)) {
        _locationsGroup[location.country] = location.latest;
      } else {
        _locationsGroup[location.country].confirmed +=
            location.latest.confirmed;
        _locationsGroup[location.country].deaths += location.latest.deaths;
        _locationsGroup[location.country].recovered +=
            location.latest.recovered;
      }
    });
  }

  Stream<HomeState> _handleHomeLoadLocationEvent(
      HomeLoadLocationEvent event) async* {
    yield HomeLoadingState();
    try {
      // Show Worldwide
      if (event.locationId < 0) {
        _location = null;
      } else if (event.locationId != location?.id) {
        _location = await homeRepository.getLocation(id: event.locationId);
      }
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
