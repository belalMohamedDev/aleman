import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyNotificationsView extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyNotificationsView({super.key, required this.onRefresh});

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
              Image.asset(ImageAsset.notification, width: 280.w, height: 280.w),

              SizedBox(height: 2.h),
              Text(
                'لا توجد إشعارات حالياً',
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                'ستظهر هنا جميع التنبيهات الخاصة بحالة طلباتك\n والعروض الحصرية فور وصولها.',
                style: getRegularStyle(
                  fontSize: 13.sp,
                  color: ColorManger.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 150.h),
              // ElevatedButton.icon(
              //   onPressed: onRefresh,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: ColorManger.buttonColor,
              //     foregroundColor: ColorManger.white,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12.r),
              //     ),
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 24.w,
              //       vertical: 12.h,
              //     ),
              //   ),
              //   icon: const Icon(Icons.refresh),
              //   label: Text(
              //     style: getBoldStyle(
              //       fontSize: 14.sp,
              //       color: ColorManger.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
