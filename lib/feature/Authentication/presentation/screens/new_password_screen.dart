import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/newPassword/confirm_new_password_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/newPassword/new_password_button.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/newPassword/new_password_text_form_field.dart';
import 'package:flutter/material.dart';

class NewPasswordView extends StatelessWidget {
  const NewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: responsive.setPadding(left: 5, right: 5, top: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                context.translate(AppStrings.newPassword),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: responsive.setTextSize(4.5)),
              ),
              SizedBox(height: responsive.setHeight(2)),
              Text(
                context.translate(AppStrings.youNewPasswordMustBeDifferent),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: responsive.setTextSize(3.5)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.setHeight(6)),
              const NewPasswordTextFormField(),
              SizedBox(height: responsive.setHeight(2)),
              const ConfirmNewPasswordTextFormField(),
              SizedBox(height: responsive.setHeight(4)),
              const NewPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }
}
