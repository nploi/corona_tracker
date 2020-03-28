part of 'filtered_bloc.dart';

@immutable
abstract class FilteredState extends Equatable {
  const FilteredState();

  @override
  List<Object> get props => [];
}

class FilteredInitState extends FilteredState {}

class FilteredLoadingState extends FilteredState {}

class FilteredErrorState extends FilteredState {
  final String message;

  const FilteredErrorState(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => "FilteredErrorState {message: $message}";
}

class FilteredLocationsState extends FilteredState {
  final Set<Marker> markers;
  final Filtered filtered;
  const FilteredLocationsState(this.markers, this.filtered);

  @override
  List<Object> get props => [markers, filtered];

  @override
  String toString() => "FilteredLocationsState {markers: $markers,"
      " filtered: $filtered}";
}
