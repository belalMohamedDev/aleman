import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/style/fonts/font_manger.dart';

class OnboardingBottomControls extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;
  final bool isLastPage;
  final VoidCallback onNext;
  final ValueChanged<int>? onDotTap;

  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
    required this.isLastPage,
    required this.onNext,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            final bool isActive = currentIndex == index;
            return GestureDetector(
              onTap: onDotTap != null ? () => onDotTap!(index) : null,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 20.0 : 7.0,
                height: 7.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: isActive
                      ? ColorManger.onboardingDotActive
                      : ColorManger.onboardingDotInactive,
                ),
              ),
            );
          }),
        ),

        SizedBox(height: 50.h),

        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: ColorManger.onboardingButtonBg.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.onboardingButtonBg,
              foregroundColor: ColorManger.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                isLastPage ? 'ابدأ التسوق' : 'التالي',
                key: ValueKey<bool>(isLastPage),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeightManger.bold,
                      color: ColorManger.white,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
