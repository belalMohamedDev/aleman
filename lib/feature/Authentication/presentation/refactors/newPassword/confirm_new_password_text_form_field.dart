import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ConfirmNewPasswordTextFormField extends StatelessWidget {
  const ConfirmNewPasswordTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();

        return TextFormField(
          onChanged: (value) => cubit.validateNewPassword(),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          controller: cubit.userConfirmPasswordController,
          obscureText: state.showConfirmPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.translate(AppStrings.enterConfirmNewPassword);
            }
            if (value != cubit.userNewPasswordController.text) {
              return context.translate(
                AppStrings.confirmPasswordNotEqualNewPassword,
              );
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Iconsax.lock,
              size: responsive.setIconSize(5.5),
            ),
            suffixIcon: IconButton(
              onPressed: cubit.toggleConfirmPasswordVisibility,
              icon: Icon(
                state.showConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                size: responsive.setIconSize(6),
              ),
            ),
            hintText: context.translate(AppStrings.enterConfirmNewPassword),
            labelText: context.translate(AppStrings.confirmPassword),
          ),
        );
      },
    );
  }
}
