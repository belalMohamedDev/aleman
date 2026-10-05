import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/presentation/widget/info_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'سياسة الخصوصية',
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
            // Top Badge
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: ColorManger.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Iconsax.shield_tick,
                      size: 24.sp,
                      color: ColorManger.primary,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أمان بياناتك أولويتنا',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'نلتزم بحماية خصوصيتك ومعلوماتك بأعلى درجات الأمان',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const InfoSectionCard(
              icon: Iconsax.document_download,
              title: '1. البيانات التي نقوم بجمعها',
              content:
                  'نقوم بجمع البيانات الضرورية فقط لتمكينك من استخدام خدمات التطبيق وإنشاء الطلبات بنجاح، وتشمل:',
              bulletPoints: [
                'الاسم الكامل ورقم الهاتف لتأكيد التسجيل والدخول.',
                'عناوين التوصيل والمواقع الجغرافية لتوجيه سيارات التحميل.',
                'سجل الطلبات السابقة والمفضلة لتسهيل إعادة الشراء.',
              ],
            ),

            const InfoSectionCard(
              icon: Iconsax.setting_2,
              title: '2. كيف نستخدم معلوماتك',
              content:
                  'تُستخدم المعلومات المجمعة حصرياً للأغراض التشغيلية وتطوير تجربة المستخدم:',
              bulletPoints: [
                'معالجة الطلبات، إصدار الفواتير، والتنسيق مع سائقي التوصيل.',
                'إرسال إشعارات فورية بحالة طلبك وتحديثات أسعار الأعلاف.',
                'تقديم الدعم الفني والمساعدة عند التواصل مع خدمة العملاء.',
              ],
            ),

            const InfoSectionCard(
              icon: Iconsax.lock,
              title: '3. حماية وأمن المعلومات',
              content:
                  'نعتمد تقنيات تشفير قوية وبروتوكولات أمان صارمة لمنع الوصول غير المصرح به أو تسريب أي من بيانات حسابك أو معلومات اتصالاتك.',
            ),

            const InfoSectionCard(
              icon: Iconsax.share,
              title: '4. مشاركة البيانات مع أطراف خارجية',
              content:
                  'نؤكد التزامنا التام بعدم بيع أو تأجير أو مشاركة بياناتك الشخصية مع أي جهات خارجية أو إعلانية. تقتصر مشاركة بيانات العنوان ورقم الهاتف فقط على سائقي الشحن المكلفين بتوصيل شحنتك.',
            ),

            const InfoSectionCard(
              icon: Iconsax.user_edit,
              title: '5. حقوقك في إدارة وحذف حسابك',
              content:
                  'يحق لك في أي وقت تعديل بياناتك الشخصية أو تحديث أرقام الاتصال والعناوين، كما يمكنك تقديم طلب لحذف حسابك نهائياً عبر التواصل مع إدارة التطبيق.',
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
