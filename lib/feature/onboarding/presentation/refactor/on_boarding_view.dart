import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widget/circular_progress_button.dart';
import '../widget/onboarding_page_content.dart';
import '../../../../core/style/color/color_manger.dart';

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
    final responsive = ResponsiveUtils(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF122912),
        body: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompletedState) {
              _saveOnboardingAndNavigateToHome(context);
            }
          },
          child: Padding(
            padding: responsive.setPadding(top: 8, bottom: 4),
            child: Column(
              children: [
                // PageView Content
                Expanded(
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: cubit.items.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingPageContent(item: cubit.items[index]);
                    },
                  ),
                ),

                // Bottom Controls: Action Text + Circular Progress Indicator Button
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressButton(
                          progress: state.progress,
                          totalSteps: cubit.items.length,
                          isLastPage: state.isLastPage,
                          onTap: cubit.onNext,
                        ),
                        const SizedBox(
                          height: 32,
                        ), // Spacing between button and dots
                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(cubit.items.length, (index) {
                            bool isActive = state.currentIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? ColorManger.gold
                                    : ColorManger.gold.withValues(alpha: 0.15),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16), // Bottom spacing
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
