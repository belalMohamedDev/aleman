import 'package:aleman/feature/order/presentation/widget/order_details/payment/receipt_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PaymentApprovedCard extends StatelessWidget {
  final DateTime? approvedAt;
  final String? receiptUrl;

  const PaymentApprovedCard({
    super.key,
    this.approvedAt,
    this.receiptUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF86EFAC)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.05),
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
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم تأكيد السداد البنكي واعتماد الدفعة',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF166534),
                      ),
                    ),
                    if (approvedAt != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'تاريخ الاعتماد: ${approvedAt!.year}/${approvedAt!.month}/${approvedAt!.day}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (receiptUrl != null && receiptUrl!.isNotEmpty)
                IconButton(
                  onPressed: () => ReceiptPreviewDialog.show(context, imageUrl: receiptUrl),
                  icon: const Icon(Iconsax.receipt_item, color: Color(0xFF16A34A)),
                  tooltip: 'عرض الإيصال المعتمد',
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.truck_fast,
                  size: 16.sp,
                  color: const Color(0xFF16A34A),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'الطلب الآن مؤكد وجاري تعبئة وتجهيز الشحنة بالمصنع.',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF14532D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
