import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/restEmail/email_forget_password_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/restEmail/forget_password_button.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_visual_header.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/auth_contact_support_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.h),
                const AuthVisualHeader(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50.h),

                      // Title (Noon Style)
                      Text(
                        'نسيت كلمة المرور؟',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: ColorManger.authTitleDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'أدخل رقم هاتفك وسنرسل لك كود التحقق في رسالة نصية',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorManger.authSubtitleGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Phone field
                      const EmailForgetPasswordTextFormField(),

                      SizedBox(height: 20.h),

                      // Submit Button
                      const ForgetPasswordButton(),

                      SizedBox(height: 20.h),

                      // Back to login link
                      Center(
                        child: InkWell(
                          onTap: () {
                            context
                                .read<ForgotPasswordCubit>()
                                .userPhoneController
                                .clear();
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.loginRoute,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.arrow_right_3,
                                  size: 16.sp,
                                  color: ColorManger.primaryLight,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'العودة لتسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: ColorManger.primaryLight,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Contact / Help Link
                      const AuthContactSupportLink(),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
