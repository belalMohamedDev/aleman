import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:aleman/feature/notification/logic/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NotificationBadgeIcon extends StatelessWidget {
  final Color? iconColor;
  final double? size;
  final VoidCallback? onTap;

  const NotificationBadgeIcon({
    super.key,
    this.iconColor,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (previous, current) =>
          previous.unreadCount != current.unreadCount,
      builder: (context, state) {
        final unreadCount = state.unreadCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Iconsax.notification,
                color: iconColor ?? ColorManger.primary,
                // size: size ?? 24.sp,
              ),
              onPressed:
                  onTap ??
                  () {
                    Navigator.of(context).pushNamed(Routes.notificationsRoute);
                  },
            ),

            if (unreadCount > 0)
              Positioned(
                top: 1.h,
                right: 2.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: ColorManger.redError,
                    shape: unreadCount > 9
                        ? BoxShape.rectangle
                        : BoxShape.circle,
                    borderRadius: unreadCount > 9
                        ? BorderRadius.circular(10.r)
                        : null,
                    border: Border.all(color: ColorManger.white, width: 1.5),
                  ),
                  constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                  child: Center(
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: getBoldStyle(
                        fontSize: 9.sp,
                        color: ColorManger.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
