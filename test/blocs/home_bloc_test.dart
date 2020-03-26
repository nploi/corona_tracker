import 'package:bloc_test/bloc_test.dart';
import 'package:corona_tracker/models/locations_response.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/repositories/home_repository.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  HomeBloc homeBloc;
  MockHomeRepository homeRepository;

  setUp(() {
    homeRepository = MockHomeRepository();
    homeBloc = HomeBloc(homeRepository: homeRepository);
  });

  tearDown(() {
    homeBloc?.close();
  });

  group("HomeBloc", () {
    {
      LocationsResponse locationsResponse = LocationsResponse();
      blocTest<HomeBloc, HomeEvent, HomeState>(
        'emits [HomeLoadingState(), HomeLoadedLocationsState()]'
        'when successful',
        build: () async {
          when(homeRepository.getLocations()).thenAnswer(
            (_) async => locationsResponse, // Response mock
          );
          return homeBloc;
        },
        act: (bloc) async => homeBloc.add(const HomeLoadLocationsEvent()),
        expect: [
          HomeLoadingState(),
          HomeLoadedLocationsState(locationsResponse),
        ],
      );
    }

    {
      Location location = Location(id: 0);
      blocTest<HomeBloc, HomeEvent, HomeState>(
        'emits [HomeLoadingState(), HomeLoadedLocationState()]'
        'when successful',
        build: () async {
          when(homeRepository.getLocation(id: location.id)).thenAnswer(
            (_) async => location, // Response mock
          );
          return homeBloc;
        },
        act: (bloc) async => homeBloc.add(HomeLoadLocationEvent(location.id)),
        expect: [
          HomeLoadingState(),
          HomeLoadedLocationState(location),
        ],
      );
    }
  });
}
