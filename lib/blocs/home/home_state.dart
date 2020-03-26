
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

class HomeDidSomeThingState extends HomeState {

  const HomeDidSomeThingState();

  @override
  List<Object> get props => [];

  @override
  String toString() => "HomeDidSomeThingState {}";
}
