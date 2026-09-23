import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/app_regex.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NewPasswordTextFormField extends StatelessWidget {
  const NewPasswordTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();

        return TextFormField(
          controller: cubit.userNewPasswordController,
          obscureText: state.showNewPassword,
          onChanged: (value) => cubit.validateNewPassword(),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorManger.authTitleDark,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !AppRegex.isPasswordValid(value)) {
              return context.translate(AppStrings.pleaseEnterValidPassword);
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'كلمة المرور الجديدة',
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: ColorManger.authHintGrey,
            ),
            filled: true,
            fillColor: ColorManger.authFieldBg,
            prefixIcon: Icon(
              Iconsax.lock,
              color: ColorManger.authIconColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: cubit.toggleNewPasswordVisibility,
              icon: Icon(
                state.showNewPassword ? Iconsax.eye_slash : Iconsax.eye,
                color: ColorManger.authIconColor,
                size: 20,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: ColorManger.authFieldBorder,
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: ColorManger.authFieldBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: ColorManger.primaryLight,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: ColorManger.redError,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: ColorManger.redError,
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
