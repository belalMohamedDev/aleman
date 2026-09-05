import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:flutter/material.dart';

class LoadingButtonContent extends StatelessWidget {
  const LoadingButtonContent({
    super.key,
    required this.state,
    this.defaultText,
    this.defultWidget,
  });

  final dynamic state;
  final String? defaultText;
  final Widget? defultWidget;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    Widget loadingWidget({bool signWithGoogleOrApple = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: responsive.setHeight(2),
            width: responsive.setWidth(4),
            child: CircularProgressIndicator(
              color: signWithGoogleOrApple
                  ? ColorManger.primaryLight
                  : ColorManger.white,
              strokeWidth: 2.0,
              strokeAlign: 0.01,
            ),
          ),
          SizedBox(width: responsive.setHeight(2)),
          Text(
            context.translate(AppStrings.loading),
            style: signWithGoogleOrApple
                ? Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontSize: responsive.setTextSize(3.8))
                : Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontSize: responsive.setTextSize(3.8)),
          ),
        ],
      );
    }

    final bool isLoading =
        (state is LoginState && state.status == LoginRequestStatus.loading) ||
        (state is ForgotPasswordState &&
            state.status == ForgotPasswordStatus.loading);

    if (isLoading) {
      return loadingWidget();
    } else {
      return defultWidget ??
          Text(
            context.translate(defaultText!),
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontSize: responsive.setTextSize(3.8)),
          );
    }
  }
}
