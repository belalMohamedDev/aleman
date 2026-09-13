import 'package:aleman/core/routing/notification_router.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:aleman/feature/notification/logic/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NotificationDetailsBottomSheet extends StatelessWidget {
  final NotificationItemEntity notification;

  const NotificationDetailsBottomSheet({super.key, required this.notification});

  static void show(BuildContext context, NotificationItemEntity notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<NotificationCubit>(),
        child: NotificationDetailsBottomSheet(notification: notification),
      ),
    );
  }

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
    final regex = RegExp(r'#([A-Za-z0-9_-]+)|([A-Za-z0-9_-]+)#|رقم\s*[:#-]?\s*([A-Za-z0-9_-]+)');
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

    // العميل الفرعي لا يوافق ولا يعتمد الطلبات
    if (UserRoleHelper.isSmallMerchantSync()) return false;

    // إذا كان الإشعار موجهاً لصاحب الطلب نفسه لإخباره بحالة طلبه
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
            const Text(
              'اعتماد الطلب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من اعتماد طلب العميل الفرعي رقم #$orderId؟\nسيتم إرسال الطلب تلقائياً لإدارة ومبيعات المصنع لتأكيده وتجهيزه.',
          style: TextStyle(fontSize: 13.sp, height: 1.5, color: Colors.black),
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
            const Text(
              'رفض الطلب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
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
              style: TextStyle(fontSize: 13.sp),
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
    final String type = (notification.data['type'] ?? '')
        .toString()
        .toLowerCase();
    final String? orderId = _extractOrderId();
    final bool isApproval = _isApprovalNotification(orderId);

    final bool hasAction =
        notification.data.isNotEmpty &&
        (orderId != null ||
            notification.data.containsKey('productId') ||
            notification.data.containsKey('product_id') ||
            type == 'order' ||
            type == 'cart');

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final isProcessing =
            orderId != null && state.processingOrderIds.contains(orderId);
        final actionStatus = orderId != null
            ? state.orderReviewStatuses[orderId]
            : null;

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
                    _buildLeadingIcon(type, isApproval),
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

                // Merchant Approval Actions
                if (isApproval && orderId != null) ...[
                  _buildApprovalSection(
                    context,
                    orderId,
                    isProcessing,
                    actionStatus,
                  ),
                  SizedBox(height: 12.h),
                ],

                // Action Button if notification contains related target
                if (hasAction && actionStatus == null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        NotificationRouter.handleNavigation({
                          ...notification.data,
                          if (orderId != null) ...{
                            'orderId': orderId,
                            'type': 'order',
                          },
                        });
                      },
                      icon: Icon(
                        type == 'cart'
                            ? Iconsax.shopping_cart
                            : Iconsax.arrow_circle_left,
                        color: ColorManger.white,
                        size: 18.sp,
                      ),
                      label: Text(
                        type == 'cart'
                            ? 'الذهاب إلى السلة'
                            : isApproval
                            ? 'عرض تفاصيل الطلب بالكامل'
                            : 'عرض التفاصيل المرتبطة',
                        style: getBoldStyle(
                          fontSize: 14.sp,
                          color: ColorManger.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApproval
                            ? ColorManger.primary
                            : ColorManger.buttonColor,
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
      },
    );
  }

  Widget _buildApprovalSection(
    BuildContext context,
    String orderId,
    bool isProcessing,
    String? actionStatus,
  ) {
    if (actionStatus == 'approved') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF059669).withAlpha(80)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF059669), size: 22),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'تم اعتماد الطلب بنجاح وإرساله لإدارة المبيعات',
                style: getBoldStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (actionStatus == 'rejected') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.red.withAlpha(80)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: Colors.red, size: 22),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'تم رفض الطلب بنجاح',
                style: getBoldStyle(fontSize: 13.sp, color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    if (isProcessing) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'جاري معالجة قرارك بالطلب...',
              style: getRegularStyle(fontSize: 13.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmApproval(context, orderId),
            icon: const Icon(
              Icons.check_circle_outline,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              'اعتماد الطلب',
              style: getBoldStyle(fontSize: 13.sp, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showRejectDialog(context, orderId),
            icon: const Icon(
              Icons.cancel_outlined,
              size: 18,
              color: Color(0xFFDC2626),
            ),
            label: Text(
              'رفض الطلب',
              style: getBoldStyle(
                fontSize: 13.sp,
                color: const Color(0xFFDC2626),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDC2626), width: 1.4),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeadingIcon(String type, bool isApproval) {
    if (isApproval) {
      return Container(
        width: 44.w,
        height: 44.w,
        decoration: const BoxDecoration(
          color: Color(0xFFFEF3C7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Iconsax.task_square,
            color: const Color(0xFFD97706),
            size: 22.sp,
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
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(iconData, color: iconColor, size: 22.sp),
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
