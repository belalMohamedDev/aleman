import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_cubit.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ResendCodeSection extends StatelessWidget {
  const ResendCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final cubit = context.read<ForgotPasswordCubit>();

    return BlocSelector<ForgotPasswordCubit, ForgotPasswordState, bool>(
      selector: (state) => state.status == ForgotPasswordStatus.loading,
      builder: (context, isLoading) {
        if (isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: ColorManger.primary,
                  ),
                ),
                SizedBox(width: responsive.setWidth(2)),
                Text(
                  context.translate(AppStrings.processing),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: responsive.setTextSize(3.6),
                    color: ColorManger.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ValueListenableBuilder<int>(
          valueListenable: cubit.resendCountdownNotifier,
          builder: (context, countdown, _) {
            final bool isRunning = countdown > 0;

            if (isRunning) {
              final minutes = (countdown ~/ 60).toString().padLeft(2, '0');
              final seconds = (countdown % 60).toString().padLeft(2, '0');

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: ColorManger.primaryLight.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.timer_1,
                      size: responsive.setTextSize(4.2),
                      color: ColorManger.primary,
                    ),
                    SizedBox(width: responsive.setWidth(2)),
                    Text(
                      context.translate(AppStrings.resendCodeIn),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: responsive.setTextSize(3.5),
                        color: ColorManger.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: responsive.setWidth(1.5)),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '$minutes:$seconds',
                        style: TextStyle(
                          fontSize: responsive.setTextSize(3.8),
                          fontWeight: FontWeight.bold,
                          color: ColorManger.primaryLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => cubit.resendCode(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.rotate_left,
                        size: responsive.setTextSize(4.2),
                        color: ColorManger.primary,
                      ),
                      SizedBox(width: responsive.setWidth(1.8)),
                      Text(
                        context.translate(AppStrings.resendCode),
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontSize: responsive.setTextSize(3.8),
                              color: ColorManger.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: ColorManger.primary,
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
    );
  }
}
