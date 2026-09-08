import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/feature/address/presentation/screen/user_addresses_screen.dart';
import 'package:aleman/feature/order/presentation/screen/my_orders_screen.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ProfileCubit>()..fetchUserProfile(),
      child: Scaffold(
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
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const _ProfileShimmer(),
              loading: () => const _ProfileShimmer(),
              error: (error) => Center(child: Text(error.message ?? 'حدث خطأ')),
              success: (profile) {
                final bool isMainCustomer = profile.role == 'ParentMerchant';

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      _ProfileHeader(
                        name: profile.name,
                        role: isMainCustomer ? 'عميل رئيسي' : 'عميل',
                      ),
                      SizedBox(height: 24.h),

                      _buildMenuGroup(
                        title: 'إعدادات الحساب',
                        items: [
                          // _ProfileMenuItem(
                          //   icon: Iconsax.profile_circle,
                          //   title: 'الملف الشخصي',
                          //   onTap: () {},
                          // ),
                          _ProfileMenuItem(
                            icon: Iconsax.location,
                            title: 'العناوين',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UserAddressesScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      _buildMenuGroup(
                        title: 'الطلبات',
                        items: [
                          _ProfileMenuItem(
                            icon: Iconsax.box,
                            title: 'طلباتي',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyOrdersScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      if (isMainCustomer) ...[
                        _buildMenuGroup(
                          title: 'إدارة العملاء',
                          items: [
                            _ProfileMenuItem(
                              icon: Iconsax.people,
                              title: 'عملائي',
                              onTap: () {},
                            ),
                            _ProfileMenuItem(
                              icon: Iconsax.task_square,
                              title: 'أوردرات العملاء',
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],

                      // القسم الرابع: تسجيل الخروج
                      _buildMenuGroup(
                        items: [
                          _ProfileMenuItem(
                            icon: Iconsax.logout,
                            title: 'تسجيل الخروج',
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            showTrailing: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuGroup({String? title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  items[index],
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 50.w,
                      endIndent: 16.w,
                      color: Colors.grey.shade100,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String role;

  const _ProfileHeader({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorManger.primary.withValues(alpha: 0.2),
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 45.w,
            backgroundColor: ColorManger.primaryLight.withValues(alpha: 0.1),
            child: Icon(Iconsax.user, size: 40.w, color: ColorManger.primary),
          ),
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
        SizedBox(height: 4.h),
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

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showTrailing;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? ColorManger.primary).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20.w,
                  color: iconColor ?? ColorManger.primary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.black87,
                  ),
                ),
              ),
              if (showTrailing)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.w,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            // Header Shimmer
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 12.h),
            Container(width: 150.w, height: 20.h, color: Colors.white),
            SizedBox(height: 8.h),
            Container(
              width: 100.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 24.h),

            // Group 1
            _buildShimmerGroup(2),
            SizedBox(height: 20.h),
            // Group 2
            _buildShimmerGroup(1),
            SizedBox(height: 20.h),
            // Group 3
            _buildShimmerGroup(2),
            SizedBox(height: 20.h),
            // Group 4
            _buildShimmerGroup(1),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGroup(int itemsCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 100.w, height: 14.h, color: Colors.white),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(
              itemsCount,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(width: 120.w, height: 14.h, color: Colors.white),
                    const Spacer(),
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
