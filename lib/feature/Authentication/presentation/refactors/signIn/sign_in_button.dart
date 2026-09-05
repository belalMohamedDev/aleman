import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/custom_button.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_state.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Unknown error'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.status == LoginRequestStatus.success) {
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
