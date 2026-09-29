import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ChangePasswordHeader extends StatelessWidget {
  const ChangePasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: ColorManger.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorManger.primary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Icon(
            Iconsax.lock,
            size: 34.sp,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'تغيير كلمة المرور',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'أدخل كلمة المرور الحالية ثم كلمة المرور الجديدة',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
