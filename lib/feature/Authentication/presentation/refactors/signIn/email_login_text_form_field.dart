import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/utils/app_regex.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class EmailLoginTextFormField extends StatelessWidget {
  const EmailLoginTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextFormField(
          // Capture the email input and trigger the event to update the bloc's state

          onChanged: (value) => context.read<LoginCubit>().validateFields(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
              return context.translate(AppStrings.pleaseEnterValidEmail);
            }
            return null;
          },
          textInputAction:
              TextInputAction.next, // Move to the next field when done
          keyboardType:
              TextInputType.emailAddress, // Email input type for keyboard
          controller: context
              .read<LoginCubit>()
              .userLoginEmailAddress, // Email controller from the bloc
          // Enable autofill hints for better UX
          autofillHints: const [AutofillHints.email],

          // Input decoration including the prefix icon and error handling
          decoration: InputDecoration(
            prefixIcon: Icon(
              Iconsax.message, // Email icon
              size: responsive.setIconSize(
                5.5,
              ), // Adjust icon size responsively
            ),
            hintText: context.translate(
              AppStrings.emailExample,
            ), // Placeholder text for the email field
          ),
        );
      },
    );
  }
}
