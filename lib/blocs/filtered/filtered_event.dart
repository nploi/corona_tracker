part of 'filtered_bloc.dart';

@immutable
abstract class FilteredEvent extends Equatable {
  const FilteredEvent();
  @override
  List<Object> get props => [];
}

class FilteredLocationsEvent extends FilteredEvent {
  final List<Location> locations;
  final Filtered filtered;
  const FilteredLocationsEvent(this.locations,
      {this.filtered = Filtered.confirmed});

  @override
  List<Object> get props => [locations, filtered];

  @override
  String toString() => "FilteredLocationsEvent {locations: $locations,"
      " filtered: $filtered}";
}
