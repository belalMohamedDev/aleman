import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/order_details_cubit.dart';
import 'package:aleman/feature/order/cubit/order_details_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/order_details_timeline_widget.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/order_bank_transfer_flow_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderResponseModel order;
  final bool isParentMerchantView;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.isParentMerchantView = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderDetailsCubit(instance<OrderRepository>(), initialOrder: order)
            ..fetchOrderDetails(),
      child: _OrderDetailsView(isParentMerchantView: isParentMerchantView),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  final bool isParentMerchantView;

  const _OrderDetailsView({this.isParentMerchantView = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final order = state.order;
        final cubit = context.read<OrderDetailsCubit>();
        final bool isSmallMerchant = UserRoleHelper.isSmallMerchantSync();
        final bool isParent =
            !isSmallMerchant &&
            (isParentMerchantView || UserRoleHelper.isParentMerchantSync());

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context, state.isCancelledSuccessfully);
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF9F9FB),
            appBar: AppBar(
              title: const Text(
                'تفاصيل الطلب',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black87,
                ),
                onPressed: () =>
                    Navigator.pop(context, state.isCancelledSuccessfully),
              ),
              actions: [
                if (order.isPending)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: state.isCancelling
                            ? null
                            : () => _confirmCancelOrder(context, order, cubit),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: const Color(0xFFFCA5A5),
                              width: 1,
                            ),
                          ),
                          child: state.isCancelling
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFDC2626),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.close_circle,
                                      size: 15.sp,
                                      color: const Color(0xFFDC2626),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'إلغاء الطلب',
                                      style: TextStyle(
                                        color: const Color(0xFFDC2626),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeaderCard(context, order),
                  SizedBox(height: 14.h),

                  OrderDetailsTimelineWidget(order: order),
                  SizedBox(height: 14.h),

                  if (order.isBankTransfer) ...[
                    OrderBankTransferFlowWidget(
                      order: order,
                      onOrderUpdated: cubit.fetchOrderDetails,
                    ),
                    SizedBox(height: 14.h),
                  ],

                  _buildFulfillmentDetailsCard(order),
                  SizedBox(height: 14.h),

                  _buildInvoicePricingCard(order, isParent: isParent),
                  SizedBox(height: 20.h),

                  if (isSmallMerchant &&
                      (order.isPending ||
                          order.isPendingMerchantApproval ||
                          order.isPendingAdminApproval)) ...[
                    _buildCancelOrderSection(
                      context,
                      order,
                      cubit,
                      state.isCancelling,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: (isParent && order.isPendingMerchantApproval)
                ? _buildMerchantApprovalBottomBar(
                    context,
                    order,
                    cubit,
                    state.isCancelling,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildOrderHeaderCard(BuildContext context, OrderResponseModel order) {
    final orderCode = order.orderNumber.isNotEmpty
        ? order.orderNumber
        : order.id;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: ColorManger.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.bag_2, color: ColorManger.primary, size: 26.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الطلب',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '#$orderCode',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
                if (order.createdAt != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '${order.createdAt!.year}/${order.createdAt!.month}/${order.createdAt!.day} - ${_formatTime(order.createdAt!)}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Iconsax.copy,
              size: 20.sp,
              color: ColorManger.primaryLight,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: orderCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ رقم الطلب إلى الحافظة'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'نسخ رقم الطلب',
          ),
        ],
      ),
    );
  }

  Widget _buildFulfillmentDetailsCard(OrderResponseModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                order.isWesal ? Iconsax.card : Iconsax.building_3,
                color: ColorManger.primaryLight,
                size: 22.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                order.isWesal
                    ? 'تفاصيل توصيل وصال'
                    : 'تفاصيل استلام أرض المصنع',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primary,
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),

          if (order.isWesal) ...[
            _buildDetailRow(
              'طريقة الاستلام',
              'وصال (المصنع يتولى الشحن والتوصيل)',
            ),
            SizedBox(height: 8.h),
            _buildDetailRow(
              'نوع الشاحنة المعينة',
              order.truckName != null && order.truckName!.isNotEmpty
                  ? order.truckName!
                  : _getAssignedTruckFromWeight(order.totalWeightTons),
            ),
            if (order.addressText != null && order.addressText!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildDetailRow('عنوان التسليم', order.addressText!),
            ],
          ] else ...[
            _buildDetailRow(
              'طريقة الاستلام',
              'أرض المصنع (عربيات العميل الخاصة)',
            ),
            if (order.driverName != null && order.driverName!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildDetailRow('اسم السائق', order.driverName!),
            ],
            if (order.vehiclePlateNumber != null &&
                order.vehiclePlateNumber!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildDetailRow('رقم لوحة السيارة', order.vehiclePlateNumber!),
            ],
            if (order.driverLicenseNumber != null &&
                order.driverLicenseNumber!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildDetailRow(
                'رقم الرخصة / القومي',
                order.driverLicenseNumber!,
              ),
            ],
            if (order.expectedPickupDate != null) ...[
              SizedBox(height: 8.h),
              _buildDetailRow(
                'موعد التحميل المتوقع',
                '${order.expectedPickupDate!.year}/${order.expectedPickupDate!.month}/${order.expectedPickupDate!.day}',
              ),
            ],
          ],

          if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildDetailRow('ملاحظات العميل', order.notes!),
          ],
        ],
      ),
    );
  }

  Widget _buildInvoicePricingCard(
    OrderResponseModel order, {
    bool isParent = false,
  }) {
    final hidePrices = order.shouldHidePricing(
      isParentView: isParent || isParentMerchantView,
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.receipt_2,
                color: ColorManger.primaryLight,
                size: 22.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                hidePrices ? 'ملخص الطلب والأوزان' : 'ملخص الفاتورة والأوزان',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primary,
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),

          if (order.totalWeightTons > 0) ...[
            _buildDetailRow('إجمالي وزن الطلب', '${order.totalWeightTons} طن'),
            SizedBox(height: 8.h),
          ],
          if (!hidePrices) ...[
            _buildDetailRow('إجمالي سعر المنتجات', '${order.subTotal} ج.م'),
            if (order.discount > 0) ...[
              SizedBox(height: 8.h),
              _buildDetailRow(
                'قيمة الخصم',
                '- ${order.discount} ج.م',
                isDiscount: true,
              ),
            ],
            SizedBox(height: 8.h),
            order.shippingFee > 0
                ? _buildDetailRow(
                    'تكلفة الشحن والتوصيل',
                    '${order.shippingFee} ج.م',
                  )
                : const SizedBox.shrink(),
            SizedBox(height: 8.h),
          ],
          _buildDetailRow('طريقة السداد', order.paymentMethodName),
          if (!hidePrices) ...[
            Divider(height: 22.h, color: Colors.grey.shade200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي النهائي للطلب',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
                Text(
                  '${order.total} ج.م',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.goldDark,
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 16.sp,
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'تم اعتماد ومحاسبة هذا الطلب عبر التاجر الرئيسي والإدارة.',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.redAccent : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _getAssignedTruckFromWeight(double tons) {
    if (tons <= 2.0) return 'دبابة (حمولة حتى 2 طن)';
    if (tons <= 7.0) return 'جامبو (حمولة حتى 7 طن)';
    return 'تريلا (حمولة حتى 25 طن)';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'م' : 'ص';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Widget _buildCancelOrderSection(
    BuildContext context,
    OrderResponseModel order,
    OrderDetailsCubit cubit,
    bool isCancelling,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFFEE2E2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: Icon(
                  Iconsax.info_circle,
                  color: const Color(0xFFDC2626),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إلغاء الطلب',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'يمكنك إلغاء هذا الطلب طالما أنه لا يزال قيد المراجعة وقبل بدء التجهيز والتحميل بالمصنع.',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isCancelling
                  ? null
                  : () => _confirmCancelOrder(context, order, cubit),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                ),
                child: isCancelling
                    ? Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.close_circle,
                            size: 18.sp,
                            color: const Color(0xFFDC2626),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'طلب إلغاء الأوردر',
                            style: TextStyle(
                              color: const Color(0xFFDC2626),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancelOrder(
    BuildContext context,
    OrderResponseModel order,
    OrderDetailsCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),

            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFECDD3), width: 2),
              ),
              child: Icon(
                Iconsax.warning_2,
                color: const Color(0xFFDC2626),
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              'هل تريد بالتأكيد إلغاء هذا الطلب؟',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'طلب #${order.orderNumber.isNotEmpty ? order.orderNumber : order.id}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(height: 14.h),

            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.shield_cross,
                    color: const Color(0xFFD97706),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'عند التأكيد، سيتم إيقاف حجز المنتجات وجدولة التحميل فوراً، ولن تتمكن من التراجع عن هذا الإجراء.',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF92400E),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(bottomSheetContext),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'تراجع (احتفظ بالطلب)',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                        cubit.cancelOrder();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'تأكيد الإلغاء',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantApprovalBottomBar(
    BuildContext context,
    OrderResponseModel order,
    OrderDetailsCubit cubit,
    bool isProcessing,
  ) {
    final orderCode = order.orderNumber.isNotEmpty
        ? order.orderNumber
        : order.id;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  color: const Color(0xFFD97706),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'هذا الطلب من عميل فرعي وبانتظار موافقتك كتاجر رئيسي',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF92400E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            if (isProcessing)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF059669),
                    ),
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _confirmApprovalInDetails(context, orderCode, cubit),
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        'اعتماد الطلب',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showRejectDialogInDetails(context, orderCode, cubit),
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFDC2626),
                        size: 18,
                      ),
                      label: Text(
                        'رفض الطلب',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFDC2626),
                          width: 1.2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _confirmApprovalInDetails(
    BuildContext context,
    String orderCode,
    OrderDetailsCubit cubit,
  ) {
    showDialog(
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
          'هل أنت متأكد من اعتماد طلب العميل الفرعي رقم #$orderCode؟\nسيتم إرسال الطلب تلقائياً لإدارة ومبيعات المصنع لتأكيده وتجهيزه.',
          style: TextStyle(fontSize: 13.sp, height: 1.5, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await cubit.reviewOrder(isApproved: true);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'تم اعتماد الطلب بنجاح وإرساله للمبيعات'
                          : 'حدث خطأ أثناء اعتماد الطلب',
                    ),
                    backgroundColor: success
                        ? const Color(0xFF059669)
                        : Colors.red,
                  ),
                );
              }
            },
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
  }

  void _showRejectDialogInDetails(
    BuildContext context,
    String orderCode,
    OrderDetailsCubit cubit,
  ) {
    final reasonController = TextEditingController();
    showDialog(
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
              'الرجاء إدخال سبب الرفض للطلب رقم #$orderCode:',
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final reason = reasonController.text.trim();
              final success = await cubit.reviewOrder(
                isApproved: false,
                rejectionReason: reason.isEmpty ? null : reason,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'تم رفض الطلب بنجاح'
                          : 'حدث خطأ أثناء رفض الطلب',
                    ),
                    backgroundColor: success ? Colors.orange : Colors.red,
                  ),
                );
              }
            },
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
  }
}
