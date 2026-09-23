import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationCodeButton extends StatelessWidget {
  const VerificationCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      buildWhen: (previous, current) =>
          previous.isCodeValid != current.isCodeValid ||
          previous.status != current.status,
      listener: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();
        if (state.status == ForgotPasswordStatus.error) {
          AppToast.showError(
            context,
            message: state.error ?? 'كود التحقق غير صحيح أو انتهت صلاحيته',
          );
          cubit.resetStatus();
        } else if (state.status == ForgotPasswordStatus.verifyCodeSuccess) {
          cubit.cancelResendTimer();
          AppToast.showSuccess(
            context,
            message: state.message ?? 'تم التحقق من الرمز بنجاح 🌾',
          );
          Navigator.pushNamed(
            context,
            Routes.newPasswordRoute,
            arguments: cubit,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.loading;
        final bool isEnabled = state.isCodeValid && !isLoading;

        return SizedBox(
          height: 52.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    context.read<ForgotPasswordCubit>().verifyResetCode();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.primaryLight,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  ColorManger.primaryLight.withValues(alpha: 0.35),
              disabledForegroundColor: Colors.white70,
              elevation: isEnabled ? 1 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
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
                    'تأكيد ومتابعة',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
