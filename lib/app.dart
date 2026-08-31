import 'package:aleman/core/application/applogicCubit/app_logic_cubit.dart';
import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/language/app_localizations_setup.dart';
import 'package:aleman/core/style/theme/theme_manger.dart';
import 'package:aleman/feature/splash/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<AppLogicCubit>()..getSavedLanguage(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return BlocBuilder<AppLogicCubit, AppLogicState>(
            builder: (context, state) {
              return MaterialApp(
                locale: Locale(context.read<AppLogicCubit>().currentLangCode),
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                navigatorKey: instance<GlobalKey<NavigatorState>>(),

                title: 'الإيمان للأعلاف',
                debugShowCheckedModeBanner: false,
                home: const SplashScreen(),
                theme: getApplicationTheme(context),
              );
            },
          );
        },
      ),
    );

    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'الإيمان للأعلاف',
    //   theme:App

    //   //  ThemeData(
    //   //   fontFamily: 'Cairo',
    //   //   useMaterial3: true,
    //   //   appBarTheme: const AppBarTheme(
    //   //     systemOverlayStyle: SystemUiOverlayStyle(
    //   //       statusBarColor: Colors.transparent,
    //   //       statusBarIconBrightness: Brightness.light,
    //   //       statusBarBrightness: Brightness.dark,
    //   //     ),
    //   //   ),
    //   // ),
    //   home: const SplashScreen(),
    // );
  }
}
