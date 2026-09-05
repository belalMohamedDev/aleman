import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeTextFormField extends StatelessWidget {
  const VerifyCodeTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();

        return AutofillGroup(
          child: Container(
            decoration: BoxDecoration(
              color: ColorManger.primaryLight.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: cubit.otpCodeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: TextStyle(
                fontSize: responsive.setTextSize(6),
                letterSpacing: 14.0,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '------',
                hintStyle: TextStyle(
                  fontSize: responsive.setTextSize(6),
                  letterSpacing: 14.0,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: responsive.setHeight(2),
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: ColorManger.primaryLight.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: ColorManger.primary,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => cubit.validateCode(),
            ),
          ),
        );
      },
    );
  }
}
