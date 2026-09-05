import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/sharedWidget/custom_button.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/loading_button_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.error) {
          AppToast.showError(
            context,
            message: state.error ?? 'حدث خطأ أثناء إرسال الكود',
          );
        } else if (state.status == ForgotPasswordStatus.phoneSuccess) {
          AppToast.showSuccess(
            context,
            message:
                state.message ?? 'تم إرسال كود التحقق في رسالة نصية بنجاح 🌾',
          );
          Navigator.pushNamed(
            context,
            Routes.verificationCodeRoute,
            arguments: context.read<ForgotPasswordCubit>(),
          );
        }
      },
      builder: (context, state) {
        final bool isEnabled = state.isPhoneValid &&
            state.status != ForgotPasswordStatus.loading;

        return CustomButton(
          onPressed: isEnabled
              ? () {
                  context.read<ForgotPasswordCubit>().sendForgotPasswordCode();
                }
              : null,
          widget: LoadingButtonContent(
            defaultText: AppStrings.continueText,
            state: state,
          ),
        );
      },
    );
  }
}
