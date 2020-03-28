import 'package:bloc_test/bloc_test.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:corona_tracker/blocs/filtered/filtered_bloc.dart';
import 'package:corona_tracker/repositories/filtered_repository.dart';

class MockFilteredRepository extends Mock implements FilteredRepository {}

void main() {
  FilteredBloc filteredBloc;
  MockFilteredRepository filteredRepository;

  LocationsResponse locationsResponse = LocationsResponse(locations: <Location>[
    Location(
        id: 1,
        latest: Latest(confirmed: 10),
        coordinates: Coordinates(
          latitude: "10.0",
          longitude: "10.0",
        )),
  ]);

  Set<Marker> markers = {};

  setUp(() async {
    filteredRepository = MockFilteredRepository();
    filteredBloc = FilteredBloc(filteredRepository: filteredRepository);
    markers = await FilteredBloc.makeMarkers(locationsResponse.locations);
  });

  tearDown(() {
    filteredBloc?.close();
  });

  group("FilteredBloc", () {
    blocTest<FilteredBloc, FilteredEvent, FilteredState>(
      'emits [FilteredLoadingState(), FilteredLocationsState()]'
      'when successful',
      build: () async {
        return filteredBloc;
      },
      act: (bloc) async {
        bloc.add(FilteredLocationsEvent(locationsResponse,
            filtered: Filtered.confirmed));
      },
      expect: [
        FilteredLoadingState(),
        FilteredLocationsState(markers, Filtered.confirmed),
      ],
    );
  });
}
