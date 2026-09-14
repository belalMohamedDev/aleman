import 'dart:io';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/order_payment_cubit.dart';
import 'package:aleman/feature/order/cubit/order_payment_state.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/receipt_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptUploadActionCard extends StatelessWidget {
  final VoidCallback? onUploadSuccess;

  const ReceiptUploadActionCard({
    super.key,
    this.onUploadSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderPaymentCubit, OrderPaymentState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<OrderPaymentCubit>().clearMessages();
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: const Color(0xFF059669),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<OrderPaymentCubit>().clearMessages();
          if (onUploadSuccess != null) {
            onUploadSuccess!();
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrderPaymentCubit>();

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
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Iconsax.receipt_add,
                      color: ColorManger.primaryLight,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إرفاق إيصال التحويل البنكي',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManger.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'يرجى تصوير أو إرفاق إشعار التحويل البنكي للمراجعة',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              if (state.selectedFile == null) ...[
                _buildPickerOptions(context, cubit),
              ] else ...[
                _buildSelectedFilePreview(context, cubit, state.selectedFile!),
                SizedBox(height: 14.h),
                _buildSubmitButton(context, cubit, state.isUploading),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOptions(BuildContext context, OrderPaymentCubit cubit) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPickerButton(
                icon: Iconsax.camera,
                label: 'التقاط صورة',
                color: const Color(0xFF0284C7),
                onTap: () => cubit.pickImageReceipt(ImageSource.camera),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildPickerButton(
                icon: Iconsax.gallery,
                label: 'من المعرض',
                color: const Color(0xFF7C3AED),
                onTap: () => cubit.pickImageReceipt(ImageSource.gallery),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildPickerButton(
                icon: Iconsax.document_upload,
                label: 'مستند PDF',
                color: const Color(0xFFDC2626),
                onTap: () => cubit.pickPdfReceipt(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFilePreview(
    BuildContext context,
    OrderPaymentCubit cubit,
    File file,
  ) {
    final fileName = file.path.split(RegExp(r'[/\\]')).last;
    final isPdf = file.path.toLowerCase().endsWith('.pdf');

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => ReceiptPreviewDialog.show(context, file: file),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 44.w,
                height: 44.w,
                color: isPdf ? const Color(0xFFFEE2E2) : Colors.grey.shade200,
                child: isPdf
                    ? const Icon(Iconsax.document_text5, color: Color(0xFFDC2626))
                    : Image.file(file, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'انقر لمعاينة الإيصال قبل الإرسال',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Iconsax.trash,
              size: 18.sp,
              color: Colors.red.shade400,
            ),
            onPressed: cubit.clearSelectedFile,
            tooltip: 'حذف واختيار ملف آخر',
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    OrderPaymentCubit cubit,
    bool isUploading,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton.icon(
        onPressed: isUploading ? null : () => cubit.uploadReceipt(),
        icon: isUploading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Iconsax.send_2, color: Colors.white, size: 18),
        label: Text(
          isUploading ? 'جاري رفع الإيصال...' : 'تأكيد وإرسال الإيصال للمصنع',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManger.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
