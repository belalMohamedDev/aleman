import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordButton extends StatelessWidget {
  const NewPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.error) {
          AppToast.showError(
            context,
            message: state.error ?? 'حدث خطأ أثناء تغيير كلمة المرور',
          );
        } else if (state.status == ForgotPasswordStatus.resetPasswordSuccess) {
          AppToast.showSuccess(
            context,
            message:
                state.message ?? 'تم إعادة تعيين كلمة المرور بنجاح! يمكنك الآن تسجيل الدخول 🌾',
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginRoute,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.loading;
        final bool isEnabled = state.isNewPasswordValid && !isLoading;

        return SizedBox(
          height: 52.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    context.read<ForgotPasswordCubit>().resetPassword();
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
                    'تعيين كلمة المرور',
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
