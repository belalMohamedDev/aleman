import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/loginBloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class PasswordLoginTextFormField extends StatelessWidget {
  const PasswordLoginTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<LoginBloc, LoginState>(
      // Listen to the LoginBloc to update the UI based on the current state
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) {
            // // When the user changes the text, update the LoginBloc with the new password
            // context.read<LoginBloc>().add(UserLoginPassword(value));
          },
          textInputAction: TextInputAction
              .next, // Moves to the next field when "next" is pressed
          keyboardType: TextInputType
              .visiblePassword, // Specifies that this is a password field
          controller: context
              .read<LoginBloc>()
              .userLoginPassword, // The controller for managing input
          obscureText: context
              .read<LoginBloc>()
              .showPass, // Toggles between showing/hiding password
          autofillHints: const [
            AutofillHints.password, // Autofill hint for password
          ],
          decoration: InputDecoration(
            // Prefix icon (lock icon) for password input
            prefixIcon: Icon(
              Iconsax.lock, // Lock icon to represent the password field
              size: responsive.setIconSize(
                5.5,
              ), // Set size dynamically based on screen size
            ),
            // Suffix icon to toggle password visibility (show/hide)
            suffixIcon: IconButton(
              onPressed: () {
                // Toggle the password visibility in the bloc
                // context.read<LoginBloc>().add(const UserShowLoginPassword());
              },
              icon: context.read<LoginBloc>().showPass
                  ? Icon(
                      Iconsax.eye_slash, // Show password icon
                      size: responsive.setIconSize(
                        6.5,
                      ), // Set icon size dynamically
                    )
                  : Icon(
                      Iconsax.eye, // Hide password icon
                      size: responsive.setIconSize(
                        6.5,
                      ), // Set icon size dynamically
                    ),
            ),
            hintText: context.translate(
              AppStrings.enterYourPassword,
            ), // Hint text for the password field
            // Show validation errors if any, based on the state of the bloc
            errorText: state.whenOrNull(
              userLoginPassword: (value) {
                return value.isNotEmpty
                    ? value
                    : null; // If error exists, display it
              },
            ),
          ),
        );
      },
    );
  }
}
