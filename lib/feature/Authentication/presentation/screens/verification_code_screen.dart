import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/resend_code_section.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/verification_code_button.dart';
import 'package:aleman/feature/Authentication/presentation/refactors/verificationCode/verify_code_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final cubit = context.read<ForgotPasswordCubit>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: responsive.setPadding(left: 4.5, right: 4.5, top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Modern security badge icon
                  Container(
                    width: responsive.setWidth(24).clamp(76.0, 92.0),
                    height: responsive.setWidth(24).clamp(76.0, 92.0),
                    decoration: BoxDecoration(
                      color: ColorManger.iconsBackgroundColor.withValues(
                        alpha: 0.08,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManger.primaryLight.withValues(alpha: 0.07),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManger.primaryLight.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        ImageAsset.alemanLogo,
                        height: responsive.setWidth(18),
                        width: responsive.setWidth(18),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.setHeight(3)),

                  // Screen Title
                  Text(
                    context.translate(AppStrings.verifyCode),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: responsive.setTextSize(5.5).clamp(20.0, 24.0),
                      fontWeight: FontWeight.bold,
                      color: ColorManger.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsive.setHeight(1.2)),

                  // Subtitle
                  Text(
                    context.translate(AppStrings.pleaseEnterTheCode),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: responsive.setTextSize(3.7).clamp(13.0, 16.0),
                      color: ColorManger.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsive.setHeight(2)),

                  // Phone number chip with edit action
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: ColorManger.primaryLight.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.call5,
                          size: responsive.setTextSize(4).clamp(15.0, 18.0),
                          color: ColorManger.primaryLight,
                        ),
                        SizedBox(width: responsive.setWidth(2)),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            cubit.userPhoneController.text.isNotEmpty
                                ? cubit.userPhoneController.text
                                : '01xxxxxxxxx',
                            style: TextStyle(
                              fontSize: responsive
                                  .setTextSize(4.0)
                                  .clamp(14.0, 17.0),
                              color: ColorManger.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.setHeight(5)),

                  // Modern OTP Input Boxes
                  const VerifyCodeTextFormField(),
                  SizedBox(height: responsive.setHeight(4)),

                  // // Didn't receive code prompt
                  // Text(
                  //   context.translate(AppStrings.didntRecieveotp),
                  //   style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //     fontSize: responsive.setTextSize(3.6).clamp(13.0, 15.0),
                  //     color: ColorManger.grey,
                  //   ),
                  // ),
                  // SizedBox(height: responsive.setHeight(1.2)),

                  // Resend Code with Countdown Timer
                  const ResendCodeSection(),
                  SizedBox(height: responsive.setHeight(5)),

                  // Verification Button
                  const VerificationCodeButton(),
                  //  SizedBox(height: responsive.setHeight(3)),

                  // // Back to Login link
                  // InkWell(
                  //   borderRadius: BorderRadius.circular(8),
                  //   onTap: () {
                  //     Navigator.pushNamedAndRemoveUntil(
                  //       context,
                  //       Routes.loginRoute,
                  //       (route) => false,
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 14,
                  //       vertical: 8,
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           Iconsax.arrow_right_3,
                  //           size: responsive.setTextSize(4).clamp(15.0, 18.0),
                  //           color: ColorManger.primary,
                  //         ),
                  //         SizedBox(width: responsive.setWidth(1.5)),
                  //         Text(
                  //           context.translate(AppStrings.backToLogin),
                  //           style: Theme.of(context).textTheme.titleMedium!
                  //               .copyWith(
                  //                 fontSize: responsive
                  //                     .setTextSize(3.8)
                  //                     .clamp(13.0, 16.0),
                  //                 color: ColorManger.primary,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: responsive.setHeight(3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
