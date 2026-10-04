import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EmptyNotificationsView extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyNotificationsView({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GlobalEmptyState(
      imageAsset: ImageAsset.notification,
      title: 'لا توجد إشعارات حالياً',
      description: 'ستظهر هنا جميع التنبيهات الخاصة بحالة طلباتك والعروض الحصرية فور وصولها.',
      buttonText: 'تحديث',
      buttonIcon: Iconsax.refresh,
      onButtonPressed: onRefresh,
    );
  }
}
