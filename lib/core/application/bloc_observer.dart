import 'package:aleman/core/services/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    appLogger.debug('BLOC CREATE: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    appLogger.debug('BLOC EVENT: ${bloc.runtimeType}, Event: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    appLogger.debug('BLOC CHANGE: ${bloc.runtimeType}');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    appLogger.debug(
      'BLOC TRANSITION: ${bloc.runtimeType}\nFrom: ${transition.currentState}\nTo: ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (error.toString().contains(
      'Cannot emit new states after calling close',
    )) {
      appLogger.warning('Ignored emit after close in ${bloc.runtimeType}');
      return;
    }

    appLogger.error('BLOC ERROR: ${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    appLogger.debug('BLOC CLOSE: ${bloc.runtimeType}');
  }
}
