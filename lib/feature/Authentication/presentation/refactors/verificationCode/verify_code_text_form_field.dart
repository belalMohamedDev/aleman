import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeTextFormField extends StatelessWidget {
  const VerifyCodeTextFormField({super.key});

  static const int otpLength = 6;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final cubit = context.read<ForgotPasswordCubit>();

    return AutofillGroup(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: cubit.otpCodeController,
        builder: (context, value, _) {
          final text = value.text;

          return LayoutBuilder(
            builder: (context, constraints) {
              // Ensure zero overflow on any screen size
              final double maxRowWidth = constraints.maxWidth.clamp(0.0, 360.0);
              const double minGap = 6.0;
              final double calculatedBoxWidth =
                  ((maxRowWidth - (minGap * (otpLength - 1))) / otpLength)
                      .clamp(34.0, 48.0);
              final double boxHeight = (calculatedBoxWidth * 1.25).clamp(
                46.0,
                60.0,
              );

              return Center(
                child: SizedBox(
                  width: maxRowWidth,
                  child: GestureDetector(
                    onTap: () {
                      if (!cubit.otpFocusNode.hasFocus) {
                        cubit.otpFocusNode.requestFocus();
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Hidden TextFormField to handle keyboard, autofill, and paste
                        Opacity(
                          opacity: 0.0,
                          child: TextFormField(
                            controller: cubit.otpCodeController,
                            focusNode: cubit.otpFocusNode,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            autofillHints: const [AutofillHints.oneTimeCode],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(otpLength),
                            ],
                            onChanged: (_) => cubit.validateCode(),
                          ),
                        ),

                        // Beautiful discrete OTP boxes with spaceBetween
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(otpLength, (index) {
                              final bool isFilled = index < text.length;
                              final bool isCurrent = index == text.length;
                              final String char = isFilled ? text[index] : '';

                              Color borderColor;
                              Color backgroundColor;
                              List<BoxShadow> shadows = [];

                              if (isFilled) {
                                borderColor = ColorManger.iconsBackgroundColor
                                    .withValues(alpha: 0.8);
                                backgroundColor = ColorManger
                                    .iconsBackgroundColor
                                    .withValues(alpha: 0.35);
                                shadows = [
                                  BoxShadow(
                                    color: ColorManger.primary.withValues(
                                      alpha: 0.01,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ];
                              } else if (isCurrent) {
                                borderColor = ColorManger.primaryLight;
                                backgroundColor = ColorManger.primaryLight
                                    .withValues(alpha: 0.06);
                                shadows = [
                                  BoxShadow(
                                    color: ColorManger.primaryLight.withValues(
                                      alpha: 0.18,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ];
                              } else {
                                borderColor = ColorManger.primaryLight
                                    .withValues(alpha: 0.2);
                                backgroundColor = ColorManger.lightWhite;
                              }

                              return Container(
                                width: calculatedBoxWidth,
                                height: boxHeight,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: borderColor,
                                    width: isCurrent || isFilled ? 1.8 : 1.2,
                                  ),
                                  boxShadow: shadows,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  char,
                                  style: TextStyle(
                                    fontSize: responsive
                                        .setTextSize(5.2)
                                        .clamp(18.0, 24.0),
                                    fontWeight: FontWeight.bold,
                                    color: ColorManger.primary,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
