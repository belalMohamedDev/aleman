import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/language/localization_extensions.dart'
    show ContextExt;
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/route_state.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/feature/Authentication/logic/loginBloc/login_bloc.dart';
import 'package:aleman/feature/Authentication/presentation/screens/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => instance<LoginBloc>(),
            child: const LoginView(),
          ),
        );

      // ---------------------- DEFAULT -----------------------
      case Routes.noRoute:
        return MaterialPageRoute(builder: (_) => const RouteStatesScreen());

      default:
        return unDefinedRoute();
    }
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
