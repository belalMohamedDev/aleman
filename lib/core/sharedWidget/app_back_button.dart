import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppBackButton({
    super.key,
    this.onTap,
    this.icon,
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = size ?? 36.r;
    final double iconS = iconSize ?? 18.sp;

    return Center(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Material(
          color: backgroundColor ?? ColorManger.authBackBtnBg,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap ?? () => Navigator.of(context).maybePop(),
            child: Icon(
              icon ?? Icons.arrow_back_ios_new,
              size: iconS,
              color: iconColor ?? ColorManger.authBackBtnIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class AppCloseButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppCloseButton({
    super.key,
    this.onTap,
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = size ?? 36.r;
    final double iconS = iconSize ?? 18.sp;

    return Center(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Material(
          color: backgroundColor ?? ColorManger.authBackBtnBg,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap ?? () => Navigator.of(context).maybePop(),
            child: Icon(
              Icons.close,
              size: iconS,
              color: iconColor ?? ColorManger.authBackBtnIcon,
            ),
          ),
        ),
      ),
    );
  }
}
