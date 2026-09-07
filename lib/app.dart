import 'package:aleman/core/application/applogicCubit/app_logic_cubit.dart';
import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/language/app_localizations_setup.dart';
import 'package:aleman/core/style/theme/theme_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';

import 'package:aleman/feature/splash/presentation/screen/splash_screen.dart';
import 'package:aleman/core/routing/route_manger.dart';
import 'package:aleman/core/application/network_cubit/network_cubit.dart';
import 'package:aleman/core/application/network_cubit/network_state.dart';
import 'package:aleman/core/widgets/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => instance<AppLogicCubit>()..getSavedLanguage(),
        ),
        BlocProvider(create: (context) => instance<NetworkCubit>()),
        BlocProvider(create: (context) => instance<CartCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          final langCode = context.select(
            (AppLogicCubit cubit) => cubit.currentLangCode,
          );
          return MaterialApp(
            locale: Locale(langCode),
            supportedLocales: AppLocalizationsSetup.supportedLocales,
            localizationsDelegates:
                AppLocalizationsSetup.localizationsDelegates,
            localeResolutionCallback:
                AppLocalizationsSetup.localeResolutionCallback,
            navigatorKey: instance<GlobalKey<NavigatorState>>(),
            title: 'الإيمان للأعلاف',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            home: const SplashScreen(),
            theme: getApplicationTheme(context),
            builder: (context, child) {
              return BlocBuilder<NetworkCubit, NetworkState>(
                builder: (context, networkState) {
                  return Stack(
                    children: [
                      ?child,
                      if (networkState.maybeWhen(
                        disconnected: () => true,
                        orElse: () => false,
                      ))
                        const Positioned.fill(child: NoInternetScreen()),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
