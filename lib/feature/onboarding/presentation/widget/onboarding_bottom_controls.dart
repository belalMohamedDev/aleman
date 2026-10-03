import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                      ? const Color(0xFF122912)
                      : const Color(0xFFE2E8F0),
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
                color: const Color(0xFF122912).withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF122912).withValues(alpha: 0.85),
              foregroundColor: Colors.white,
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
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
