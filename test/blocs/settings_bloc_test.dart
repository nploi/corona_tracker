import 'package:bloc_test/bloc_test.dart';
import 'package:corona_tracker/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:corona_tracker/blocs/settings/settings_bloc.dart';
import 'package:corona_tracker/repositories/settings_repository.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  SettingsBloc settingsBloc;
  MockSettingsRepository settingsRepository;

  setUp(() {
    settingsRepository = MockSettingsRepository();
    settingsBloc = SettingsBloc(settingsRepository: settingsRepository);
  });

  tearDown(() {
    settingsBloc?.close();
  });

  group("SettingsBloc", () {
    test('Get settings', () {
      when(settingsRepository.getSettings())
          .thenAnswer((_) => Settings(languageCode: 'vi'));

      var settings = settingsBloc.settings;

      expect('vi', equals(settings.languageCode));
      expect(true, equals(settings.isThemeSystem()));
    });

    Settings settings = Settings();

    blocTest<SettingsBloc, SettingsEvent, SettingsState>(
      'emits [SettingsLoadingState(), SettingsUpdatedState()]'
      'when successful',
      build: () async {
        when(settingsRepository.updateSettings(settings)).thenAnswer(
          (_) async => true, // Response mock
        );
        return settingsBloc;
      },
      act: (bloc) async => bloc.add(SettingsUpdateEvent(settings)),
      expect: [
        SettingsLoadingState(),
        SettingsUpdatedState(settings),
      ],
    );
  });
}
