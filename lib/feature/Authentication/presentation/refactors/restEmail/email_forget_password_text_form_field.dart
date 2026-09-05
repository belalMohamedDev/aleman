import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/utils/app_regex.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class EmailForgetPasswordTextFormField extends StatelessWidget {
  const EmailForgetPasswordTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) {
            context.read<ForgotPasswordCubit>().validatePhone();
          },
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !AppRegex.isPhoneNumberValid(value)) {
              return context.translate(AppStrings.pleaseEnterValidPhoneNumber);
            }
            return null;
          },
          controller:
              context.read<ForgotPasswordCubit>().userPhoneController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Iconsax.call,
              size: responsive.setIconSize(5.5),
            ),
            hintText: '01xxxxxxxxx',
            labelText: context.translate(AppStrings.phoneNumber),
          ),
        );
      },
    );
  }
}
