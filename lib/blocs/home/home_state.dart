part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => "HomeErrorState {message: $message}";
}

class HomeLoadedLocationsState extends HomeState {
  final LocationsResponse response;

  const HomeLoadedLocationsState(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() =>
      "HomeLoadedLocationsState {response: ${response.toJson()}";
}

class HomeLoadedLocationState extends HomeState {
  final Location location;

  const HomeLoadedLocationState(this.location);

  @override
  List<Object> get props => [location];

  @override
  String toString() =>
      "HomeLoadedLocationState {response: ${location?.toJson()}";
}
