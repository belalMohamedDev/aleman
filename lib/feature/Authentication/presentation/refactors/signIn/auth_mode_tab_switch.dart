import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AuthModeTabSwitch extends StatelessWidget {
  const AuthModeTabSwitch({super.key});

  // Soft light blue-grey tones from the app's design
  static const Color containerBg = Color(0xFFEFF4FA);
  static const Color containerBorder = Color(0xFFDFE7F3);

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
            color: containerBg,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: containerBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Phone Tab (OTP)
              Expanded(
                child: _AppTabButton(
                  title: 'رقم الهاتف (OTP)',
                  icon: Iconsax.mobile,
                  isSelected: isPhone,
                  onTap: () => cubit.changeAuthMode(AuthMode.phone),
                ),
              ),

              SizedBox(width: 4.w),

              // Email / Username Tab
              Expanded(
                child: _AppTabButton(
                  title: 'البريد الإلكتروني',
                  icon: Iconsax.sms,
                  isSelected: !isPhone,
                  onTap: () => cubit.changeAuthMode(AuthMode.email),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppTabButton extends StatelessWidget {
  const _AppTabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFFDFE7F3),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF112D1C)
                    : const Color(0xFF5A6E85),
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              icon,
              size: 17.sp,
              color: isSelected
                  ? const Color(0xFF112D1C)
                  : const Color(0xFF5A6E85),
            ),
          ],
        ),
      ),
    );
  }
}
