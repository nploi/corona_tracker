import "package:bloc/bloc.dart";
import 'package:logger/logger.dart';

class AppBlocDelegate extends BlocDelegate {
  final bool debug;
  Logger logger = Logger();

  AppBlocDelegate({this.debug = true});
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    if (debug) {
      logger.d(event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (debug) {
      logger.d(transition);
    }
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    if (debug) {
      logger.e(error);
    }
  }
}
