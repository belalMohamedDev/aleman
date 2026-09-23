import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_visual_header.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/resend_code_section.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/verification_code_button.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/verify_code_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/auth_contact_support_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
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
                          'تأكيد كود التحقق',
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
                          'أدخل كود التحقق المكون من 6 أرقام والمُرسل إلى هاتفك',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorManger.authSubtitleGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // Info box with current phone & Change action
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManger.authFieldBg,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: ColorManger.authFieldBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.message_tick,
                                      size: 18.sp,
                                      color: ColorManger.primaryLight,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        'تم إرسال الكود إلى ${cubit.userPhoneController.text.isNotEmpty ? cubit.userPhoneController.text : '01xxxxxxxxx'}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ColorManger.authTitleDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    'تغيير',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManger.primaryLight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Discrete 6-digit OTP Input Boxes
                        const VerifyCodeTextFormField(),

                        SizedBox(height: 18.h),

                        // Resend Code with Countdown Timer
                        const ResendCodeSection(),

                        SizedBox(height: 24.h),

                        // Verification Button
                        const VerificationCodeButton(),

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
      ),
    );
  }
}
