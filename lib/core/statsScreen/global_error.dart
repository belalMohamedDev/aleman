import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalError extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onRetry;
  final String? imageAsset;
  final String? title;
  final String? message;
  final String? retryText;
  final bool isCompact;
  final double? topPadding;

  const GlobalError({
    super.key,
    this.onTap,
    this.onRetry,
    this.imageAsset,
    this.title,
    this.message,
    this.retryText,
    this.isCompact = false,
    this.topPadding,
  });

  VoidCallback? get _effectiveAction => onRetry ?? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.w,
            vertical: topPadding ?? (isCompact ? 16.h : 24.h),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imageAsset ?? ImageAsset.error,
                width: isCompact ? 180.w : 280.w,
                height: isCompact ? 180.w : 220.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.h),
              Text(
                title ?? 'حدث خطأ ما',
                style: getBoldStyle(
                  fontSize: isCompact ? 16.sp : 18.sp,
                  color: ColorManger.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                message ?? 'لم نتمكن من تنفيذ طلبك في الوقت الحالي. \nحدث خطأ غير متوقع أثناء معالجة العملية، \nيرجى المحاولة مرة أخرى بعد قليل.',
                style: getRegularStyle(
                  fontSize: isCompact ? 13.sp : 15.sp,
                  color: ColorManger.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (_effectiveAction != null) ...[
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: _effectiveAction,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    retryText ?? 'إعادة المحاولة',
                    style: getBoldStyle(
                      fontSize: 14.sp,
                      color: ColorManger.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight.withValues(
                      alpha: 0.9,
                    ),
                    foregroundColor: ColorManger.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
