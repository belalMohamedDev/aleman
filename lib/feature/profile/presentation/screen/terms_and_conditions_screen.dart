import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/presentation/widget/info_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'الشروط والأحكام',
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
                      color: ColorManger.noonYellow.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Iconsax.document_text,
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
                          'اتفاقية الاستخدام والشروط',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'يرجى قراءة هذه البنود بعناية قبل استخدام التطبيق',
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
              icon: Iconsax.tick_circle,
              title: '1. قبول الشروط',
              content:
                  'يعد استخدامك لتطبيق شركة الإيمان للأعلاف أو تسجيل حساب فيه موافقة صريحة وغير مشروطة على الالتزام بجميع الأحكام والشروط الواردة في هذه الاتفاقية والسياسات المرتبطة بها.',
            ),

            const InfoSectionCard(
              icon: Iconsax.user_tag,
              title: '2. حساب المستخدم والأمان',
              content:
                  'يتحمل المستخدم المسؤولية الكاملة عن الحفاظ على سرية معلومات حسابه وكلمة المرور. كما يتعهد بتقديم بيانات صحيحة ودقيقة ومحدثة خاصة برقم الهاتف وعناوين التوصيل.',
            ),

            const InfoSectionCard(
              icon: Iconsax.tag,
              title: '3. الأسعار والطلبات',
              content:
                  'تخضع أسعار الأعلاف لتحديثات فورية تعكس أسعار السوق الحالية وتكاليف الإنتاج. يعتبر السعر ثابتاً وملزماً بمجرد تأكيد الطلب وقبوله من قبل إدارة المبيعات.',
              bulletPoints: [
                'الكميات المحددة في الطلب تخضع للتأكيد الفعلي بالمخازن.',
                'يحق للإدارة التواصل مع العميل للتحقق من بيانات الشحنة.',
              ],
            ),

            const InfoSectionCard(
              icon: Iconsax.truck_fast,
              title: '4. الشحن والتسليم',
              content:
                  'نلتزم بتسليم الشحنات وفق الجداول الزمنية المتفق عليها عبر سيارات التحميل المعتمدة. يتعين على العميل أو المفوض عنه فحص الشحنة والتأكد من سلامة العبوات ومطابقتها للمواصفات عند الاستلام.',
            ),

            const InfoSectionCard(
              icon: Iconsax.refresh,
              title: '5. سياسة الاسترجاع والاستبدال',
              content:
                  'حرصاً على سلامة الأعلاف وصحة الثروة الحيوانية، لا يتم استرجاع أو استبدال الأعلاف بعد استلامها إلا في حالة ثبوت وجود عيب تصنيعي واضح أو تلف ناتج عن الشحن ومُثبت في محضر الاستلام.',
            ),

            const InfoSectionCard(
              icon: Iconsax.edit_2,
              title: '6. تعديل الشروط',
              content:
                  'تحتفظ الشركة بحقها الكامل في تعديل هذه الشروط في أي وقت. تصبح التعديلات سارية فور نشرها عبر التطبيق، ويعتبر استمرارك في استخدام التطبيق موافقة ضمنية عليها.',
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
