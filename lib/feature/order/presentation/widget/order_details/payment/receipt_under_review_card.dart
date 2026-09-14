import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/receipt_preview_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ReceiptUnderReviewCard extends StatelessWidget {
  final String receiptUrl;
  final DateTime? uploadedAt;
  final VoidCallback? onReUploadRequested;

  const ReceiptUnderReviewCard({
    super.key,
    required this.receiptUrl,
    this.uploadedAt,
    this.onReUploadRequested,
  });

  String get _resolvedReceiptUrl {
    final trimmed = receiptUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '${ApiConstants.baseUrl}$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = _resolvedReceiptUrl;
    final isPdf = effectiveUrl.toLowerCase().split('?').first.endsWith('.pdf');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.04),
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
                  color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.clock,
                  color: const Color(0xFF16A34A),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم رفع الإيصال - قيد التدقيق المالي',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF166534),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'جاري مراجعة ومطابقة التحويل البنكي من الإدارة المالية بالمصنع',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Text(
                  'قيد المراجعة',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Receipt thumbnail and view button
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => ReceiptPreviewDialog.show(context, imageUrl: effectiveUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      color: isPdf ? const Color(0xFFFEE2E2) : Colors.grey.shade100,
                      child: isPdf
                          ? const Icon(Iconsax.document_text5, color: Color(0xFFDC2626))
                          : CachedNetworkImage(
                              imageUrl: effectiveUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.receipt, color: Colors.grey),
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPdf ? 'إيصال التحويل (مستند PDF)' : 'صورة إيصال التحويل البنكي',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (uploadedAt != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'تاريخ الرفع: ${uploadedAt!.year}/${uploadedAt!.month}/${uploadedAt!.day}',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => ReceiptPreviewDialog.show(context, imageUrl: effectiveUrl),
                  icon: Icon(Iconsax.eye, size: 16.sp, color: ColorManger.primaryLight),
                  label: Text(
                    'معاينة',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManger.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onReUploadRequested != null) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onReUploadRequested,
                icon: Icon(Iconsax.refresh, size: 15.sp, color: Colors.grey.shade700),
                label: Text(
                  'استبدال الإيصال المرفوع',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
