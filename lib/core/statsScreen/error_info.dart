import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ErrorInfo widget used for structured info/error messages with actions
class ErrorInfo extends StatelessWidget {
  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback? press;

  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 320.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            if (btnText != null || button != null) ...[
              SizedBox(height: 24.h),
              button ??
                  ElevatedButton(
                    onPressed: press,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.primaryLight,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 26.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      btnText ?? context.translate(AppStrings.retry),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
