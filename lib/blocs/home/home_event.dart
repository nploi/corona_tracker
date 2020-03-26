
part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class HomeDoSomeThingEvent extends HomeEvent {

  const HomeDoSomeThingEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => "HomeDoSomeThingEvent {}";
}
