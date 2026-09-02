import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class OrSignWithText extends StatelessWidget {
  const OrSignWithText({
    super.key,
    this.orSignWithText = AppStrings.orSignInWith,
  });
  final String orSignWithText;

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);

    return Row(
      children: [
        // Left divider: occupies the available horizontal space before the text
        Expanded(
          child: Divider(
            height: responsive.setHeight(2), // Height of the divider
            indent: 40, // Space from the left edge
            endIndent: 5, // Space before the text
            color: ColorManger
                .black26, // Color of the divider (semi-transparent black)
          ),
        ),
        // Center text: "Or sign in with" text between the dividers
        Text(
          context.translate(orSignWithText),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: responsive.setTextSize(3.5),
          ), // Responsive text size
        ),
        // Right divider: occupies the available horizontal space after the text
        Expanded(
          child: Divider(
            height: responsive.setHeight(2), // Height of the divider
            indent: 5, // Space after the text
            endIndent: 40, // Space from the right edge
            color: ColorManger
                .black26, // Color of the divider (semi-transparent black)
          ),
        ),
      ],
    );
  }
}
