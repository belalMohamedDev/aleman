import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutStepperHeader extends StatelessWidget {
  final int currentStep;

  const CheckoutStepperHeader({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          _buildStep(
            context: context,
            number: '1',
            title: 'الاستلام',
            isActive: currentStep >= 1,
            isCurrent: currentStep == 1,
          ),
          _buildDivider(isActive: currentStep >= 2),
          _buildStep(
            context: context,
            number: '2',
            title: 'الدفع',
            isActive: currentStep >= 2,
            isCurrent: currentStep == 2,
          ),
          _buildDivider(isActive: currentStep >= 3),
          _buildStep(
            context: context,
            number: '3',
            title: 'المراجعة',
            isActive: currentStep >= 3,
            isCurrent: currentStep == 3,
          ),
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
          radius: 12.r,
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
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 13.sp,
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
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        color: isActive ? ColorManger.primaryLight : Colors.grey.shade300,
      ),
    );
  }
}
