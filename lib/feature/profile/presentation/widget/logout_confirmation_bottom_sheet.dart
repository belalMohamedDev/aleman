import 'package:aleman/core/services/app_logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class LogoutConfirmationBottomSheet extends StatelessWidget {
  const LogoutConfirmationBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LogoutConfirmationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoggingOutNotifier = ValueNotifier<bool>(false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.logout_1,
                color: Colors.red.shade600,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'تسجيل الخروج',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24.h),
            ValueListenableBuilder<bool>(
              valueListenable: isLoggingOutNotifier,
              builder: (context, isLoggingOut, _) {
                return Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: isLoggingOut
                            ? null
                            : () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoggingOut
                            ? null
                            : () async {
                                isLoggingOutNotifier.value = true;
                                await const AppLogout()
                                    .logOutThenNavigateToLogin(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,

                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoggingOut
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'تسجيل الخروج',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
