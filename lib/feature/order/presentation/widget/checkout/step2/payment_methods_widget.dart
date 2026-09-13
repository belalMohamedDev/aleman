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
          subtitle: 'قم بتحويل المبلغ وإرفاق إيصال التحويل (صورة أو PDF)',
          icon: Iconsax.bank,
        ),

        // Receipt Upload Section (visible only when Bank Transfer is selected)
        if (selectedMethod == PaymentMethodType.bankTransfer) ...[
          SizedBox(height: 16.h),
          _buildReceiptUploadSection(context),
        ],
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

  Widget _buildReceiptUploadSection(BuildContext context) {
    final primary = ColorManger.primaryLight;
    final hasReceipt = paymentReceiptUrl != null || receiptFile != null;
    final isPdf =
        (receiptFile?.path.toLowerCase().endsWith('.pdf') ?? false) ||
        (paymentReceiptUrl?.toLowerCase().split('?').first.endsWith('.pdf') ??
            false);
    final fileName = receiptFile != null
        ? receiptFile!.path.split(RegExp(r'[/\\]')).last
        : (isPdf ? 'إيصال_التحويل.pdf' : 'جاهز للإرسال مع الطلب');

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.receipt_item, color: primary, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'إرفاق إيصال التحويل البنكي',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: hasReceipt
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: hasReceipt
                        ? Colors.green.shade200
                        : Colors.orange.shade200,
                  ),
                ),
                child: Text(
                  hasReceipt ? 'مرفق ومطابق' : 'مطلوب للمتابعة',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: hasReceipt
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Upload state or Preview
          if (isUploadingReceipt)
            Container(
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'جاري رفع وفحص الإيصال...',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ],
              ),
            )
          else if (hasReceipt)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: [
                  if (receiptFile != null) ...[
                    if (isPdf)
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red.shade700,
                            size: 24.sp,
                          ),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.file(
                          receiptFile!,
                          width: 44.w,
                          height: 44.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(width: 10.w),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: isPdf
                            ? Colors.red.shade50
                            : Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPdf ? Icons.picture_as_pdf : Iconsax.tick_circle,
                        color: isPdf
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isPdf
                                  ? 'تم إرفاق مستند PDF'
                                  : 'تم إرفاق الإيصال بنجاح',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                            if (isPdf) ...[
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'PDF',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onRemoveReceipt,
                    icon: Icon(
                      Iconsax.trash,
                      size: 18.sp,
                      color: Colors.red.shade400,
                    ),
                    tooltip: 'حذف الإيصال',
                  ),
                ],
              ),
            )
          else
            InkWell(
              onTap: () => _showPickerBottomSheet(context),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFC),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.document_upload,
                        size: 26.sp,
                        color: primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'اضغط هنا لإرفاق إيصال التحويل',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'التقاط بالكاميرا، من المعرض، أو ملف PDF (حتى 10MB)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'اختيار إيصال التحويل',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Iconsax.camera,
                      color: ColorManger.primaryLight,
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    'التقاط صورة بالكاميرا',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickReceipt(ImageSource.camera);
                  },
                ),
                SizedBox(height: 8.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Iconsax.gallery,
                      color: ColorManger.primaryLight,
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    'اختيار صورة من المعرض',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickReceipt(ImageSource.gallery);
                  },
                ),
                SizedBox(height: 8.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Colors.red.shade700,
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    'اختيار مستند PDF',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'ملفات المستندات والفواتير بصيغة PDF',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickReceiptPdf();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
