import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:aleman/feature/notification/logic/notification_state.dart';
import 'package:aleman/feature/notification/presentation/widget/empty_notifications_view.dart';
import 'package:aleman/feature/notification/presentation/widget/notification_card.dart';
import 'package:aleman/feature/notification/presentation/widget/notifications_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsBody extends StatelessWidget {
  final ScrollController? scrollController;

  const NotificationsBody({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.status == NotificationStatus.loading &&
            state.notifications.isEmpty) {
          return const NotificationsShimmerLoading();
        }

        if (state.status == NotificationStatus.error &&
            state.notifications.isEmpty) {
          return GlobalError(
            onRetry: () {
              context.read<NotificationCubit>().getNotifications(refresh: true);
            },
          );
        }

        if (state.notifications.isEmpty) {
          return EmptyNotificationsView(
            onRefresh: () {
              context.read<NotificationCubit>().getNotifications(refresh: true);
            },
          );
        }

        return RefreshIndicator(
          color: ColorManger.primaryLight,
          onRefresh: () async {
            await context.read<NotificationCubit>().getNotifications(
              refresh: true,
            );
          },
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
            itemCount:
                state.notifications.length +
                (state.status == NotificationStatus.loadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.notifications.length) {
                return NotificationCard(
                  notification: state.notifications[index],
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: ColorManger.primaryLight,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
