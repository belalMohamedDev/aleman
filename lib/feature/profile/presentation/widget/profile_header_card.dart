import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String role;
  final String? phoneNumber;
  final String? imageUrl;
  final bool isUploading;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.imageUrl,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatarView(
          imageUrl: imageUrl,
          isUploading: isUploading,
        ),
        SizedBox(height: 12.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              phoneNumber!,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        SizedBox(height: 6.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: ColorManger.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ColorManger.primary,
            ),
          ),
        ),
      ],
    );
  }
}
