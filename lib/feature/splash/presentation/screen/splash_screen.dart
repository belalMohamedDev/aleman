import 'dart:async';

import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/feature/home/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../feature/onboarding/presentation/screen/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _dotsController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // 1. Entrance animation (0.0 to 1.0 in 850ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    // Scale from 0.7 to 1.0 (smooth and stable, no bounce)
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    // Fade in from 0.0 to 1.0
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    // 2. Subtle dots pulse controller
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Start entrance animation
    _entranceController.forward();

    // Smooth transition to OnBoarding after ~2.1 seconds
    _navigationTimer = Timer(
      const Duration(milliseconds: 2100),

      _navigateToOnBoarding,
    );
  }

  void _navigateToOnBoarding() {
    final bool isOnBoardingScreenView = SharedPrefHelper.getBool(
      PrefKeys.prefsKeyOnBoardingScreenView,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) =>
            isOnBoardingScreenView
            ? const HomeScreen()
            : const OnBoardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = (size.width * 0.65).clamp(220.0, 300.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 18, 34, 18),
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Center: Animated Logo in original natural colors with Scale (0.7 -> 1.0) + Fade In
            Center(
              child: AnimatedBuilder(
                animation: _entranceController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset(
                        'assets/image/logo.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom: 3 Calm Subtle Indicator Dots (• • •)
            Positioned(
              bottom: 48,
              child: AnimatedBuilder(
                animation: _entranceController,
                builder: (context, child) {
                  return Opacity(opacity: _logoFade.value, child: child);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _dotsController,
                      builder: (context, child) {
                        final offset = index * 0.25;
                        final t = (_dotsController.value + offset) % 1.0;
                        final alpha = 0.35 + 0.55 * (1 - (2 * (t - 0.5)).abs());
                        final scale = 0.85 + 0.25 * (1 - (2 * (t - 0.5)).abs());

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 6.5 * scale,
                          height: 6.5 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF8AEF48)
                                .withValues(alpha: alpha),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
