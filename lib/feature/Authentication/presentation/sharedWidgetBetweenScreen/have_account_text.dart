import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HaveAnAccountText extends StatelessWidget {
  const HaveAnAccountText({super.key, this.signUpText = false});

  final bool signUpText;

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);

    return Align(
      alignment:
          Alignment.topCenter, // Align the text at the top center of its parent
      child: Text.rich(
        TextSpan(
          text: context.translate(
            signUpText
                ? AppStrings.alreadyHaveAccount
                : AppStrings.dontHaveAnAccount,
          ), // Default text message
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: responsive.setTextSize(4), // Responsive font size
          ),
          children: [
            // Space between the two texts
            WidgetSpan(
              child: SizedBox(
                width: responsive.setWidth(3), // Responsive width for spacing
              ),
            ),
            // Sign Up link with tap gesture
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigate to the registration route when tapped
                  // signUpText
                  //     ? context.pushReplacementNamed(Routes.loginRoute)
                  //     : context.pushReplacementNamed(Routes.registerRoute);
                },
              text: context.translate(
                signUpText ? AppStrings.signIn : AppStrings.signUp,
              ), // Link text
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: responsive.setTextSize(4.5),
              ), // Responsive font size
            ),
          ],
        ),
        style: Theme.of(context).textTheme.bodyLarge, // Overall text style
      ),
    );
  }
}
