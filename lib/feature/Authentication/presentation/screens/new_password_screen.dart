import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/newPassword/confirm_new_password_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/newPassword/new_password_button.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/newPassword/new_password_text_form_field.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_visual_header.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/auth_contact_support_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordView extends StatelessWidget {
  const NewPasswordView({super.key});

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
          child: Stack(
            children: [
              SingleChildScrollView(
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
                            'كلمة المرور الجديدة',
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
                            'يجب أن تتكون كلمة المرور من 8 خانات وتحتوي على أحرف وأرقام',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorManger.authSubtitleGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // New Password Field
                          const NewPasswordTextFormField(),

                          SizedBox(height: 14.h),

                          // Confirm New Password Field
                          const ConfirmNewPasswordTextFormField(),

                          SizedBox(height: 24.h),

                          // Submit Button
                          const NewPasswordButton(),

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
              // Fixed Close (X) Button on top-start
              PositionedDirectional(
                top: MediaQuery.of(context).padding.top + 8.h,
                start: 16.w,
                child: InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: ColorManger.authBackBtnBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: ColorManger.authBackBtnIcon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
