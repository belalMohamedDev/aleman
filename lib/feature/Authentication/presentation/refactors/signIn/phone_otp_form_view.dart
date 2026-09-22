import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_cubit.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PhoneOtpFormView extends StatelessWidget {
  const PhoneOtpFormView({super.key});

  // Soft light blue-grey tones from the user's reference
  static const Color fieldBg = Color(0xFFEFF4FA);
  static const Color fieldBorder = Color(0xFFDFE7F3);
  static const Color iconColor = Color(0xFF8C9DAE);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.phoneStep != current.phoneStep ||
          previous.isButtonValid != current.isButtonValid ||
          previous.status != current.status ||
          previous.countdown != current.countdown ||
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isLoading = state.status == LoginRequestStatus.loading;
        final isEnabled = state.isButtonValid && !isLoading;

        if (state.phoneStep == PhoneStep.input) {
          return Form(
            key: cubit.phoneFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phone Number Input (Matches User Reference)
                TextFormField(
                  controller: cubit.phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  onChanged: (val) => cubit.updatePhoneNumber(val),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'مثال: 01012345678',
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: fieldBg,
                    suffixIcon: const Icon(
                      Iconsax.mobile,
                      color: iconColor,
                      size: 20,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: fieldBorder, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: fieldBorder, width: 1.2),
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

                SizedBox(height: 24.h),

                // Continue Button
                SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: isEnabled ? () => cubit.sendLoginOtp() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.primaryLight,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          ColorManger.primaryLight.withValues(alpha: 0.35),
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
                            'متابعة',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        }

        // PhoneStep.otp
        return Form(
          key: cubit.otpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info box with current phone
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: fieldBorder),
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
                            child: Text.rich(
                              TextSpan(
                                text: 'تم إرسال الرمز إلى ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF64748B),
                                ),
                                children: [
                                  TextSpan(
                                    text: state.phoneNumber.isNotEmpty
                                        ? state.phoneNumber
                                        : cubit.phoneController.text,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: isLoading
                          ? null
                          : () => cubit.setPhoneStep(PhoneStep.input),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        child: Text(
                          'تعديل',
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

              SizedBox(height: 18.h),

              // OTP 6-digit Field (User Reference Style)
              TextFormField(
                controller: cubit.otpController,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 14.w,
                  color: const Color(0xFF1E293B),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (val) => cubit.updateOtpCode(val),
                decoration: InputDecoration(
                  hintText: '------',
                  hintStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 14.w,
                    color: const Color(0xFFCBD5E1),
                  ),
                  filled: true,
                  fillColor: fieldBg,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: fieldBorder, width: 1.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: fieldBorder, width: 1.2),
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

              SizedBox(height: 12.h),

              // Timer / Resend Row
              Align(
                alignment: Alignment.center,
                child: state.countdown > 0
                    ? Text(
                        'إعادة الإرسال بعد (${state.countdown} ثانية)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : InkWell(
                        onTap: isLoading ? null : () => cubit.resendLoginOtp(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.refresh,
                                size: 14.sp,
                                color: ColorManger.primaryLight,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'إعادة إرسال الرمز الآن',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManger.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              SizedBox(height: 20.h),

              // Verify Button
              SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: isEnabled ? () => cubit.verifyLoginOtp() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        ColorManger.primaryLight.withValues(alpha: 0.35),
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
                          'تأكيد الدخول',
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
