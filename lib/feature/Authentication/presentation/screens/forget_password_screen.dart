import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/restEmail/email_forget_password_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/restEmail/forget_password_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: responsive.setPadding(left: 5, right: 5, top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                context.translate(AppStrings.restYourPassword),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                height: responsive.setHeight(2),
              ),
              Text(
                'أدخل رقم هاتفك وسنرسل لك كود التحقق في رسالة نصية',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: responsive.setTextSize(3.8)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: responsive.setHeight(6),
              ),
              const EmailForgetPasswordTextFormField(),
              SizedBox(
                height: responsive.setHeight(4),
              ),
              const ForgetPasswordButton(),
              SizedBox(
                height: responsive.setHeight(4),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    context.read<ForgotPasswordCubit>().userPhoneController.clear();
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
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
    );
  }
}
