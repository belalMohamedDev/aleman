import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/sharedWidget/custom_button.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/loading_button_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginRequestStatus.error) {
          AppToast.showError(
            context,
            message: state.error ?? 'حدث خطأ أثناء تسجيل الدخول',
          );
        } else if (state.status == LoginRequestStatus.success) {
          AppToast.showSuccess(
            context,
            message: 'تم تسجيل الدخول بنجاح! أهلاً بك في الإيمان 🌾',
          );
          // Navigate to Home or BottomNavBar
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
        }
      },

      builder: (context, state) {
        return CustomButton(
          onPressed: state.isButtonValid
              ? () {
                  context.read<LoginCubit>().login();
                }
              : null,
          widget: LoadingButtonContent(
            defaultText: AppStrings.signIn,
            state: state,
          ),
        );
      },
    );
  }
}
