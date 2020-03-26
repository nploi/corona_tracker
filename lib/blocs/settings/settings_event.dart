part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class SettingsUpdateEvent extends SettingsEvent {
  final Settings settings;

  const SettingsUpdateEvent(this.settings);

  @override
  List<Object> get props => [settings];

  @override
  String toString() =>
      "SettingsDoSomeThingEvent {settings: ${settings.toJson()}";
}
