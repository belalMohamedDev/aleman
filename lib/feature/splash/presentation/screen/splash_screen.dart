import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/notification_service.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:aleman/feature/splash/presentation/widget/splash_brand_lockup.dart';
import 'package:aleman/feature/splash/presentation/widget/splash_pattern_overlay.dart';
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

  // Staggered animations mapping to the slowed reference video timeline:
  late final Animation<double> _patternFade;
  late final Animation<double> _circleScale;
  late final Animation<double> _circleOpacity;
  late final Animation<double> _emblemDraw;
  late final Animation<double> _shiftProgress;
  late final Animation<double> _arabicTextProgress;
  late final Animation<double> _englishTextProgress;

  Future<void>? _backgroundInitFuture;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Immediately dismiss native splash as soon as the Flutter view mounts
    FlutterNativeSplash.remove();

    // Run background services quietly during the 3.2s custom animation
    _backgroundInitFuture = _initBackgroundServices();

    // Motion timeline matching the 0.25x analyzed reference video
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // 1. Subtle background pattern fades in concurrently (0.0 -> 0.25)
    _patternFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // 2. White circle appears at the EXACT CENTER (0.0 -> 0.26)
    _circleScale = Tween<double>(begin: 0.50, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.26, curve: Curves.easeOutBack),
      ),
    );

    _circleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.16, curve: Curves.easeOut),
      ),
    );

    // 3. Logo draws/reveals inside the white circle while centered (0.16 -> 0.46)
    _emblemDraw = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.16, 0.46, curve: Curves.easeInOutCubic),
      ),
    );

    // 4. Circular emblem glides to the RIGHT (0.48 -> 0.74)
    _shiftProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.48, 0.74, curve: Curves.easeInOutCubic),
      ),
    );

    // 5. Arabic text drops down from TOP to left of emblem (0.54 -> 0.78)
    _arabicTextProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // 6. English text rises up from BOTTOM to left of emblem (0.58 -> 0.82)
    _englishTextProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.58, 0.82, curve: Curves.easeOutCubic),
      ),
    );

    // 7. Complete composition holds steady (0.82 -> 1.0), then transitions
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _controller.forward();
  }

  Future<void> _initBackgroundServices() async {
    try {
      await UserRoleHelper.getUserRole();
    } catch (e) {
      appLogger.warning('UserRoleHelper background initialization error: $e');
    }

    try {
      await instance<NotificationService>().initialize();
    } catch (e) {
      appLogger.warning('NotificationService background initialization error: $e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    // Ensure background services finished before leaving splash
    if (_backgroundInitFuture != null) {
      await _backgroundInitFuture;
    }

    if (!mounted) return;

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background pattern overlay
            AnimatedBuilder(
              animation: _patternFade,
              builder: (context, _) {
                return SplashPatternOverlay(opacity: _patternFade.value);
              },
            ),

            // Animated brand lockup
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return SplashBrandLockup(
                  circleScale: _circleScale.value,
                  circleOpacity: _circleOpacity.value,
                  emblemDrawProgress: _emblemDraw.value,
                  shiftProgress: _shiftProgress.value,
                  arabicTextProgress: _arabicTextProgress.value,
                  englishTextProgress: _englishTextProgress.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
