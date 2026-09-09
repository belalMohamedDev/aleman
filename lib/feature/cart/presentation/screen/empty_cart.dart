import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

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
              Image.asset(ImageAsset.emptyCart, width: 280.w, height: 280.w),

              SizedBox(height: 8.h),
              Text(
                'سلة المشتريات فارغة',
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                'أضف منتجاتك المفضلة إلى السلة لتظهر هنا، ثم راجع اختياراتك وأكمل طلبك بكل سهولة.',
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
              //     'تحديث',
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
