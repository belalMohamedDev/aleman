import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/profile/presentation/widget/info_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  static const String phoneNumber = "201110767100";
  static const String displayPhone = "0111 076 7100";

  Future<void> _makeCall() async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _copyPhone(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: phoneNumber)).then((_) {
      if (context.mounted) {
        AppToast.showSuccess(context, message: 'تم نسخ رقم التواصل بنجاح');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'خدمة العملاء والدعم الفني',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            // ================= 1. Top Hero Card ================= //
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: ColorManger.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.headphone,
                        size: 30.sp,
                        color: ColorManger.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'نحن هنا لمساعدتك دائماً',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'يسعدنا التواصل معك للرد على استفسارات الطلبات والأسعار واستشارات التغذية الحيوانية.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'مواعيد العمل: يومياً من 8:00 ص إلى 8:00 م',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= 2. Direct Action Cards ================= //
            // Call Card
            _ContactActionCard(
              icon: Iconsax.call,
              iconColor: Colors.green.shade600,
              iconBgColor: Colors.green.shade50,
              title: 'اتصال هاتفي مباشر',
              subtitle: displayPhone,
              actionLabel: 'اتصال الآن',
              actionColor: Colors.green.shade700,
              onActionTap: _makeCall,
              onCopyTap: () => _copyPhone(context),
            ),

            SizedBox(height: 10.h),

            // WhatsApp Card
            _ContactActionCard(
              imageAsset: ImageAsset.whatsapp,
              title: 'محادثة عبر الواتساب',
              subtitle: 'رد سريع من فريق المبيعات والدعم الفني',
              actionLabel: 'محادثة فورية',
              actionColor: const Color(0xFF25D366),
              onActionTap: _openWhatsApp,
              isWhatsApp: true,
            ),

            SizedBox(height: 18.h),

            // ================= 3. Support Details ================= //
            const InfoSectionCard(
              icon: Iconsax.lamp_on,
              title: 'الاستشارات الفنية والبيطرية',
              content: 'توفر شركة الإيمان للأعلاف فريقاً من الاستشاريين والمهندسين الزراعيين لمساعدتك في اختيار التركيبة المثالية لمزرعتك، وتقديم إرشادات التحويل الغذائي وحساب نسب التغذية.',
            ),

            const InfoSectionCard(
              icon: Iconsax.truck_time,
              title: 'متابعة الشحنات وسيارات النقل',
              content: 'إذا كان لديك طلب قيد التنفيذ أو ترغب في الاستفسار عن موعد وصول سيارة التحميل الخاصة بك، يمكنك التواصل المباشر مع غرفة متابعة الحركة عبر الرقم الموحد.',
            ),

            const InfoSectionCard(
              icon: Iconsax.location,
              title: 'مراكز التوزيع والمصانع',
              content: 'جمهورية مصر العربية - مصانع الإيمان لتصنيع وتوزيع الأعلاف عالية الجودة، ومراكز التوزيع المعتمدة بجميع المحافظات.',
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _ContactActionCard extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final Color? iconColor;
  final Color? iconBgColor;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback onActionTap;
  final VoidCallback? onCopyTap;
  final bool isWhatsApp;

  const _ContactActionCard({
    this.icon,
    this.imageAsset,
    this.iconColor,
    this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionColor,
    required this.onActionTap,
    this.onCopyTap,
    this.isWhatsApp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: iconBgColor ?? actionColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: imageAsset != null
                  ? Image.asset(imageAsset!, width: 26.w, height: 26.h)
                  : Icon(icon, color: iconColor ?? actionColor, size: 22.sp),
            ),
          ),

          SizedBox(width: 14.w),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          if (onCopyTap != null)
            IconButton(
              icon: Icon(
                Iconsax.copy,
                size: 20.sp,
                color: const Color(0xFF94A3B8),
              ),
              tooltip: 'نسخ الرقم',
              onPressed: onCopyTap,
            ),

          SizedBox(
            height: 36.h,
            child: ElevatedButton(
              onPressed: onActionTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primaryLight,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
              child: Text(
                actionLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
