import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalError extends StatelessWidget {
  const GlobalError({super.key, required this.onTap});

  final Function()? onTap;

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
              Image.asset(ImageAsset.error, width: 280.w, height: 280.w),

              SizedBox(height: 8.h),
              Text(
                'حدث خطأ ما',
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                'لم نتمكن من تنفيذ طلبك في الوقت الحالي. \nحدث خطأ غير متوقع أثناء معالجة العملية، \nيرجى المحاولة مرة أخرى بعد قليل.',
                style: getRegularStyle(
                  fontSize: 16.sp,
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

    // Padding(
    //   padding: EdgeInsets.only(left: 45.w, right: 45.w, top: 100.h),
    //   child: Column(
    //     children: [
    //       Image.asset(ImageAsset.error, width: 280.w, height: 280.w),
    //       SizedBox(height: 25.h),

    //       Container(
    //         height: 10.h,
    //         width: 10.w,

    //         decoration: BoxDecoration(
    //           color: ColorManger.primaryLight,
    //           borderRadius: BorderRadius.circular(40.r),
    //         ),
    //       ),
    //       SizedBox(height: 10.h),
    //       Container(
    //         height: 20.h,
    //         width: 20.w,

    //         decoration: BoxDecoration(
    //           color: ColorManger.primaryLight,
    //           borderRadius: BorderRadius.circular(40.r),
    //         ),
    //       ),
    //       SizedBox(height: 10.h),
    //       InkWell(
    //         onTap: onTap,
    //         child: Container(
    //           height: 50.h,
    //           width: 50.w,

    //           decoration: BoxDecoration(
    //             color: ColorManger.primaryLight,
    //             borderRadius: BorderRadius.circular(40.r),
    //           ),
    //           child: Icon(Iconsax.refresh1, color: Colors.white),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
