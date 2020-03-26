part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class HomeLoadLocationsEvent extends HomeEvent {
  const HomeLoadLocationsEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => "HomeLoadLocationsEvent {}";
}

class HomeLoadLocationEvent extends HomeEvent {
  final int locationId;

  const HomeLoadLocationEvent(this.locationId);

  @override
  List<Object> get props => [locationId];

  @override
  String toString() => "HomeLoadLocationsEvent {locationId: $locationId}";
}
