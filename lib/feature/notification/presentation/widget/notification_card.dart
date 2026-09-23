import 'package:aleman/core/routing/notification_router.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:aleman/feature/notification/logic/notification_state.dart';
import 'package:aleman/feature/notification/presentation/widget/notification_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItemEntity notification;

  const NotificationCard({super.key, required this.notification});

  String? _extractOrderId() {
    final rawId =
        notification.data['orderId'] ??
        notification.data['order_id'] ??
        notification.data['id'] ??
        notification.data['OrderId'];
    if (rawId != null &&
        rawId.toString().isNotEmpty &&
        rawId.toString() != '0') {
      return rawId.toString();
    }
    final text = '${notification.title} ${notification.body}';
    final regex = RegExp(
      r'#([A-Za-z0-9_-]+)|([A-Za-z0-9_-]+)#|رقم\s*[:#-]?\s*([A-Za-z0-9_-]+)',
    );
    final match = regex.firstMatch(text);
    if (match != null) {
      return match.group(1) ?? match.group(2) ?? match.group(3);
    }
    return null;
  }

  bool _isApprovalNotification(String? orderId) {
    if (orderId == null) return false;

    final data = notification.data;
    final type = (data['type'] ?? '').toString().toLowerCase();
    final action = (data['action'] ?? '').toString().toLowerCase();
    final status = (data['status'] ?? data['statusCode'] ?? '').toString();
    final requiresApproval =
        (data['requiresApproval'] ?? data['requires_approval'] ?? '')
            .toString()
            .toLowerCase();

    final title = notification.title.toLowerCase();
    final body = notification.body.toLowerCase();

    if (UserRoleHelper.isSmallMerchantSync()) return false;

    if (title.contains('طلبك') ||
        body.contains('طلبك') ||
        body.contains('بانتظار موافقة التاجر') ||
        body.contains('قيد موافقة التاجر')) {
      return false;
    }

    final isAlreadyDecided =
        title.contains('تم اعتماد') ||
        title.contains('تم قبول') ||
        title.contains('تم رفض') ||
        title.contains('تم تأكيد') ||
        body.contains('تم اعتماد') ||
        body.contains('تم قبول') ||
        body.contains('تم رفض') ||
        body.contains('تم تأكيد') ||
        data['isApproved'] == true ||
        data['isRejected'] == true ||
        data['actionTaken'] == true ||
        (status.isNotEmpty && status != '8' && status != '0');

    if (isAlreadyDecided) return false;

    final isApprovalType =
        type == 'merchant_approval' ||
        type == 'order_approval' ||
        type == 'small_merchant_order' ||
        action == 'approval' ||
        action == 'merchant_approval' ||
        status == '8' ||
        requiresApproval == 'true';

    final textHasApprovalKeyword =
        title.contains('موافقة') ||
        title.contains('موافقتك') ||
        title.contains('اعتماد') ||
        body.contains('موافقة') ||
        body.contains('موافقتك') ||
        body.contains('اعتماد');

    return isApprovalType || textHasApprovalKeyword;
  }

  Future<void> _confirmApproval(BuildContext context, String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: const Color(0xFF059669),
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'اعتماد الطلب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من اعتماد طلب العميل الفرعي رقم #$orderId؟\nسيتم إرسال الطلب تلقائياً لإدارة ومبيعات المصنع لتأكيده وتجهيزه.',
          style: TextStyle(fontSize: 13.sp, height: 1.5, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text(
              'تأكيد الاعتماد',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<NotificationCubit>().reviewOrder(
        orderId: orderId,
        notificationId: notification.id,
        isApproved: true,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'تم اعتماد الطلب بنجاح وإرساله لإدارة المبيعات'
                  : 'حدث خطأ أثناء اعتماد الطلب',
            ),
            backgroundColor: success ? const Color(0xFF059669) : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showRejectDialog(BuildContext context, String orderId) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'رفض الطلب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرجاء إدخال سبب الرفض للطلب رقم #$orderId:',
              style: TextStyle(fontSize: 13.sp, color: Colors.black87),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'سبب الرفض (اختياري)...',
                hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text(
              'تأكيد الرفض',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final reason = reasonController.text.trim();
      final success = await context.read<NotificationCubit>().reviewOrder(
        orderId: orderId,
        notificationId: notification.id,
        isApproved: false,
        rejectionReason: reason.isEmpty ? null : reason,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'تم رفض الطلب بنجاح' : 'حدث خطأ أثناء رفض الطلب',
            ),
            backgroundColor: success ? Colors.orange : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    final String type = (notification.data['type'] ?? '')
        .toString()
        .toLowerCase();
    final String? orderId = _extractOrderId();
    final bool isApproval = _isApprovalNotification(orderId);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isUnread ? ColorManger.primary.withAlpha(12) : ColorManger.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isApproval
              ? const Color(0xFFF59E0B).withAlpha(120)
              : isUnread
              ? ColorManger.buttonColor.withAlpha(80)
              : Colors.grey.withAlpha(30),
          width: isApproval ? 1.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isApproval
                ? const Color(0xFFF59E0B).withAlpha(20)
                : Colors.black.withAlpha(isUnread ? 12 : 6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            if (isUnread) {
              context.read<NotificationCubit>().markAsRead(notification.id);
            }

            final bool hasDirectTarget =
                type == 'order' ||
                type == 'order_status' ||
                type == 'merchant_approval' ||
                type == 'order_approval' ||
                type == 'cart' ||
                (orderId != null && orderId.isNotEmpty && type != 'product');

            if (hasDirectTarget && orderId != null) {
              NotificationRouter.handleNavigation({
                ...notification.data,
                'orderId': orderId,
                'type': 'order',
              });
            } else {
              NotificationDetailsBottomSheet.show(context, notification);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeadingIcon(type, isApproval),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: getBoldStyle(
                                fontSize: 14.sp,
                                color: ColorManger.primary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: 6.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: isApproval
                                    ? const Color(0xFFF59E0B)
                                    : ColorManger.buttonColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        notification.body,
                        style: getRegularStyle(
                          fontSize: 12.5.sp,
                          color: ColorManger.grey,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (notification.createdAt != null) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              size: 13.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _formatTime(notification.createdAt!),
                              style: getRegularStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (isApproval && orderId != null)
                        BlocBuilder<NotificationCubit, NotificationState>(
                          builder: (context, state) {
                            final isProcessing = state.processingOrderIds
                                .contains(orderId);
                            final actionStatus =
                                state.orderReviewStatuses[orderId];
                            return _buildActionButtons(
                              context,
                              orderId,
                              isProcessing,
                              actionStatus,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    String orderId,
    bool isProcessing,
    String? actionStatus,
  ) {
    if (actionStatus == 'approved') {
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF059669).withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF059669), size: 16),
            SizedBox(width: 6.w),
            Text(
              'تم اعتماد الطلب وإرساله للمبيعات',
              style: getBoldStyle(
                fontSize: 11.5.sp,
                color: const Color(0xFF059669),
              ),
            ),
          ],
        ),
      );
    }

    if (actionStatus == 'rejected') {
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, color: Colors.red, size: 16),
            SizedBox(width: 6.w),
            Text(
              'تم رفض الطلب',
              style: getBoldStyle(fontSize: 11.5.sp, color: Colors.red),
            ),
          ],
        ),
      );
    }

    if (isProcessing) {
      return Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'جاري معالجة الطلب...',
              style: getRegularStyle(fontSize: 11.5.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _confirmApproval(context, orderId),
              icon: const Icon(
                Icons.check_circle_outline,
                size: 15,
                color: Colors.white,
              ),
              label: Text(
                'اعتماد الطلب',
                style: getBoldStyle(fontSize: 11.5.sp, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showRejectDialog(context, orderId),
              icon: const Icon(
                Icons.cancel_outlined,
                size: 15,
                color: Color(0xFFDC2626),
              ),
              label: Text(
                'رفض الطلب',
                style: getBoldStyle(
                  fontSize: 11.5.sp,
                  color: const Color(0xFFDC2626),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(String type, bool isApproval) {
    if (isApproval) {
      return Container(
        width: 42.w,
        height: 42.w,
        decoration: const BoxDecoration(
          color: Color(0xFFFEF3C7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Iconsax.task_square,
            color: const Color(0xFFD97706),
            size: 20.sp,
          ),
        ),
      );
    }

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
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(iconData, color: iconColor, size: 20.sp),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
    }
  }
}
