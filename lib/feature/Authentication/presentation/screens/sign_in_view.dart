import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_mode_tab_switch.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_visual_header.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/email_password_form_view.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/phone_otp_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _showContactOptions(BuildContext context) {
    const String phoneNumber = "201110767100";
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 3,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ListTile(
                leading: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14159),
                  child: const Icon(
                    Iconsax.call_received5,
                    color: Colors.green,
                  ),
                ),
                title: const Text("اتصال مباشر"),
                onTap: () async {
                  Navigator.pop(context);
                  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
              ListTile(
                leading: Image.asset(
                  ImageAsset.whatsapp,
                  width: 24,
                  height: 24,
                ),
                title: const Text("واتساب"),
                onTap: () async {
                  Navigator.pop(context);
                  final Uri url = Uri.parse("https://wa.me/$phoneNumber");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.copy, color: ColorManger.goldDark),
                title: const Text("نسخ الرقم"),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(const ClipboardData(text: phoneNumber))
                      .then((_) {
                        if (context.mounted) {
                          AppToast.showSuccess(
                            context,
                            message: "تم نسخ رقم التواصل بنجاح 🌾",
                          );
                        }
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                            SizedBox(height: 10.h),

                            // Title (Noon Style)
                            Text(
                              'أهلاً بك! لنبدأ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1E293B),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'سجّل دخولك لمتابعة سلتك وطلبات الأعلاف بكل سهولة',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF64748B),
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
                                  duration: const Duration(milliseconds: 200),
                                  child: state.authMode == AuthMode.phone
                                      ? const PhoneOtpFormView()
                                      : const EmailPasswordFormView(),
                                );
                              },
                            ),

                            SizedBox(height: 30.h),

                            // Contact / Help Link (clean & subtle at bottom)
                            Center(
                              child: InkWell(
                                onTap: () => _showContactOptions(context),
                                borderRadius: BorderRadius.circular(20.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.headphone,
                                        size: 16.sp,
                                        color: const Color(0xFF64748B),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'تحتاج مساعدة؟ تواصل مع خدمة العملاء',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

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
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF334155),
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
