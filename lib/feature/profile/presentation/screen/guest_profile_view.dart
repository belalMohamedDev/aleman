import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_menu_group.dart';
import 'package:aleman/feature/profile/presentation/widget/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'حسابي',
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 8.h,
          bottom: 100.h,
        ),
        child: Column(
          children: [
            // ================= 1. Guest Hero Login Card ================= //
            _GuestHeroCard(
              onLoginTap: () {
                Navigator.pushNamed(context, Routes.loginRoute);
              },
            ),

            SizedBox(height: 20.h),

            // ================= 2. Quick Value Badges ================= //
            _buildGuestPerksRow(),

            SizedBox(height: 20.h),

            // ================= 3. Orders & Wishlist Group ================= //
            // ProfileMenuGroup(
            //   title: 'المفضلة',
            //   items: [
            //     ProfileMenuItem(
            //       icon: Iconsax.box,
            //       title: 'طلباتي',
            //       onTap: () => _promptLogin(context, 'لعرض ومتابعة طلباتك'),
            //     ),
            //     ProfileMenuItem(
            //       icon: Iconsax.heart,
            //       title: 'قائمة المفضلة',
            //       onTap: () {
            //         // Navigate to Wishlist tab
            //         context.read<BottomNavCubit>().changeTab(2);
            //       },
            //     ),
            //   ],
            // ),

            // SizedBox(height: 16.h),

            // ================= 4. Support & Help Group ================= //
            ProfileMenuGroup(
              title: 'المساعدة والدعم',
              items: [
                ProfileMenuItem(
                  icon: Iconsax.headphone,
                  title: 'خدمة العملاء والدعم الفني',
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.contactSupportRoute),
                ),
                ProfileMenuItem(
                  icon: Iconsax.info_circle,
                  title: 'عن شركة الإيمان للأعلاف',
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.aboutUsRoute),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // ================= 5. App Info & Policies ================= //
            ProfileMenuGroup(
              title: 'معلومات التطبيق',
              items: [
                ProfileMenuItem(
                  icon: Iconsax.document_text,
                  title: 'الشروط والأحكام',
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.termsAndConditionsRoute,
                  ),
                ),
                ProfileMenuItem(
                  icon: Iconsax.shield_tick,
                  title: 'سياسة الخصوصية',
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.privacyPolicyRoute),
                ),
              ],
            ),

            SizedBox(height: 28.h),

            // ================= 6. Version & Footer ================= //
            Text(
              'الإيمان للأعلاف - الإصدار 1.0.0',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'جميع الحقوق محفوظة © ${DateTime.now().year}',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestPerksRow() {
    return Row(
      children: [
        Expanded(
          child: _PerkItem(
            icon: Iconsax.truck_fast,
            title: 'توصيل سريع',
            subtitle: 'لجميع المحافظات',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _PerkItem(
            icon: Iconsax.medal_star,
            title: 'أعلاف معتمدة',
            subtitle: 'أعلى معايير الجودة',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _PerkItem(
            icon: Iconsax.verify,
            title: 'أسعار فورية',
            subtitle: 'عروض وتحديثات',
          ),
        ),
      ],
    );
  }
}

class _GuestHeroCard extends StatelessWidget {
  final VoidCallback onLoginTap;

  const _GuestHeroCard({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFEFF2F6), width: 1),
      ),
      child: Column(
        children: [
          // Icon Avatar
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: ColorManger.noonYellow.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 52.w,
                height: 52.h,
                decoration: const BoxDecoration(
                  color: ColorManger.noonYellow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.user,
                  size: 26.sp,
                  color: ColorManger.primary,
                ),
              ),
            ),
          ),

          SizedBox(height: 14.h),

          // Title
          Text(
            'أهلاً بك في الإيمان للأعلاف',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),

          SizedBox(height: 6.h),

          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'سجّل دخولك للوصول إلى طلباتك، إدارة عناوينك، والاستمتاع بتجربة تسوق متكاملة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF64748B),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 18.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onLoginTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'تسجيل الدخول أو إنشاء حساب',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
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

class _PerkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PerkItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.sp, color: ColorManger.primaryLight),
          SizedBox(height: 6.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 9.sp, color: const Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
