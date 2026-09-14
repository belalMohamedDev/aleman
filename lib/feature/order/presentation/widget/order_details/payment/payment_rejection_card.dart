import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PaymentRejectionCard extends StatelessWidget {
  final String? rejectionReason;
  final VoidCallback? onRetryUpload;

  const PaymentRejectionCard({
    super.key,
    this.rejectionReason,
    this.onRetryUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFFECACA)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.04),
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
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.close_circle,
                  color: const Color(0xFFDC2626),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'إيصال التحويل غير مطابق / مرفوض',
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            rejectionReason != null && rejectionReason!.isNotEmpty
                ? 'سبب الرفض: $rejectionReason'
                : 'تعذر تأكيد التحويل البنكي بواسطة الإدارة المالية. يرجى التأكد من المبلغ والمطابقة وإعادة رفع إيصال صحيح.',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF7F1D1D),
              height: 1.45,
            ),
          ),
          if (onRetryUpload != null) ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: onRetryUpload,
                icon: const Icon(Iconsax.document_upload, size: 16, color: Colors.white),
                label: Text(
                  'إعادة رفع إيصال تحويل صحيح',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
