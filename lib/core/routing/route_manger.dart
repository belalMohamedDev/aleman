import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/language/localization_extensions.dart'
    show ContextExt;
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/route_state.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/presentation/screens/sign_in_view.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/screen/home_screen.dart';
import 'package:aleman/feature/onboarding/presentation/screen/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return _buildFadeRoute(
          BlocProvider(
            create: (context) => instance<LoginCubit>(),
            child: const LoginView(),
          ),
        );

      case Routes.homeRoute:
        return _buildFadeRoute(
          BlocProvider(
            create: (context) => instance<HomeCuibtCubit>(),
            child: const HomeScreen(),
          ),
        );

      case Routes.onBoardingRoute:
        return _buildFadeRoute(const OnBoardingScreen());

      // ---------------------- DEFAULT -----------------------
      case Routes.noRoute:
        return _buildFadeRoute(const RouteStatesScreen());

      default:
        return unDefinedRoute();
    }
  }

  // Helper method for Fade Transition Animation
  static Route<dynamic> _buildFadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text(context.translate(AppStrings.noRouteFound))),
        body: Center(child: Text(context.translate(AppStrings.noRouteFound))),
      ),
    );
  }
}
