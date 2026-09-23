import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_mode_tab_switch.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_visual_header.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/email_password_form_view.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/phone_otp_form_view.dart';
import 'package:aleman/feature/Authentication/presentation/sharedWidgetBetweenScreen/auth_contact_support_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginRequestStatus.error &&
                state.error != null) {
              AppToast.showError(context, message: state.error!);
            } else if (state.status == LoginRequestStatus.success) {
              AppToast.showSuccess(
                context,
                message: 'تم تسجيل الدخول بنجاح! أهلاً بك في الإيمان 🌾',
              );
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
              }
            } else if (state.message != null &&
                state.phoneStep == PhoneStep.otp &&
                state.status == LoginRequestStatus.initial) {
              AppToast.showSuccess(context, message: state.message!);
            }
          },
          child: SafeArea(
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
                            SizedBox(height: 30.h),

                            // Title (Noon Style)
                            Text(
                              'أهلاً بك! لنبدأ',
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
                              'سجّل دخولك لمتابعة سلتك وطلبات الأعلاف بكل سهولة',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorManger.authSubtitleGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Noon Style Dark Capsule Tab Switcher
                            const AuthModeTabSwitch(),

                            SizedBox(height: 16.h),

                            // Active Form (Phone OTP vs Email)
                            BlocBuilder<LoginCubit, LoginState>(
                              buildWhen: (previous, current) =>
                                  previous.authMode != current.authMode,
                              builder: (context, state) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 280),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.0, 0.03),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: state.authMode == AuthMode.phone
                                      ? const KeyedSubtree(
                                          key: ValueKey('phone_form_view'),
                                          child: PhoneOtpFormView(),
                                        )
                                      : const KeyedSubtree(
                                          key: ValueKey('email_form_view'),
                                          child: EmailPasswordFormView(),
                                        ),
                                );
                              },
                            ),

                            SizedBox(height: 20.h),

                            // Contact / Help Link (clean & subtle at bottom)
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
                        Icons.close,
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
      ),
    );
  }
}
