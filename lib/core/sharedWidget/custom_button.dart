import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final Color? borderColor;
  final Widget? widget;
  final double height;
  final double width;
  final double radius;

  const CustomButton({
    super.key,
    this.color,
    required this.onPressed,
    required this.widget,
    this.height = 4.8,
    this.width = double.infinity,
    this.radius = 2,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);
    final buttonColor =
        color ??
        (onPressed == null
            ? ColorManger.unselectedButton
            : ColorManger.primary);
    return Container(
      height: responsive.setHeight(height),
      width: responsive.setWidth(width),
      decoration: BoxDecoration(
        border: borderColor != null
            ? Border.all(color: borderColor!) // Ensure borderColor is not null
            : null,
        borderRadius: BorderRadius.circular(responsive.setBorderRadius(radius)),
        color: buttonColor,
      ),
      child: TextButton(onPressed: onPressed, child: widget!),
    );
  }
}
