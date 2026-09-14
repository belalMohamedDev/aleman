import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class OrderAwaitingAdminCard extends StatelessWidget {
  final bool isAfterMerchantApproval;

  const OrderAwaitingAdminCard({
    super.key,
    this.isAfterMerchantApproval = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.buildings,
                  color: const Color(0xFF2563EB),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  isAfterMerchantApproval
                      ? 'الخطوة 2: قيد مراجعة واعتماد إدارة المصنع'
                      : 'الخطوة 1: قيد مراجعة واعتماد إدارة المصنع',
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: const Color(0xFF93C5FD)),
                ),
                child: Text(
                  'قيد التدقيق',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D4ED8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            isAfterMerchantApproval
                ? 'تمت موافقة التاجر الرئيسي بنجاح! الطلب الآن معروض على إدارة المبيعات وتخطيط المصنع للاعتماد النهائي. فور الاعتماد، سيتاح لك سداد المبلغ ورفع إيصال التحويل.'
                : 'طلبك قيد المراجعة وتأكيد توفر الكميات لدى إدارة المصنع. بمجرد الاعتماد، ستظهر لك بيانات التحويل البنكي ورفع الإيصال لتجهيز الشحن.',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF1E3A8A),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
