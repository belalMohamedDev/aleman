import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Logo entrance
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // Logo entrance: Spring/Pop from 0.65 to 1.0
    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _controller.forward();
  }

  bool _hasNavigated = false;

  void _navigateToNextScreen() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    final bool isOnBoardingScreenView = SharedPrefHelper.getBool(
      PrefKeys.prefsKeyOnBoardingScreenView,
    );
    final String nextRoute = isOnBoardingScreenView
        ? Routes.homeRoute
        : Routes.onBoardingRoute;

    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = (size.width * 0.58).clamp(210.0, 260.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _logoFade.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Image.asset(
                    ImageAsset.alemanLogo,
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
