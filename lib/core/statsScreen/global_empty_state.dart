import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Unified Empty State Widget following the Aleman Brand Design Identity
class GlobalEmptyState extends StatelessWidget {
  final String? imageAsset;
  final IconData? icon;
  final String title;
  final String description;
  final String? buttonText;
  final IconData? buttonIcon;
  final VoidCallback? onButtonPressed;
  final double? topPadding;

  const GlobalEmptyState({
    super.key,
    this.imageAsset,
    this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.buttonIcon,
    this.onButtonPressed,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.w,
            vertical: topPadding ?? 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imageAsset != null)
                Image.asset(
                  imageAsset!,
                  width: 300.w,
                  height: 220.w,
                  fit: BoxFit.contain,
                )
              else if (icon != null)
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    color: ColorManger.primaryLight.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 46.sp,
                      color: ColorManger.primaryLight.withValues(alpha: 0.85),
                    ),
                  ),
                ),

              SizedBox(height: 8.h),

              Text(
                title,
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 320.w),
                child: Text(
                  description,
                  style: getRegularStyle(
                    fontSize: 13.5.sp,
                    color: ColorManger.grey,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: 24.h),
              //   ElevatedButton.icon(
              //     onPressed: onButtonPressed,
              //     icon: Icon(
              //       buttonIcon ?? Iconsax.shop,
              //       size: 18.sp,
              //       color: Colors.white,
              //     ),
              //     label: Text(
              //       buttonText!,
              //       style: getBoldStyle(
              //         fontSize: 14.sp,
              //         color: ColorManger.white,
              //       ),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: ColorManger.primaryLight.withValues(
              //         alpha: 0.9,
              //       ),
              //       foregroundColor: ColorManger.white,
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8.r),
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
