import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class GlobalError extends StatelessWidget {
  const GlobalError({super.key, required this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 45.w, right: 45.w, top: 100.h),
      child: Column(
        children: [
          Image.asset(ImageAsset.error, width: 350.w),
          SizedBox(height: 25.h),

          Container(
            height: 10.h,
            width: 10.w,

            decoration: BoxDecoration(
              color: ColorManger.primaryLight,
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 20.h,
            width: 20.w,

            decoration: BoxDecoration(
              color: ColorManger.primaryLight,
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
          SizedBox(height: 10.h),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 50.h,
              width: 50.w,

              decoration: BoxDecoration(
                color: ColorManger.primaryLight,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(Iconsax.refresh1, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
