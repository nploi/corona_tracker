import "dart:async";
import "package:bloc/bloc.dart";
import 'package:corona_tracker/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:corona_tracker/repositories/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

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
