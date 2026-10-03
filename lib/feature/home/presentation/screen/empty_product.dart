import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyCategoryProduct extends StatelessWidget {
  const EmptyCategoryProduct({super.key});

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
              Image.asset(ImageAsset.noProduct, width: 280.w, height: 280.w),

              Text(
                'لا توجد منتجات فى هذا القسم حاليا',
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'سيتم إضافة منتجات جديدة لهذا القسم قريباً',
                style: getRegularStyle(
                  fontSize: 13.sp,
                  color: ColorManger.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 150.h),
            ],
          ),
        ),
      ),
    );
  }
}
