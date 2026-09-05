import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/sharedWidget/custom_button.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/loading_button_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final bool isEnabled = state.isNewPasswordValid &&
            state.status != ForgotPasswordStatus.loading;

        return CustomButton(
          onPressed: isEnabled
              ? () {
                  context.read<ForgotPasswordCubit>().resetPassword();
                }
              : null,
          widget: LoadingButtonContent(
            defaultText: AppStrings.createNewPassword,
            state: state,
          ),
        );
      },
    );
  }
}
