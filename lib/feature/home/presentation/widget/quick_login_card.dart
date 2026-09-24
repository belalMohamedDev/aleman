import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/auth_mode_tab_switch.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/email_password_form_view.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/signIn/phone_otp_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickLoginCard extends StatelessWidget {
  const QuickLoginCard({
    super.key,
    required this.onDismiss,
    required this.onLoginSuccess,
  });

  final VoidCallback onDismiss;
  final VoidCallback onLoginSuccess;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider<LoginCubit>(
      create: (_) => instance<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            (previous.phoneStep != current.phoneStep &&
                current.phoneStep == PhoneStep.otp),
        listener: (context, state) {
          if (state.status == LoginRequestStatus.error &&
              state.error != null &&
              state.error!.isNotEmpty) {
            AppToast.showError(context, message: state.error!);
          } else if (state.status == LoginRequestStatus.success) {
            AppToast.showSuccess(
              context,
              message: 'تم تسجيل الدخول بنجاح! أهلاً بك في الإيمان 🌾',
            );
            onLoginSuccess();
          } else if (state.message != null &&
              state.phoneStep == PhoneStep.otp &&
              state.status == LoginRequestStatus.initial) {
            AppToast.showSuccess(context, message: state.message!);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Container(
                width: 345.w,
                constraints: BoxConstraints(maxHeight: screenHeight * 0.90),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 36,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Visual Collage Header
                      _QuickLoginHeader(onClose: onDismiss),

                      // Card Content
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title
                              Text(
                                'هلا لنبدأ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  color: ColorManger.authTitleDark,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 4.h),

                              // Subtitle
                              Text(
                                'سجّل دخولك لمتابعة سلتك وطلبات الأعلاف مباشرة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorManger.authSubtitleGrey,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Tab Switcher (Phone OTP / Email)
                              const AuthModeTabSwitch(),
                              SizedBox(height: 16.h),

                              // Active Form
                              AnimatedSwitcher(
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
                                        key: ValueKey('quick_phone_form'),
                                        child: PhoneOtpFormView(),
                                      )
                                    : const KeyedSubtree(
                                        key: ValueKey('quick_email_form'),
                                        child: EmailPasswordFormView(),
                                      ),
                              ),

                              SizedBox(height: 12.h),

                              // Guest browse fallback
                              Center(
                                child: TextButton(
                                  onPressed: onDismiss,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey.shade600,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 4.h,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'تصفح كزائر الآن',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      // decoration: TextDecoration.underline,
                                      decorationColor: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickLoginHeader extends StatelessWidget {
  const _QuickLoginHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD400), Color(0xFFFFC000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background organic yellow circles
          Positioned(
            top: -20.h,
            left: 50.w,
            child: Container(
              width: 220.r,
              height: 220.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFDF33).withValues(alpha: 0.5),
              ),
            ),
          ),

          Positioned(
            bottom: -30.h,
            right: -20.w,
            child: Container(
              width: 140.r,
              height: 140.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF7BE00).withValues(alpha: 0.4),
              ),
            ),
          ),

          // 1. Close Button (Top Left)
          Positioned(
            top: 14.h,
            left: 14.w,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  size: 16.r,
                  color: const Color(0xFF334155),
                ),
              ),
            ),
          ),

          // 2. Top-Left Badge: Hen & Rooster
          Positioned(
            top: 50.h,
            left: 50.w,
            child: const _CollageBadge(
              circleSize: 66,
              imageSize: 52,
              assetPath: ImageAsset.hen,
            ),
          ),

          // 3. Top-Right Badge: Cow
          Positioned(
            top: 25.h,
            right: 22.w,
            child: const _CollageBadge(
              circleSize: 66,
              imageSize: 52,
              assetPath: ImageAsset.cow,
            ),
          ),

          // 4. Center Hero: Duck Feed Bag
          Positioned(
            top: 30.h,
            left: 130.w,
            child: const _CollageBadge(
              circleSize: 94,
              imageSize: 90,
              assetPath: ImageAsset.loginFarmer,
              rotation: -0.04,
            ),
          ),

          // 5. Bottom-Left Badge: Two Ducks
          Positioned(
            bottom: 12.h,
            left: 18.w,
            child: const _CollageBadge(
              circleSize: 66,
              imageSize: 52,
              assetPath: ImageAsset.duck,
            ),
          ),

          // 6. Bottom-Center Badge: Feed Pellets / Grains
          Positioned(
            bottom: 8.h,
            left: 140.w,
            child: const _CollageBadge(
              circleSize: 56,
              imageSize: 44,
              assetPath: ImageAsset.feedPellets,
            ),
          ),

          // 7. Bottom-Right Badge: Rabbits
          Positioned(
            bottom: 12.h,
            right: 18.w,
            child: const _CollageBadge(
              circleSize: 66,
              imageSize: 52,
              assetPath: ImageAsset.rabbit,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollageBadge extends StatelessWidget {
  const _CollageBadge({
    required this.circleSize,
    required this.imageSize,
    required this.assetPath,
    this.rotation = 0.0,
  });

  final double circleSize;
  final double imageSize;
  final String assetPath;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize.r,
      height: circleSize.r,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Yellow Disk
          Container(
            width: circleSize.r,
            height: circleSize.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0B90B),
              border: Border.all(color: const Color(0xFFFFE066), width: 2.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Product / Animal Asset
          Transform.rotate(
            angle: rotation,
            child: Image.asset(
              assetPath,
              width: imageSize.r,
              height: imageSize.r,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
