import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ResendCodeSection extends StatelessWidget {
  const ResendCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return BlocSelector<ForgotPasswordCubit, ForgotPasswordState, bool>(
      selector: (state) => state.status == ForgotPasswordStatus.loading,
      builder: (context, isLoading) {
        if (isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: ColorManger.primaryLight,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  context.translate(AppStrings.processing),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorManger.authSubtitleGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ValueListenableBuilder<int>(
          valueListenable: cubit.resendCountdownNotifier,
          builder: (context, countdown, _) {
            final bool isRunning = countdown > 0;

            if (isRunning) {
              final minutes = (countdown ~/ 60).toString().padLeft(2, '0');
              final seconds = (countdown % 60).toString().padLeft(2, '0');

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: ColorManger.authFieldBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: ColorManger.authFieldBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.timer_1,
                      size: 16.sp,
                      color: ColorManger.primaryLight,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      context.translate(AppStrings.resendCodeIn),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManger.authSubtitleGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '$minutes:$seconds',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManger.primaryLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => cubit.resendCode(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.rotate_left,
                        size: 16.sp,
                        color: ColorManger.primaryLight,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        context.translate(AppStrings.resendCode),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: ColorManger.primaryLight,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorManger.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
