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
      yield HomeLoadedLocationsState(_locationsResponse);
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  Stream<HomeState> _handleHomeLoadLocationEvent(
      HomeLoadLocationEvent event) async* {
    yield HomeLoadingState();
    try {
      // Show Worldwide
      if (event.locationId < 0) {
        _location = null;
      } else {
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
