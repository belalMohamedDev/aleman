import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CheckoutStepperHeader extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutStepperHeader({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  IconData _getStepIcon(String title) {
    if (title.contains('استلام') || title.contains('عنوان')) {
      return Iconsax.location;
    } else if (title.contains('شاحنة') || title.contains('سيارة')) {
      return Iconsax.truck_fast;
    } else if (title.contains('دفع')) {
      return Iconsax.wallet_3;
    } else if (title.contains('مراجعة')) {
      return Iconsax.document_text;
    }
    return Iconsax.tick_circle;
  }

  @override
  Widget build(BuildContext context) {
    final stepIndex = (currentStep - 1).clamp(0, steps.length - 1);
    final currentTitle = steps.isNotEmpty ? steps[stepIndex] : '';

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      _getStepIcon(currentTitle),
                      size: 16.sp,
                      color: ColorManger.primaryLight,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    currentTitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'الخطوة $currentStep من ${steps.length}',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: List.generate(steps.length, (index) {
              final isPassed = index < currentStep;
              final isCurrent = index == currentStep - 1;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: isPassed
                        ? ColorManger.primaryLight
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: ColorManger.primaryLight.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
