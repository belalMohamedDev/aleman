import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AuthModeTabSwitch extends StatelessWidget {
  const AuthModeTabSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.authMode != current.authMode,
      builder: (context, state) {
        final isPhone = state.authMode == AuthMode.phone;
        final cubit = context.read<LoginCubit>();

        return Container(
          height: 52.h,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: ColorManger.authFieldBg,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: ColorManger.authFieldBorder, width: 1.2),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Smooth sliding capsule pill
              AnimatedAlign(
                alignment: isPhone
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                duration: const Duration(milliseconds: 280),
                curve: Curves.fastOutSlowIn,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: ColorManger.authFieldBorder,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A)
                              .withValues(alpha: 0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Interactive tab labels
              Row(
                children: [
                  // Phone Tab (OTP)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!isPhone) {
                          cubit.changeAuthMode(AuthMode.phone);
                        }
                      },
                      child: Center(
                        child: _TabContent(
                          title: 'رقم الهاتف',
                          icon: Iconsax.mobile,
                          isSelected: isPhone,
                        ),
                      ),
                    ),
                  ),

                  // Email / Username Tab
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isPhone) {
                          cubit.changeAuthMode(AuthMode.email);
                        }
                      },
                      child: Center(
                        child: _TabContent(
                          title: 'البريد الإلكتروني',
                          icon: Iconsax.sms,
                          isSelected: !isPhone,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.title,
    required this.icon,
    required this.isSelected,
  });

  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = ColorManger.authTitleDark;
    final unselectedColor = ColorManger.authSubtitleGrey;

    return TweenAnimationBuilder<Color?>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: ColorTween(end: isSelected ? selectedColor : unselectedColor),
      builder: (context, color, _) {
        final activeColor =
            color ?? (isSelected ? selectedColor : unselectedColor);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: activeColor,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(icon, size: 17.sp, color: activeColor),
          ],
        );
      },
    );
  }
}
