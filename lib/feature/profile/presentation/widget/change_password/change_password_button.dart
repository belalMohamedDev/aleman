import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_cubit.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, current) =>
          prev.isFormValid != current.isFormValid ||
          prev.status != current.status,
      builder: (context, state) {
        final bool isLoading = state.status == ChangePasswordStatus.loading;
        final bool isEnabled = state.isFormValid && !isLoading;

        return SizedBox(
          height: 52.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    FocusScope.of(context).unfocus();
                    context.read<ChangePasswordCubit>().changePassword();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  ColorManger.primary.withValues(alpha: 0.35),
              disabledForegroundColor: Colors.white70,
              elevation: isEnabled ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    height: 22.h,
                    width: 22.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'تأكيد تغيير كلمة المرور',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
