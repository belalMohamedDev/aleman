import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class OrderAwaitingMerchantCard extends StatelessWidget {
  final String? parentMerchantName;

  const OrderAwaitingMerchantCard({
    super.key,
    this.parentMerchantName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.05),
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
                  color: const Color(0xFFD97706).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.user_tick,
                  color: const Color(0xFFD97706),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'الخطوة 1: بانتظار موافقة التاجر الرئيسي',
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Text(
                  'قيد المراجعة',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            parentMerchantName != null && parentMerchantName!.isNotEmpty
                ? 'طلبك الآن قيد المراجعة والاعتماد من التاجر الرئيسي ($parentMerchantName). بعد موافقة التاجر الرئيسي ثم إدارة المصنع، ستتمكن من تحويل المبلغ ورفع إيصال السداد.'
                : 'طلبك قيد المراجعة والاعتماد من التاجر الرئيسي التابع له. سيتم تفعيل سداد التحويل البنكي بعد اكتمال اعتمادات التاجر والمصنع.',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF78350F),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
