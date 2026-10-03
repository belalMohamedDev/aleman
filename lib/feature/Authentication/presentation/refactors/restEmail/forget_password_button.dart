import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/font_manger.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.error) {
          // AppToast.showError(
          //   context,
          //   message: state.error ?? 'حدث خطأ أثناء إرسال الكود',
          // );
        } else if (state.status == ForgotPasswordStatus.phoneSuccess) {
          // AppToast.showSuccess(
          //   context,
          //   message:
          //       state.message ?? 'تم إرسال كود التحقق في رسالة نصية بنجاح 🌾',
          // );
          Navigator.pushNamed(
            context,
            Routes.verificationCodeRoute,
            arguments: context.read<ForgotPasswordCubit>(),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.loading;
        final bool isEnabled = state.isPhoneValid && !isLoading;

        return Container(
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: ColorManger.primaryLight.withValues(
                  alpha: isEnabled ? 0.28 : 0.0,
                ),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    context
                        .read<ForgotPasswordCubit>()
                        .sendForgotPasswordCode();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.primaryLight,
              foregroundColor: ColorManger.white,
              disabledBackgroundColor: ColorManger.primaryLight.withValues(
                alpha: 0.35,
              ),
              disabledForegroundColor: Colors.white70,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'إرسال كود التحقق',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeightManger.bold,
                          color: ColorManger.white,
                          letterSpacing: 0.2,
                        ),
                  ),
          ),
        );
      },
    );
  }
}
