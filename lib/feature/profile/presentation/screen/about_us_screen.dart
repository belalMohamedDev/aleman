import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/profile/presentation/widget/info_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'عن شركة الإيمان للأعلاف',
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
            // Top Branded Header
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
                  Image.asset(
                    ImageAsset.alemanLogo,
                    height: 60.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: const BoxDecoration(
                        color: ColorManger.noonYellow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.building_4,
                        size: 30.sp,
                        color: ColorManger.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'شركة الإيمان للأعلاف',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'ريادة وتميز في تصنيع الأعلاف الحيوانية والداجنة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Section 1: Who are we
            const InfoSectionCard(
              icon: Iconsax.info_circle,
              title: 'من نحن',
              content:
                  'تعد شركة الإيمان للأعلاف إحدى الكيانات الوطنية الرائدة في مصر المتخصصة في صناعة وتوريد أجود أنواع الأعلاف. نحن نحرص على تطبيق أحدث التقنيات وأفضل معايير التغذية لخدمة المربين وأصحاب المزارع بمختلف المحافظات.',
            ),

            // Section 2: Vision
            const InfoSectionCard(
              icon: Iconsax.eye,
              title: 'رؤيتنا',
              content:
                  'أن نكون الخيار الأول والشريك الأكثر موثوقية لمربي الثروة الحيوانية والداجنة في مصر والشرق الأوسط، من خلال تقديم أعلاف ذات كفاءة تحويلية قياسية تضمن أعلى ربحية للمربي.',
            ),

            // Section 3: Mission
            const InfoSectionCard(
              icon: Iconsax.flag,
              title: 'رسالتنا',
              content:
                  'توفير منتجات غذائية آمنة، متوازنة، وخالية من أي مسببات للمشاكل الهضمية أو الأمراض، باستخدام أفضل الخامات النباتية الطبيعية وتحت إشراف نخبة من أساتذة التغذية البيطرية.',
            ),

            // Section 4: Values & Strengths
            const InfoSectionCard(
              icon: Iconsax.award,
              title: 'قيمنا ومعايير الجودة',
              content: 'نلتزم بثوابت مهنية صارمة تضمن استمرار الثقة مع عملائنا:',
              bulletPoints: [
                'اختبارات معملية دورية لجميع شحنات الحبوب والمكونات الخام.',
                'تركيبات متوازنة تلبي متطلبات النمو في كل مرحلة عمرية.',
                'تعبئة بأكياس محكمة تضمن الحفاظ على القيمة الغذائية والنقاء.',
                'دعم فني واستشارات متخصصة لمساعدة المربي طوال الدورة.',
              ],
            ),

            // Support CTA Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.only(top: 8.h, bottom: 20.h),
              decoration: BoxDecoration(
                color: ColorManger.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorManger.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.headphone,
                    size: 28.sp,
                    color: ColorManger.primaryLight,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'هل لديك استفسار أو ترغب في زيارة فروعنا؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 42.h,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        Routes.contactSupportRoute,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Iconsax.call,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: Text(
                        'تواصل مع فريق الدعم',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
