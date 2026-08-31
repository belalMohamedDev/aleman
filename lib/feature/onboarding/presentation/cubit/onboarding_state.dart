sealed class OnboardingState {
  final int currentIndex;
  final double progress;
  final bool isLastPage;

  const OnboardingState({
    required this.currentIndex,
    required this.progress,
    required this.isLastPage,
  });
}

final class OnboardingInitialState extends OnboardingState {
  const OnboardingInitialState()
      : super(
          currentIndex: 0,
          progress: 0.25,
          isLastPage: false,
        );
}

final class OnboardingPageChangedState extends OnboardingState {
  const OnboardingPageChangedState({
    required super.currentIndex,
    required super.progress,
    required super.isLastPage,
  });
}

final class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState({
    required super.currentIndex,
    required super.progress,
    required super.isLastPage,
  });
}
