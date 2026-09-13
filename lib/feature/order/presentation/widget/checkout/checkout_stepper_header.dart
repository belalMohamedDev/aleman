import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutStepperHeader extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutStepperHeader({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            if (i > 0) _buildDivider(isActive: currentStep >= i + 1),
            _buildStep(
              context: context,
              number: '${i + 1}',
              title: steps[i],
              isActive: currentStep >= i + 1,
              isCurrent: currentStep == i + 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required String number,
    required String title,
    required bool isActive,
    required bool isCurrent,
  }) {
    final activeColor = ColorManger.primaryLight;
    final inactiveColor = Colors.grey.shade400;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 11.r,
          backgroundColor: isActive ? activeColor : Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? activeColor : inactiveColor,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : inactiveColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          title,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 11.5.sp,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        color: isActive ? ColorManger.primaryLight : Colors.grey.shade300,
      ),
    );
  }
}
