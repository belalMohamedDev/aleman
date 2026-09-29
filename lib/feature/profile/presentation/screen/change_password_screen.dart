import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_cubit.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_state.dart';
import 'package:aleman/feature/profile/presentation/widget/change_password/change_password_button.dart';
import 'package:aleman/feature/profile/presentation/widget/change_password/change_password_header.dart';
import 'package:aleman/feature/profile/presentation/widget/change_password/confirm_password_field.dart';
import 'package:aleman/feature/profile/presentation/widget/change_password/current_password_field.dart';
import 'package:aleman/feature/profile/presentation/widget/change_password/new_password_field.dart';
import 'package:aleman/feature/profile/presentation/widget/change_password/password_requirement_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => instance<ChangePasswordCubit>(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'تغيير كلمة المرور',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listenWhen: (prev, current) => prev.status != current.status,
          listener: (context, state) {
            if (state.status == ChangePasswordStatus.error) {
              AppToast.showError(
                context,
                message: state.errorMessage ?? 'حدث خطأ أثناء تغيير كلمة المرور',
              );
            } else if (state.status == ChangePasswordStatus.success) {
              AppToast.showSuccess(
                context,
                message:
                    state.successMessage ?? 'تم تغيير كلمة المرور بنجاح',
              );
              Navigator.of(context).maybePop();
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ChangePasswordHeader(),
                  SizedBox(height: 24.h),
                  const PasswordRequirementCard(),
                  SizedBox(height: 24.h),
                  const CurrentPasswordField(),
                  SizedBox(height: 16.h),
                  const NewPasswordField(),
                  SizedBox(height: 16.h),
                  const ConfirmPasswordField(),
                  SizedBox(height: 32.h),
                  const ChangePasswordButton(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
