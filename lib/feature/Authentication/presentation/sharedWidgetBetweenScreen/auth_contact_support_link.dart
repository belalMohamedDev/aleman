import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';

void showAuthContactOptions(BuildContext context) {
  const String phoneNumber = "201110767100";
  const String displayPhone = "0111 076 7100";

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: ColorManger.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Iconsax.headphone,
                      size: 24.sp,
                      color: ColorManger.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خدمة العملاء والدعم الفني',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'فريق الدعم الفني جاهز لمساعدتك',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),

              // Option 1: Direct Call
              _SupportOptionTile(
                icon: Iconsax.call,
                iconColor: Colors.green.shade600,
                iconBgColor: Colors.green.shade50,
                title: 'اتصال مباشر',
                subtitle: displayPhone,
                onTap: () async {
                  Navigator.of(ctx).maybePop();
                  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),

              SizedBox(height: 10.h),

              // Option 2: WhatsApp
              _SupportOptionTile(
                imageAsset: ImageAsset.whatsapp,
                title: 'محادثة عبر الواتساب',
                subtitle: 'تواصل فوري مع فريق المبيعات والدعم',
                onTap: () async {
                  Navigator.of(ctx).maybePop();
                  final Uri url = Uri.parse("https://wa.me/$phoneNumber");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),

              SizedBox(height: 10.h),

              // Option 3: Copy Number
              _SupportOptionTile(
                icon: Iconsax.copy,
                iconColor: ColorManger.primaryLight,
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'نسخ رقم الهاتف',
                subtitle: 'نسخ الرقم للحافظة لسهولة الاتصال',
                onTap: () {
                  Navigator.of(ctx).maybePop();
                  Clipboard.setData(const ClipboardData(text: phoneNumber))
                      .then((_) {
                        if (context.mounted) {
                          AppToast.showSuccess(
                            context,
                            message: 'تم نسخ رقم التواصل بنجاح 🌾',
                          );
                        }
                      });
                },
              ),

              SizedBox(height: 14.h),

              // Option 4: Full page button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).maybePop();
                    Navigator.pushNamed(context, Routes.contactSupportRoute);
                  },
                  icon: const Icon(Iconsax.info_circle, size: 16),
                  label: const Text('عرض جميع تفاصيل ومواعيد الدعم'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SupportOptionTile extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final Color? iconColor;
  final Color? iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportOptionTile({
    this.icon,
    this.imageAsset,
    this.iconColor,
    this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: iconBgColor ?? const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: imageAsset != null
                      ? Image.asset(imageAsset!, width: 22.w, height: 22.h)
                      : Icon(icon, color: iconColor, size: 20.sp),
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
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthContactSupportLink extends StatelessWidget {
  const AuthContactSupportLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => showAuthContactOptions(context),
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.headphone,
                size: 16.sp,
                color: const Color(0xFF64748B),
              ),
              SizedBox(width: 6.w),
              Text(
                'تحتاج مساعدة؟ تواصل مع خدمة العملاء',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
