import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PasswordRequirementCard extends StatelessWidget {
  const PasswordRequirementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorManger.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorManger.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.info_circle,
            color: ColorManger.primary,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'متطلبات كلمة المرور',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '• يجب ألا تقل كلمة المرور عن 6 أحرف أو أرقام.\n• تأكد من تطابق كلمة المرور الجديدة مع خانة التأكيد.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
