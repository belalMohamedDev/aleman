import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/order_details_cubit.dart';
import 'package:aleman/feature/order/cubit/order_details_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderResponseModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderDetailsCubit(
        instance<OrderRepository>(),
        initialOrder: order,
      )..fetchOrderDetails(),
      child: const _OrderDetailsView(),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView();

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
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                onPressed: () => Navigator.pop(context, state.isCancelledSuccessfully),
              ),
              actions: [
                if (order.isPending)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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

                  _buildTimelineCard(order),
                  SizedBox(height: 14.h),

                  _buildFulfillmentDetailsCard(order),
                  SizedBox(height: 14.h),

                  _buildInvoicePricingCard(order),
                  SizedBox(height: 20.h),

                  if (order.isPending) ...[
                    _buildCancelOrderSection(context, order, cubit, state.isCancelling),
                    SizedBox(height: 16.h),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderHeaderCard(BuildContext context, OrderResponseModel order) {
    final orderCode = order.orderNumber.isNotEmpty ? order.orderNumber : order.id;

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

  Widget _buildTimelineCard(OrderResponseModel order) {
    final steps = order.isWesal
        ? [
            const _TimelineStepData(title: 'تم تقديم الطلب للمصنع', stepIndex: 1),
            const _TimelineStepData(title: 'تم تأكيد الطلب واعتماده', stepIndex: 2),
            const _TimelineStepData(title: 'جاري تعبئة وتجهيز الأعلاف', stepIndex: 3),
            const _TimelineStepData(title: 'خرج للتوصيل بشاحنة المصنع', stepIndex: 4),
            const _TimelineStepData(title: 'تم تسليم الطلب للعميل', stepIndex: 6),
          ]
        : [
            const _TimelineStepData(title: 'تم تقديم طلب التحميل', stepIndex: 1),
            const _TimelineStepData(title: 'تم تأكيد الطلب واعتماده', stepIndex: 2),
            const _TimelineStepData(
              title: 'جاري التجهيز والوزن على الميزان',
              stepIndex: 3,
            ),
            const _TimelineStepData(title: 'جاهز لتحميل سيارات العميل', stepIndex: 5),
            const _TimelineStepData(
              title: 'تم الاستلام والتحميل بنجاح',
              stepIndex: 6,
            ),
          ];

    final currentStep = order.statusCode;
    final isCancelled = order.isCancelled;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حالة الطلب',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? Colors.red.shade50
                      : ColorManger.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isCancelled
                        ? Colors.red.shade200
                        : ColorManger.primaryLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isCancelled
                        ? Colors.red.shade700
                        : ColorManger.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),

          if (isCancelled)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    color: Colors.red.shade700,
                    size: 22.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'تم إلغاء هذا الطلب ولا يمكن متابعة إجراءات تجهيزه أو تسليمه.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: List.generate(steps.length, (index) {
                final step = steps[index];
                final isPassed = currentStep >= step.stepIndex;
                final isCurrent = currentStep == step.stepIndex;
                final isLast = index == steps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPassed
                                ? ColorManger.primaryLight
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isCurrent
                                  ? ColorManger.primaryLight
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isPassed ? Icons.check : Icons.circle,
                            size: isPassed ? 14.sp : 8.sp,
                            color: isPassed
                                ? Colors.white
                                : Colors.grey.shade400,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2.w,
                            height: 28.h,
                            color: isPassed
                                ? ColorManger.primaryLight
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : (isPassed
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            color: isCurrent
                                ? ColorManger.primary
                                : (isPassed
                                      ? Colors.black87
                                      : Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
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
            if (order.addressText != null &&
                order.addressText!.isNotEmpty) ...[
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

  Widget _buildInvoicePricingCard(OrderResponseModel order) {
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
                'ملخص الفاتورة والأوزان',
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
          _buildDetailRow('طريقة السداد', order.paymentMethodName),
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
              onTap: isCancelling ? null : () => _confirmCancelOrder(context, order, cubit),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFFCA5A5),
                    width: 1,
                  ),
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
            // مقبض السحب
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),

            // أيقونة التحذير
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

            // لافتة تنبيه
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

            // أزرار التحكم
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
}

class _TimelineStepData {
  final String title;
  final int stepIndex;

  const _TimelineStepData({required this.title, required this.stepIndex});
}
