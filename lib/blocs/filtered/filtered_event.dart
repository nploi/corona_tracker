part of 'filtered_bloc.dart';

@immutable
abstract class FilteredEvent extends Equatable {
  const FilteredEvent();
  @override
  List<Object> get props => [];
}

class FilteredLocationsEvent extends FilteredEvent {
  final LocationsResponse response;
  final Filtered filtered;
  const FilteredLocationsEvent(this.response,
      {this.filtered = Filtered.confirmed});

  @override
  List<Object> get props => [response, filtered];

  @override
  String toString() => "FilteredLocationsEvent {response: ${response.toJson()},"
      " filtered: $filtered}";
}
