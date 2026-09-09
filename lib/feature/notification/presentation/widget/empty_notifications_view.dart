import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class EmptyNotificationsView extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyNotificationsView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: ColorManger.primary.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.notification_1,
                  size: 48.sp,
                  color: ColorManger.buttonColor,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'لا توجد إشعارات حالياً',
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'ستظهر هنا جميع التنبيهات الخاصة بحالة طلباتك والعروض الحصرية فور وصولها.',
                style: getRegularStyle(
                  fontSize: 13.sp,
                  color: ColorManger.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.buttonColor,
                  foregroundColor: ColorManger.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                icon: const Icon(Icons.refresh),
                label: Text(
                  'تحديث',
                  style: getBoldStyle(fontSize: 14.sp, color: ColorManger.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
