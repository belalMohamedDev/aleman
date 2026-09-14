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
        Text(
          'اختر طريقة الدفع',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 14.h),

        // Cash on delivery
        _buildMethodCard(
          method: PaymentMethodType.cashOnDelivery,
          title: 'الدفع عند الاستلام / التحميل',
          subtitle: 'الدفع نقداً عند استلام الطلب أو التحميل من المصنع',
          icon: Iconsax.money_tick,
        ),
        // SizedBox(height: 10.h),

        // // Card
        // _buildMethodCard(
        //   method: PaymentMethodType.card,
        //   title: 'بطاقة دفع إلكتروني (قريباً)',
        //   subtitle: 'الدفع بالفيزا أو ماستركارد عبر بوابة الدفع الإلكتروني',
        //   icon: Iconsax.card_pos,
        //   isAvailable: false,
        // ),
        SizedBox(height: 10.h),

        // Bank Transfer
        _buildMethodCard(
          method: PaymentMethodType.bankTransfer,
          title: 'تحويل بنكي / إيداع مباشر',
          subtitle: 'سداد المبلغ بالتحويل البنكي بعد اعتماد وموافقة إدارة المصنع',
          icon: Iconsax.bank,
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
        borderRadius: BorderRadius.circular(14.r),
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
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'آلية التحويل البنكي والاعتماد',
                  style: TextStyle(
                    fontSize: 13.5.sp,
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
            text: 'يتم مراجعة الطلب واعتماده (من التاجر الرئيسي إن كنت عميلاً فرعياً، ثم من إدارة المصنع).',
          ),
          SizedBox(height: 8.h),
          _buildNoticeBulletPoint(
            number: '3',
            text: 'بمجرد اعتماد الطلب، ستظهر لك بيانات حسابات المصنع البنكية في صفحة تفاصيل الطلب لتقوم بالتحويل ورفع الإيصال لتأكيد شحنته.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBulletPoint({required String number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          margin: EdgeInsets.only(top: 2.h),
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 11.sp,
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
              fontSize: 12.sp,
              color: const Color(0xFF14532D),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required PaymentMethodType method,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isAvailable = true,
  }) {
    final isSelected = selectedMethod == method;
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: isAvailable ? () => onMethodSelected(method) : null,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.04)
              : (isAvailable ? Colors.white : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? primary
                : (isAvailable ? Colors.grey.shade300 : Colors.grey.shade200),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? primary : Colors.grey.shade600,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isAvailable
                              ? (isSelected ? primary : Colors.black87)
                              : Colors.grey.shade400,
                        ),
                      ),
                      if (!isAvailable) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'قريباً',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isAvailable
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.shade400,
                  width: isSelected ? 6.r : 1.5.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
