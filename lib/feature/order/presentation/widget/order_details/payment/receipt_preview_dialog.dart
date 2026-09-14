import 'dart:io';
import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ReceiptPreviewDialog extends StatelessWidget {
  final String? imageUrl;
  final File? file;

  const ReceiptPreviewDialog({
    super.key,
    this.imageUrl,
    this.file,
  });

  static void show(BuildContext context, {String? imageUrl, File? file}) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => ReceiptPreviewDialog(imageUrl: imageUrl, file: file),
    );
  }

  String get _resolvedImageUrl {
    if (imageUrl == null || imageUrl!.trim().isEmpty) return '';
    final trimmed = imageUrl!.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '${ApiConstants.baseUrl}$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = _resolvedImageUrl;
    final isPdf = (file?.path.toLowerCase().endsWith('.pdf') ?? false) ||
        (effectiveUrl.toLowerCase().split('?').first.endsWith('.pdf'));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18.r,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, color: Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            constraints: BoxConstraints(maxHeight: 520.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: isPdf
                ? Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.document_text5,
                          size: 72.sp,
                          color: const Color(0xFFDC2626),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'مستند إيصال التحويل (PDF)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          file != null
                              ? file!.path.split(RegExp(r'[/\\]')).last
                              : 'تم إرفاق الإيصال بصيغة PDF',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : (file != null
                    ? Image.file(file!, fit: BoxFit.contain)
                    : (effectiveUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: effectiveUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.w),
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Padding(
                              padding: EdgeInsets.all(30.w),
                              child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                            ),
                          )
                        : const SizedBox.shrink())),
          ),
        ],
      ),
    );
  }
}
