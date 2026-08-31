import 'package:aleman/core/language/localization_extensions.dart'
    show ContextExt;
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/route_state.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
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
