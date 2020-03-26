import "dart:async";
import "package:bloc/bloc.dart";
import 'package:corona_tracker/models/settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:corona_tracker/repositories/settings_repository.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({this.settingsRepository = const SettingsRepository()});

  Settings get settings => settingsRepository.getSettings();

  @override
  SettingsState get initialState => SettingsInitState();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsUpdateEvent) {
      yield* _handleSettingsUpdateEvent(event);
      return;
    }
  }

  Stream<SettingsState> _handleSettingsUpdateEvent(
      SettingsUpdateEvent event) async* {
    yield SettingsLoadingState();
    try {
      await settingsRepository.updateSettings(event.settings);
      yield SettingsUpdatedState(event.settings);
    } catch (exception) {
      yield SettingsErrorState(exception.message);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
