import 'package:aleman/feature/home/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widget/circular_progress_button.dart';
import '../widget/onboarding_page_content.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Homescreen(),
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
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

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
              _navigateToHome(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 100),
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
                    return CircularProgressButton(
                      progress: state.progress,
                      totalSteps: cubit.items.length,
                      isLastPage: state.isLastPage,
                      onTap: cubit.onNext,
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
