import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/bottomNavBar/logic/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class EmptyWishlistView extends StatelessWidget {
  const EmptyWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: ColorManger.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Iconsax.heart5,
                  size: 48.sp,
                  color: ColorManger.primaryLight.withValues(alpha: 0.6),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'قائمة المفضلة فارغة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'لم تقم بإضافة أي منتجات إلى قائمة رغباتك بعد. تصفح الأصناف وأضف ما يعجبك بضغطة واحدة!',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BottomNavCubit>().changeTab(0);
              },
              icon: Icon(Iconsax.shop, size: 18.sp, color: Colors.white),
              label: Text(
                'استكشف المنتجات',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primary,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
