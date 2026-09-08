// ignore_for_file: deprecated_member_use

import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodsWidget extends StatelessWidget {
  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onMethodSelected;

  const PaymentMethodsWidget({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر طريقة الدفع',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 20.h),
        _buildMethodCard(
          method: PaymentMethodType.cashOnDelivery,
          title: 'الدفع عند الاستلام / التحميل',
          subtitle: 'الدفع نقداً أو شيك مقبول الدفع عند استلام البضاعة',
          icon: Icons.payments_outlined,
        ),
        SizedBox(height: 15.h),
        _buildMethodCard(
          method: PaymentMethodType.card,
          title: 'بطاقة ائتمان أو خصم مباشر',
          subtitle: 'فيزا، ماستركارد، أو ميزة (قريباً)',
          icon: Icons.credit_card_outlined,
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required PaymentMethodType method,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedMethod == method;
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: () => onMethodSelected(method),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade300,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? primary : Colors.grey.shade700,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primary : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PaymentMethodType>(
              value: method,
              groupValue: selectedMethod,
              onChanged: (_) => onMethodSelected(method),
              activeColor: primary,
            ),
          ],
        ),
      ),
    );
  }
}
