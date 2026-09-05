import 'package:aleman/core/application/applogicCubit/app_logic_cubit.dart';
import 'package:aleman/core/application/bloc_observer.dart';
import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/dio_factory/dio_factory.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repo_imp.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_cubit.dart';
import 'package:aleman/feature/home/data/repository/home_repo.dart';
import 'package:aleman/feature/home/data/repository/home_repo_imp.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  await Future.wait([_initAppModule(), _initLogin(), _initHome()]);
}

Future<void> _initAppModule() async {
  // app module ,its a module where we put all generic dependencies

  await ScreenUtil.ensureScreenSize();

  Bloc.observer = AppBlocObserver();

  await Hive.initFlutter();

  final navigatorKey = GlobalKey<NavigatorState>();
  instance.registerLazySingleton<ImagePicker>(ImagePicker.new);
  // Dio & ApiService

  final Dio dio = DioFactory.getDio();

  instance
    ..registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio))
    ..registerSingleton<GlobalKey<NavigatorState>>(navigatorKey)
    ..registerFactory<AppLogicCubit>(() => AppLogicCubit());
}

Future<void> _initLogin() async {
  instance.registerFactory<AuthenticationRepository>(
    () => AuthenticationRepositoryImplement(instance<AppServiceClient>()),
  );
  instance.registerFactory<LoginCubit>(
    () => LoginCubit(instance<AuthenticationRepository>()),
  );
}

Future<void> _initHome() async {
  instance.registerFactory<HomeRepository>(
    () => HomeRepositoryImplement(instance<AppServiceClient>()),
  );
  instance.registerFactory<HomeCuibtCubit>(
    () => HomeCuibtCubit(instance<HomeRepository>()),
  );
}
