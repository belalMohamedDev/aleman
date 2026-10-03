import 'dart:math' as math;

import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/color/color_manger.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widget/curved_card_clipper.dart';
import '../widget/onboarding_bottom_controls.dart';
import '../widget/onboarding_page_content.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  void _saveOnboardingAndNavigateToHome(BuildContext context) async {
    await SharedPrefHelper.setData(PrefKeys.prefsKeyOnBoardingScreenView, true);

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final size = MediaQuery.of(context).size;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final double cardHeight = (size.height * 0.43).clamp(320.0, 410.0);
    final double bottomInset = math.max(bottomSafeArea, 16.0) + 10.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorManger.onboardingBackground,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManger.onboardingBackgroundTop,
                ColorManger.onboardingBackgroundBottom,
              ],
            ),
          ),
          child: BlocListener<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingCompletedState) {
                _saveOnboardingAndNavigateToHome(context);
              }
            },
            child: Stack(
              children: [
              // 1. Bottom Curved White Card Background
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: cardHeight,
                child: CustomPaint(
                  painter: const CurvedCardShadowPainter(curveHeight: 28.0),
                  child: ClipPath(
                    clipper: const CurvedCardClipper(curveHeight: 28.0),
                    child: Container(color: ColorManger.white),
                  ),
                ),
              ),

              // 2. Swipeable Page Content (Image in green zone + Text in white card)
              Positioned.fill(
                child: PageView.builder(
                  controller: cubit.pageController,
                  itemCount: cubit.items.length,
                  onPageChanged: cubit.onPageChanged,
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(
                      item: cubit.items[index],
                      cardHeight: cardHeight,
                    );
                  },
                ),
              ),

              // 3. Fixed Bottom Controls (Dots Indicator + Action Button)
              Positioned(
                left: 24,
                right: 24,
                bottom: bottomInset,
                child: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return OnboardingBottomControls(
                      currentIndex: state.currentIndex,
                      totalSteps: cubit.items.length,
                      isLastPage: state.isLastPage,
                      onNext: cubit.onNext,
                      onDotTap: cubit.goToPage,
                    );
                  },
                ),
              ),

              // SafeArea(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 18.0,
              //       vertical: 8.0,
              //     ),
              //     child: Align(
              //       alignment: AlignmentDirectional.topEnd,
              //       child: BlocBuilder<OnboardingCubit, OnboardingState>(
              //         buildWhen: (prev, current) =>
              //             prev.isLastPage != current.isLastPage,
              //         builder: (context, state) {
              //           return AnimatedOpacity(
              //             opacity: state.isLastPage ? 0.0 : 1.0,
              //             duration: const Duration(milliseconds: 250),
              //             child: IgnorePointer(
              //               ignoring: state.isLastPage,
              //               child: TextButton(
              //                 onPressed: cubit.finishOnboarding,
              //                 style: TextButton.styleFrom(
              //                   foregroundColor: Colors.white.withValues(
              //                     alpha: 0.9,
              //                   ),
              //                   backgroundColor: Colors.white.withValues(
              //                     alpha: 0.12,
              //                   ),
              //                   padding: const EdgeInsets.symmetric(
              //                     horizontal: 14,
              //                     vertical: 6,
              //                   ),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(18),
              //                   ),
              //                 ),
              //                 child: Text(
              //                   'تخطي',
              //                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
              //                     fontSize: 13.5.sp,
              //                     fontWeight: FontWeightManger.semiBold,
              //                     color: ColorManger.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
