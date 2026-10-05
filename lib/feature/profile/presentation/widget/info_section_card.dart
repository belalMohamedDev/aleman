import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoSectionCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String content;
  final List<String>? bulletPoints;

  const InfoSectionCard({
    super.key,
    this.icon,
    required this.title,
    required this.content,
    this.bulletPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: ColorManger.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    size: 18.sp,
                    color: ColorManger.primary,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              content,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.65,
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (bulletPoints != null && bulletPoints!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ...bulletPoints!.map((point) {
              return Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7.h, left: 8.w),
                      width: 6.w,
                      height: 6.h,
                      decoration: const BoxDecoration(
                        color: ColorManger.primaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          height: 1.55,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
