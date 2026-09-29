import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_cubit.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangePasswordCubit>();

    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, current) =>
          prev.showConfirmPassword != current.showConfirmPassword,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تأكيد كلمة المرور الجديدة',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: cubit.confirmPasswordController,
              obscureText: !state.showConfirmPassword,
              onChanged: (_) => cubit.validateFields(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى تأكيد كلمة المرور الجديدة';
                }
                if (value != cubit.newPasswordController.text) {
                  return 'كلمة المرور غير متطابقة';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'أعد إدخال كلمة المرور الجديدة',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: Icon(
                  Iconsax.lock,
                  size: 20.sp,
                  color: Colors.grey.shade500,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.showConfirmPassword
                        ? Iconsax.eye
                        : Iconsax.eye_slash,
                    size: 20.sp,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: cubit.toggleConfirmPasswordVisibility,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: ColorManger.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
