import 'package:aleman/core/routing/notification_router.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NotificationDetailsBottomSheet extends StatelessWidget {
  final NotificationItemEntity notification;

  const NotificationDetailsBottomSheet({
    super.key,
    required this.notification,
  });

  static void show(BuildContext context, NotificationItemEntity notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NotificationDetailsBottomSheet(notification: notification),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String type = (notification.data['type'] ?? '').toString().toLowerCase();
    final bool hasAction = notification.data.isNotEmpty &&
        (notification.data.containsKey('orderId') ||
            notification.data.containsKey('order_id') ||
            notification.data.containsKey('productId') ||
            notification.data.containsKey('product_id') ||
            type == 'order' ||
            type == 'cart');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorManger.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44.w,
                height: 4.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // Header: Icon + Title + Close Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeadingIcon(type),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: getBoldStyle(
                          fontSize: 16.sp,
                          color: ColorManger.primary,
                        ),
                      ),
                      if (notification.createdAt != null) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              size: 13.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              _formatFullDateTime(notification.createdAt!),
                              style: getRegularStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: ColorManger.grey,
                  splashRadius: 20.r,
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(
                color: Colors.grey.shade200,
                thickness: 1,
                height: 1,
              ),
            ),

            // Body text
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: ColorManger.iconsBackgroundColor.withAlpha(50),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                notification.body,
                style: getRegularStyle(
                  fontSize: 13.5.sp,
                  color: ColorManger.primary,
                ).copyWith(height: 1.65),
              ),
            ),

            SizedBox(height: 20.h),

            // Action Button if notification contains related target
            if (hasAction) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    NotificationRouter.handleNavigation(notification.data);
                  },
                  icon: Icon(
                    type == 'cart' ? Iconsax.shopping_cart : Iconsax.arrow_circle_left,
                    color: ColorManger.white,
                    size: 18.sp,
                  ),
                  label: Text(
                    type == 'cart' ? 'الذهاب إلى السلة' : 'عرض التفاصيل المرتبطة',
                    style: getBoldStyle(
                      fontSize: 14.sp,
                      color: ColorManger.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.buttonColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],

            // Close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'إغلاق',
                  style: getBoldStyle(
                    fontSize: 13.sp,
                    color: ColorManger.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(String type) {
    IconData iconData = Iconsax.notification;
    Color iconColor = ColorManger.buttonColor;
    Color bgColor = ColorManger.iconsBackgroundColor;

    if (type.contains('order')) {
      iconData = Iconsax.box;
      iconColor = const Color(0xFF2E7D32);
      bgColor = const Color(0xFFE8F5E9);
    } else if (type.contains('promotion') || type.contains('discount')) {
      iconData = Iconsax.discount_shape;
      iconColor = const Color(0xFFE65100);
      bgColor = const Color(0xFFFFF3E0);
    }

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: 22.sp,
        ),
      ),
    );
  }

  String _formatFullDateTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'م' : 'ص';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}/${dt.month}/${dt.day} - $hour:$minute $period';
  }
}
