import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class HeadlineTextAuthScreen extends StatelessWidget {
  const HeadlineTextAuthScreen({
    super.key,
    required this.titleText,
    required this.subTitleText,
  });

  final String titleText;
  final String subTitleText;

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align children to the left
      children: [
        Text(
          context.translate(titleText),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: responsive.setTextSize(4.2), // Uses theme styling
          ),
        ),

        SizedBox(
          height: responsive.setHeight(1), // Spacing after the headline
        ),

        // Subtitle prompting the user to sign in
        Text(
          context.translate(subTitleText),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: responsive.setTextSize(3.4),
          ), // Adjust font size based on screen size
        ),
      ],
    );
  }
}
