
import "dart:async";
import "package:bloc/bloc.dart";
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
    if (event is HomeDoSomeThingEvent) {
      yield* _handleHomeDoSomeThingEvent(event);
      return;
    }
  }

  Stream<HomeState> _handleHomeDoSomeThingEvent(
      HomeDoSomeThingEvent event) async* {
    yield HomeLoadingState();
    try {
      yield const HomeDidSomeThingState();
    } catch (exception) {
      yield HomeErrorState(exception.message);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
