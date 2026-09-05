import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/verification_code_button.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/verify_code_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final cubit = context.read<ForgotPasswordCubit>();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: responsive.setPadding(left: 5, right: 5, top: 15),
            child: Column(
              children: [
                Text(
                  context.translate(AppStrings.verifyCode),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: responsive.setHeight(2)),
                Text(
                  context.translate(AppStrings.pleaseEnterTheCode),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: responsive.setTextSize(3.8)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.setHeight(1)),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    cubit.userPhoneController.text,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: responsive.setTextSize(4.2),
                          color: ColorManger.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: responsive.setHeight(4)),
                const VerifyCodeTextFormField(),
                SizedBox(height: responsive.setHeight(4)),
                Text(
                  context.translate(AppStrings.didntRecieveotp),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: responsive.setTextSize(4)),
                ),
                SizedBox(height: responsive.setHeight(1.5)),
                BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) {
                    final bool isResending =
                        state.status == ForgotPasswordStatus.loading;

                    return InkWell(
                      onTap: isResending ? null : () => cubit.resendCode(),
                      child: Text(
                        context.translate(AppStrings.resendCode),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              fontSize: responsive.setTextSize(3.8),
                              color: isResending
                                  ? Colors.grey
                                  : ColorManger.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    );
                  },
                ),
                SizedBox(height: responsive.setHeight(4)),
                const VerificationCodeButton(),
                SizedBox(height: responsive.setHeight(4)),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.loginRoute,
                        (route) => false,
                      );
                    },
                    child: Text(
                      context.translate(AppStrings.backToLogin),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: responsive.setTextSize(4)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
