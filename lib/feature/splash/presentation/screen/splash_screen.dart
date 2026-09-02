import 'dart:async';

import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/home/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../feature/onboarding/presentation/screen/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _exitController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Remove native splash instantly. Since this screen is identical,
      // the user won't notice the swap.
      FlutterNativeSplash.remove();
    });

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 0-800ms: Hold steady (opacity 1.0, scale 1.0)
    // 800-1400ms: Fade out to 0.0 and scale up to 1.5
    // Start small (0.55) to match the padded native Android 12 logo, and grow gradually.
    _logoScale = Tween<double>(
      begin: 0.55,
      end: 1.5,
    ).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
    );

    // Keep logo fully visible so it fades out exactly *with* the page transition
    _logoFade = Tween<double>(begin: 1.0, end: 1.0).animate(_exitController);

    _exitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _exitController.forward();
  }

  void _navigateToNextScreen() {
    final bool isOnBoardingScreenView = SharedPrefHelper.getBool(
      PrefKeys.prefsKeyOnBoardingScreenView,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            isOnBoardingScreenView
                ? const HomeScreen()
                : const OnBoardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = (size.width * 0.65).clamp(220.0, 300.0);

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
            animation: _exitController,
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
