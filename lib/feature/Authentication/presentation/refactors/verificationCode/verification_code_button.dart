import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/sharedWidget/custom_button.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/loading_button_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationCodeButton extends StatelessWidget {
  const VerificationCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.error) {
          AppToast.showError(
            context,
            message: state.error ?? 'كود التحقق غير صحيح أو انتهت صلاحيته',
          );
        } else if (state.status == ForgotPasswordStatus.verifyCodeSuccess) {
          AppToast.showSuccess(
            context,
            message: state.message ?? 'تم التحقق من الرمز بنجاح 🌾',
          );
          Navigator.pushNamed(
            context,
            Routes.newPasswordRoute,
            arguments: context.read<ForgotPasswordCubit>(),
          );
        }
      },
      builder: (context, state) {
        final bool isEnabled = state.isCodeValid &&
            state.status != ForgotPasswordStatus.loading;

        return CustomButton(
          onPressed: isEnabled
              ? () {
                  context.read<ForgotPasswordCubit>().verifyResetCode();
                }
              : null,
          widget: LoadingButtonContent(
            defaultText: AppStrings.verify,
            state: state,
          ),
        );
      },
    );
  }
}
