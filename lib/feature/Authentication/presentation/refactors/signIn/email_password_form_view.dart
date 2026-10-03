import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/font_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class EmailPasswordFormView extends StatelessWidget {
  const EmailPasswordFormView({super.key});

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
                  color: ColorManger.authTitleDark,
                ),
                decoration: InputDecoration(
                  hintText: 'البريد الإلكتروني أو اسم المستخدم',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: ColorManger.authHintGrey,
                  ),
                  filled: true,
                  fillColor: ColorManger.authFieldBg,
                  prefixIcon: Icon(
                    Iconsax.sms,
                    color: ColorManger.authIconColor,
                    size: 20,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorManger.authFieldBorder,
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorManger.authFieldBorder,
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
                  color: ColorManger.authTitleDark,
                ),
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: ColorManger.authHintGrey,
                  ),
                  filled: true,
                  fillColor: ColorManger.authFieldBg,
                  prefixIcon: IconButton(
                    onPressed: () => cubit.togglePasswordVisibility(),
                    icon: Icon(
                      state.showPass ? Iconsax.eye_slash : Iconsax.eye,
                      color: ColorManger.authIconColor,
                      size: 20,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorManger.authFieldBorder,
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: ColorManger.authFieldBorder,
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
              Container(
                height: 52.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManger.primaryLight.withValues(
                        alpha: isEnabled ? 0.28 : 0.0,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: isEnabled ? () => cubit.login() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight,
                    foregroundColor: ColorManger.white,
                    disabledBackgroundColor: ColorManger.primaryLight
                        .withValues(alpha: 0.35),
                    disabledForegroundColor: Colors.white70,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeightManger.bold,
                                color: ColorManger.white,
                                letterSpacing: 0.2,
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
