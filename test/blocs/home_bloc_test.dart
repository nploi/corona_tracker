
import 'package:bloc_test/bloc_test.dart';
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
    blocTest<HomeBloc, HomeEvent, HomeState>(
      'emits [HomeLoadingState(), HomeDidSomeThingState()]'
      'when successful',
      build: () async {
        when(homeRepository.getLocations()).thenAnswer(
          (_) async => null, // Response mock
        );
        return homeBloc;
      },
      act: (bloc) async =>
          homeBloc.add(const HomeDoSomeThingEvent()),
      expect: [
         HomeLoadingState(),
         const HomeDidSomeThingState(),
      ],
    );
  });
}
