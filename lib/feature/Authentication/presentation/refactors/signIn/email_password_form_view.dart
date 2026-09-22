import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class EmailPasswordFormView extends StatelessWidget {
  const EmailPasswordFormView({super.key});

  // Soft light blue-grey tones from the user's reference
  static const Color fieldBg = Color(0xFFEFF4FA);
  static const Color fieldBorder = Color(0xFFDFE7F3);
  static const Color iconColor = Color(0xFF8C9DAE);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isButtonValid != current.isButtonValid ||
          previous.status != current.status ||
          previous.showPass != current.showPass,
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isLoading = state.status == LoginRequestStatus.loading;
        final isEnabled = state.isButtonValid && !isLoading;

        return Form(
          key: cubit.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email / Username field (Reference image style)
              TextFormField(
                controller: cubit.userLoginEmailAddress,
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => cubit.validateFields(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: 'البريد الإلكتروني أو اسم المستخدم',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: fieldBg,
                  suffixIcon: const Icon(
                    Iconsax.sms,
                    color: iconColor,
                    size: 20,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: fieldBorder,
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: fieldBorder,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorManger.primaryLight,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              // Password field (Reference image style: eye on start/left)
              TextFormField(
                controller: cubit.userLoginPassword,
                obscureText: state.showPass,
                onChanged: (val) => cubit.validateFields(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: fieldBg,
                  prefixIcon: IconButton(
                    onPressed: () => cubit.togglePasswordVisibility(),
                    icon: Icon(
                      state.showPass ? Iconsax.eye_slash : Iconsax.eye,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: fieldBorder,
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: fieldBorder,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorManger.primaryLight,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Forget Password Link
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgetPasswordRoute);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      context.translate(AppStrings.forgetPassword),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              // Submit Button
              SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: isEnabled ? () => cubit.login() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: ColorManger.primaryLight
                        .withValues(alpha: 0.35),
                    disabledForegroundColor: Colors.white70,
                    elevation: isEnabled ? 1 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
