import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/onboarding_item_model.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitialState());

  final PageController pageController = PageController();
  final List<OnboardingItemModel> items = OnboardingItemModel.items;

  void onPageChanged(int index) {
    emit(
      OnboardingPageChangedState(
        currentIndex: index,
        progress: (index + 1) / items.length,
        isLastPage: index == items.length - 1,
      ),
    );
  }

  void onNext() {
    if (state.currentIndex < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() {
    emit(
      OnboardingCompletedState(
        currentIndex: state.currentIndex,
        progress: 1.0,
        isLastPage: true,
      ),
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
