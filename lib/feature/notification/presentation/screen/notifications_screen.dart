import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:aleman/feature/notification/logic/notification_state.dart';
import 'package:aleman/feature/notification/presentation/widget/empty_notifications_view.dart';
import 'package:aleman/feature/notification/presentation/widget/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NotificationCubit>().getNotifications(refresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().getNotifications();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF8),
      appBar: AppBar(
        backgroundColor: ColorManger.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_right_3,
            color: ColorManger.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'مركز الإشعارات',
          style: getBoldStyle(
            fontSize: 17.sp,
            color: ColorManger.primary,
          ),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () {
                    context.read<NotificationCubit>().markAllAsRead();
                  },
                  icon: Icon(
                    Icons.done_all,
                    size: 16.sp,
                    color: ColorManger.buttonColor,
                  ),
                  label: Text(
                    'قراءة الكل',
                    style: getBoldStyle(
                      fontSize: 12.sp,
                      color: ColorManger.buttonColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading &&
              state.notifications.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorManger.buttonColor,
              ),
            );
          }

          if (state.status == NotificationStatus.error &&
              state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.warning_2,
                    size: 48.sp,
                    color: ColorManger.redError,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    state.errorMessage ?? 'تعذر تحميل الإشعارات',
                    style: getRegularStyle(
                      fontSize: 14.sp,
                      color: ColorManger.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NotificationCubit>()
                          .getNotifications(refresh: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.buttonColor,
                    ),
                    child: Text(
                      'إعادة المحاولة',
                      style: getBoldStyle(
                        fontSize: 13.sp,
                        color: ColorManger.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return EmptyNotificationsView(
              onRefresh: () {
                context
                    .read<NotificationCubit>()
                    .getNotifications(refresh: true);
              },
            );
          }

          return RefreshIndicator(
            color: ColorManger.buttonColor,
            onRefresh: () async {
              await context
                  .read<NotificationCubit>()
                  .getNotifications(refresh: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
              itemCount: state.notifications.length +
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
                        color: ColorManger.buttonColor,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
