import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _TimelineStepData {
  final String title;
  final int stepIndex;
  final String? subtitle;

  const _TimelineStepData({
    required this.title,
    required this.stepIndex,
    this.subtitle,
  });
}

class OrderDetailsTimelineWidget extends StatelessWidget {
  final OrderResponseModel order;

  const OrderDetailsTimelineWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallMerchant = order.isSmallMerchantOrder ||
        order.statusCode == 8 ||
        order.statusCode == 10 ||
        order.merchantApprovedAt != null ||
        order.merchantRejectionReason != null;

    final isBank = order.isBankTransfer;
    final List<_TimelineStepData> steps = _generateSteps(isSmallMerchant, isBank);

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
                'حالة ومسار الطلب',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Container(
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? Colors.red.shade700
                          : ColorManger.primaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),

          if (isCancelled)
            _buildCancellationCard()
          else
            Column(
              children: List.generate(steps.length, (index) {
                final step = steps[index];
                final stepProgress = _getStepProgress(
                  step.stepIndex,
                  isSmallMerchant,
                  isBank,
                );
                final currentProgress = _getOrderProgress(
                  currentStep,
                  isSmallMerchant,
                  isBank,
                );
                final isPassed = currentProgress >= stepProgress;
                final isCurrent = currentProgress == stepProgress;
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
                            height: (step.subtitle != null) ? 38.h : 28.h,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
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
                            if (step.subtitle != null &&
                                step.subtitle!.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                step.subtitle!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isPassed
                                      ? ColorManger.primaryLight
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ],
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

  List<_TimelineStepData> _generateSteps(bool isSmall, bool isBank) {
    if (isSmall) {
      if (isBank) {
        return [
          const _TimelineStepData(
            title: 'تقديم طلب العميل الفرعي',
            stepIndex: 1,
          ),
          _TimelineStepData(
            title: 'موافقة واعتماد التاجر الرئيسي',
            stepIndex: 8,
            subtitle: order.merchantApprovedAt != null
                ? 'تم الاعتماد بنجاح'
                : (order.isRejectedByMerchant
                    ? 'مرفوض من التاجر'
                    : 'بانتظار موافقة التاجر'),
          ),
          _TimelineStepData(
            title: 'اعتماد وتأكيد إدارة المصنع',
            stepIndex: 9,
            subtitle: (order.adminApprovedAt != null ||
                    order.statusCode == 2 ||
                    order.statusCode == 12 ||
                    order.isPaymentApproved)
                ? 'تم التأكيد والاعتماد'
                : (order.isRejectedByAdmin
                    ? 'مرفوض من الإدارة'
                    : (order.statusCode == 8
                        ? 'بعد موافقة التاجر'
                        : 'بانتظار تأكيد الإدارة')),
          ),
          _TimelineStepData(
            title: 'سداد ورفع إيصال التحويل البنكي',
            stepIndex: 20,
            subtitle: (order.paymentReceiptUrl != null &&
                    order.paymentReceiptUrl!.isNotEmpty)
                ? 'تم رفع الإيصال'
                : (order.isAwaitingPaymentReceipt
                    ? 'مطلوب تحويل المبلغ ورفع الإيصال'
                    : 'بعد اعتماد إدارة المصنع'),
          ),
          _TimelineStepData(
            title: 'مراجعة وتأكيد السداد من المالية',
            stepIndex: 21,
            subtitle: order.isPaymentApproved
                ? 'تم تأكيد السداد واعتماده'
                : (order.isPendingPaymentApproval
                    ? 'قيد التدقيق والمطابقة'
                    : 'بعد رفع إيصال السداد'),
          ),
          _TimelineStepData(
            title: order.isWesal
                ? 'خرج للتوصيل بشاحنة المصنع'
                : 'جاهز لتحميل سيارات العميل',
            stepIndex: 3,
            subtitle: order.isCompleted
                ? 'تم التسليم بنجاح'
                : (order.isPreparing
                    ? 'جاري التجهيز والتعبئة'
                    : 'بعد تأكيد السداد'),
          ),
        ];
      } else {
        return [
          const _TimelineStepData(
            title: 'تقديم طلب العميل الفرعي',
            stepIndex: 1,
          ),
          _TimelineStepData(
            title: 'موافقة واعتماد التاجر الرئيسي',
            stepIndex: 8,
            subtitle: order.merchantApprovedAt != null
                ? 'تم الاعتماد بنجاح'
                : (order.isRejectedByMerchant
                    ? 'مرفوض من التاجر'
                    : 'بانتظار موافقة التاجر'),
          ),
          _TimelineStepData(
            title: 'اعتماد وتأكيد إدارة المصنع',
            stepIndex: 9,
            subtitle: (order.adminApprovedAt != null || order.statusCode == 2)
                ? 'تم التأكيد والاعتماد'
                : (order.isRejectedByAdmin
                    ? 'مرفوض من الإدارة'
                    : (order.statusCode == 8
                        ? 'بعد موافقة التاجر'
                        : 'بانتظار تأكيد الإدارة')),
          ),
          _TimelineStepData(
            title: order.isWesal
                ? 'خرج للتوصيل بشاحنة المصنع'
                : 'جاهز لتحميل سيارات العميل',
            stepIndex: 3,
            subtitle: order.isCompleted
                ? 'تم التسليم بنجاح'
                : (order.isPreparing ? 'جاري التجهيز' : null),
          ),
        ];
      }
    } else {
      if (isBank) {
        return [
          _TimelineStepData(
            title: order.isWesal ? 'تقديم الطلب للمصنع' : 'تقديم طلب التحميل',
            stepIndex: 1,
          ),
          _TimelineStepData(
            title: 'مراجعة واعتماد إدارة المصنع',
            stepIndex: 9,
            subtitle: (order.adminApprovedAt != null ||
                    order.statusCode == 2 ||
                    order.statusCode == 12 ||
                    order.isPaymentApproved)
                ? 'تم الاعتماد بنجاح'
                : (order.isRejectedByAdmin
                    ? 'مرفوض من الإدارة'
                    : 'بانتظار تأكيد الإدارة'),
          ),
          _TimelineStepData(
            title: 'سداد ورفع إيصال التحويل البنكي',
            stepIndex: 20,
            subtitle: (order.paymentReceiptUrl != null &&
                    order.paymentReceiptUrl!.isNotEmpty)
                ? 'تم رفع الإيصال'
                : (order.isAwaitingPaymentReceipt
                    ? 'مطلوب تحويل المبلغ ورفع الإيصال'
                    : 'بعد اعتماد المصنع'),
          ),
          _TimelineStepData(
            title: 'مراجعة وتأكيد السداد من المالية',
            stepIndex: 21,
            subtitle: order.isPaymentApproved
                ? 'تم تأكيد السداد واعتماده'
                : (order.isPendingPaymentApproval
                    ? 'قيد التدقيق والمطابقة'
                    : 'بعد رفع إيصال السداد'),
          ),
          _TimelineStepData(
            title: order.isWesal
                ? 'خرج للتوصيل بشاحنة المصنع'
                : 'جاهز لتحميل سيارات العميل',
            stepIndex: 3,
            subtitle: order.isCompleted
                ? 'تم التسليم بنجاح'
                : (order.isPreparing
                    ? 'جاري التجهيز والتعبئة'
                    : 'بعد تأكيد السداد'),
          ),
        ];
      } else {
        return [
          _TimelineStepData(
            title: order.isWesal ? 'تقديم الطلب للمصنع' : 'تقديم طلب التحميل',
            stepIndex: 1,
          ),
          const _TimelineStepData(
            title: 'تم تأكيد واعتماد الطلب',
            stepIndex: 2,
          ),
          _TimelineStepData(
            title: order.isWesal
                ? 'خرج للتوصيل بشاحنة المصنع'
                : 'جاهز لتحميل سيارات العميل',
            stepIndex: 3,
            subtitle: order.isCompleted
                ? 'تم التسليم بنجاح'
                : (order.isPreparing ? 'جاري التجهيز' : null),
          ),
        ];
      }
    }
  }

  int _getOrderProgress(int statusCode, bool isSmall, bool isBank) {
    if (isSmall) {
      if (isBank) {
        if (statusCode == 8) return 1; // Waiting for merchant approval
        if (statusCode == 9) return 2; // Waiting for admin approval
        if (order.isAwaitingPaymentReceipt) return 3; // Waiting for payment receipt
        if (order.isPendingPaymentApproval) return 4; // Waiting for finance confirmation
        if (order.isPaymentApproved && (statusCode == 2 || statusCode == 12)) return 5;
        if (statusCode >= 3 && statusCode <= 6) return 6;
        return 1;
      } else {
        switch (statusCode) {
          case 8:
            return 1;
          case 9:
            return 2;
          case 2:
            return 3;
          case 3:
          case 4:
          case 5:
          case 6:
            return 4;
          default:
            return 1;
        }
      }
    } else {
      if (isBank) {
        if (statusCode == 1 || statusCode == 9) return 1; // Waiting for admin
        if (order.isAwaitingPaymentReceipt) return 2; // Waiting for payment receipt
        if (order.isPendingPaymentApproval) return 3; // Waiting for finance confirmation
        if (order.isPaymentApproved && (statusCode == 2 || statusCode == 12)) return 4;
        if (statusCode >= 3 && statusCode <= 6) return 5;
        return 1;
      } else {
        switch (statusCode) {
          case 1:
          case 9:
          case 8:
            return 1;
          case 2:
            return 2;
          case 3:
          case 4:
          case 5:
          case 6:
            return 3;
          default:
            return 1;
        }
      }
    }
  }

  int _getStepProgress(int stepIndex, bool isSmall, bool isBank) {
    if (isSmall) {
      if (isBank) {
        switch (stepIndex) {
          case 1:
            return 1;
          case 8:
            return 2;
          case 9:
            return 3;
          case 20:
            return 4;
          case 21:
            return 5;
          case 3:
            return 6;
          default:
            return 1;
        }
      } else {
        switch (stepIndex) {
          case 1:
            return 1;
          case 8:
            return 2;
          case 9:
            return 3;
          case 3:
            return 4;
          default:
            return 1;
        }
      }
    } else {
      if (isBank) {
        switch (stepIndex) {
          case 1:
            return 1;
          case 9:
            return 2;
          case 20:
            return 3;
          case 21:
            return 4;
          case 3:
            return 5;
          default:
            return 1;
        }
      } else {
        switch (stepIndex) {
          case 1:
            return 1;
          case 2:
            return 2;
          case 3:
            return 3;
          default:
            return 1;
        }
      }
    }
  }

  Widget _buildCancellationCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.cancel_outlined,
            color: Colors.red.shade700,
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.isRejectedByMerchant
                      ? 'تم رفض الطلب من قِبل التاجر الرئيسي'
                      : (order.isRejectedByAdmin
                          ? 'تم رفض الطلب من قِبل إدارة ومبيعات المصنع'
                          : 'تم إلغاء هذا الطلب'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                ),
                if (order.merchantRejectionReason != null &&
                    order.merchantRejectionReason!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'سبب الرفض: ${order.merchantRejectionReason}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
                if (order.adminRejectionReason != null &&
                    order.adminRejectionReason!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'سبب الرفض: ${order.adminRejectionReason}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
