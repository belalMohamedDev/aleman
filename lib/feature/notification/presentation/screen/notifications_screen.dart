import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:aleman/feature/notification/presentation/refactor/notifications_body.dart';

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
          icon: Icon(Iconsax.arrow_right_3, color: ColorManger.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'مركز الإشعارات',
          style: getBoldStyle(fontSize: 17.sp, color: ColorManger.primary),
        ),
        // actions: [
        //   BlocBuilder<NotificationCubit, NotificationState>(
        //     buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
        //     builder: (context, state) {
        //       if (state.unreadCount > 0) {
        //         return TextButton.icon(
        //           onPressed: () {
        //             context.read<NotificationCubit>().markAllAsRead();
        //           },
        //           icon: Icon(
        //             Icons.done_all,
        //             size: 16.sp,
        //             color: ColorManger.buttonColor,
        //           ),
        //           label: Text(
        //             'قراءة الكل',
        //             style: getBoldStyle(
        //               fontSize: 12.sp,
        //               color: ColorManger.buttonColor,
        //             ),
        //           ),
        //         );
        //       }
        //       return const SizedBox.shrink();
        //     },
        //   ),
        // ],
      ),
      body: NotificationsBody(scrollController: _scrollController),
    );
  }
}
