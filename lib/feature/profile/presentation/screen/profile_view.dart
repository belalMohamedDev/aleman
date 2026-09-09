import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/feature/address/presentation/screen/user_addresses_screen.dart';
import 'package:aleman/feature/order/presentation/screen/my_orders_screen.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_state.dart';
import 'package:aleman/core/services/app_logout.dart';
import 'package:aleman/feature/order/presentation/screen/small_merchants_orders_screen.dart';
import 'package:aleman/feature/profile/presentation/screen/my_small_merchants_screen.dart';
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
              error: (error) => GlobalError(
                onTap: () {
                  context.read<ProfileCubit>().fetchUserProfile();
                },
              ),
              success: (profile) {
                final bool isMainCustomer =
                    profile.role == 'ParentMerchantId' ||
                    profile.role == 'ParentMerchant' ||
                    profile.role.toLowerCase().contains('parentmerchant') ||
                    profile.role.toLowerCase().contains('bigmerchant');

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      _ProfileHeader(
                        name: profile.name,
                        role: isMainCustomer
                            ? 'وكيل معتمد (تاجر كبير)'
                            : 'عميل',
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
                      SizedBox(height: 10.h),

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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MySmallMerchantsScreen(
                                      merchants: profile.smallMerchants ?? [],
                                    ),
                                  ),
                                );
                              },
                            ),
                            _ProfileMenuItem(
                              icon: Iconsax.task_square,
                              title: 'أوردرات العملاء',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SmallMerchantsOrdersScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],

                      _buildMenuGroup(
                        items: [
                          _ProfileMenuItem(
                            icon: Iconsax.logout,
                            title: 'تسجيل الخروج',
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            showTrailing: false,
                            onTap: () => _showLogoutConfirmation(context),
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

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        bool isLoggingOut = false;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFECDD3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Iconsax.logout,
                      color: const Color(0xFFDC2626),
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),

                  // أزرار التأكيد والإلغاء
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoggingOut
                              ? null
                              : () => Navigator.pop(bottomSheetContext),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoggingOut
                              ? null
                              : () async {
                                  setSheetState(() {
                                    isLoggingOut = true;
                                  });
                                  await const AppLogout()
                                      .logOutThenNavigateToLogin(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            // padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoggingOut
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'تأكيد الخروج',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        );
      },
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
