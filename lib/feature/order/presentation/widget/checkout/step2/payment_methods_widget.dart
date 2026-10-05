import 'dart:io';

import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class PaymentMethodsWidget extends StatelessWidget {
  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onMethodSelected;
  final File? receiptFile;
  final String? paymentReceiptUrl;
  final bool isUploadingReceipt;
  final ValueChanged<ImageSource> onPickReceipt;
  final VoidCallback onPickReceiptPdf;
  final VoidCallback onRemoveReceipt;
  final double totalAmount;

  const PaymentMethodsWidget({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
    this.receiptFile,
    this.paymentReceiptUrl,
    this.isUploadingReceipt = false,
    required this.onPickReceipt,
    required this.onPickReceiptPdf,
    required this.onRemoveReceipt,
    this.totalAmount = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'طريقة الدفع',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        SizedBox(height: 10.h),

        // Grouped Payment Cards
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: [
              _buildMethodRow(
                method: PaymentMethodType.cashOnDelivery,
                title: 'الدفع عند الاستلام / التحميل',
                subtitle: 'الدفع نقداً عند استلام الطلب أو التحميل من المصنع',
                icon: Iconsax.money_tick,
                isFirst: true,
                isLast: false,
              ),
              Divider(
                height: 1,
                indent: 52.w,
                endIndent: 16.w,
                color: Colors.grey.shade100,
              ),
              _buildMethodRow(
                method: PaymentMethodType.bankTransfer,
                title: 'تحويل بنكي / إيداع مباشر',
                subtitle:
                    'سداد المبلغ بالتحويل البنكي بعد اعتماد وموافقة إدارة المصنع',
                icon: Iconsax.bank,
                isFirst: false,
                isLast: true,
              ),
            ],
          ),
        ),

        // Notice Section (visible only when Bank Transfer is selected)
        if (selectedMethod == PaymentMethodType.bankTransfer) ...[
          SizedBox(height: 14.h),
          _buildBankTransferNoticeSection(),
        ],
      ],
    );
  }

  Widget _buildBankTransferNoticeSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Iconsax.info_circle,
                  color: const Color(0xFF16A34A),
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'آلية التحويل البنكي والاعتماد',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildNoticeBulletPoint(
            number: '1',
            text: 'يتم تقديم الطلب أولاً دون الحاجة لرفع إيصال تحويل الآن.',
          ),
          SizedBox(height: 8.h),
          _buildNoticeBulletPoint(
            number: '2',
            text:
                'يتم مراجعة الطلب واعتماده (من التاجر الرئيسي ثم من إدارة المصنع).',
          ),
          SizedBox(height: 8.h),
          _buildNoticeBulletPoint(
            number: '3',
            text:
                'بمجرد اعتماد الطلب، ستظهر لك بيانات الحسابات البنكية لرفع الإيصال وتأكيد الشحنة.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBulletPoint({
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          margin: EdgeInsets.only(top: 2.h),
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF166534),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.5.sp,
              color: const Color(0xFF14532D),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodRow({
    required PaymentMethodType method,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isFirst,
    required bool isLast,
  }) {
    final isSelected = selectedMethod == method;
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: () => onMethodSelected(method),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(16.r) : Radius.zero,
        bottom: isLast ? Radius.circular(16.r) : Radius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? primary : Colors.grey.shade600,
                size: 20.sp,
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
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF0F172A)
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.shade300,
                  width: 1.5,
                ),
                color: isSelected ? primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
