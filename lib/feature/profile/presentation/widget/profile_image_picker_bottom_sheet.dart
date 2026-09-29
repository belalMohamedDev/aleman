import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePickerBottomSheet extends StatelessWidget {
  final ProfileCubit cubit;
  final bool hasExistingImage;

  const ProfileImagePickerBottomSheet({
    super.key,
    required this.cubit,
    required this.hasExistingImage,
  });

  static void show(
    BuildContext context, {
    required ProfileCubit cubit,
    required bool hasExistingImage,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ProfileImagePickerBottomSheet(
        cubit: cubit,
        hasExistingImage: hasExistingImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'صورة الملف الشخصي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'اختر من المعرض أو التقط صورة جديدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _PickerActionCard(
                    icon: Iconsax.camera,
                    title: 'الكاميرا',
                    color: ColorManger.primary,
                    onTap: () {
                      Navigator.pop(context);
                      cubit.pickAndUploadImage(ImageSource.camera);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _PickerActionCard(
                    icon: Iconsax.gallery,
                    title: 'المعرض',
                    color: ColorManger.primaryLight,
                    onTap: () {
                      Navigator.pop(context);
                      cubit.pickAndUploadImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            if (hasExistingImage) ...[
              SizedBox(height: 12.h),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.removeProfileImage();
                },
                icon: Icon(Iconsax.trash, size: 18.sp, color: Colors.red),
                label: Text(
                  'حذف الصورة الحالية',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PickerActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _PickerActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
