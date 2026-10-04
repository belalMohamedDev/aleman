import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/bottomNavBar/logic/bottom_nav_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CustomBottomNavBar extends StatelessWidget {
  final ValueChanged<int>? onTabSelected;

  const CustomBottomNavBar({super.key, this.onTabSelected});

  // Color Palette Constants for Bottom Navigation
  static const Color _navBg = Colors.white;
  static const Color _activeItemColor = ColorManger.primaryLight;
  static const Color _activePillBg = Color(0xFFEBF6EE);
  static const Color _inactiveItemColor = Color.fromARGB(255, 119, 137, 161);
  static const Color _badgeBg = Color(0xFFE11D48);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      buildWhen: (prev, curr) => prev.isLoggedIn != curr.isLoggedIn,
      builder: (context, homeState) {
        final isLoggedIn = homeState.isLoggedIn;

        return BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            final bottomPadding = MediaQuery.of(context).padding.bottom;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              color: Colors.transparent,
              padding: EdgeInsets.only(
                left: isLoggedIn ? 36.w : 66.w,
                right: isLoggedIn ? 36.w : 66.w,
                bottom: bottomPadding > 0 ? bottomPadding : 10.h,
                top: 6.h,
              ),
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  color: _navBg,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: const Color(0xFFEEF2F6),
                    width: 0.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: ColorManger.primary.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context: context,
                      index: 0,
                      label: 'الرئيسية',
                      icon: Iconsax.home,
                      activeIcon: Iconsax.home_15,
                      isSelected: currentIndex == 0,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 1,
                      label: 'الأقسام',
                      icon: Iconsax.category,
                      activeIcon: Iconsax.category5,
                      isSelected: currentIndex == 1,
                    ),
                    if (isLoggedIn)
                      _buildWishlistNavItem(
                        context: context,
                        index: 2,
                        isSelected: currentIndex == 2,
                      ),
                    if (isLoggedIn)
                      _buildNavItem(
                        context: context,
                        index: 3,
                        label: 'حسابي',
                        icon: Iconsax.user,
                        activeIcon: Iconsax.user4,
                        isSelected: currentIndex == 3,
                      )
                    else
                      _buildNavItem(
                        context: context,
                        index: 2,
                        label: 'تسجيل الدخول',
                        icon: Iconsax.login_1,
                        activeIcon: Iconsax.login,
                        isSelected: currentIndex == 2,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<BottomNavCubit>().changeTab(index);
        onTabSelected?.call(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14.w : 10.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _activePillBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? _activeItemColor : _inactiveItemColor,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _activeItemColor : _inactiveItemColor,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistNavItem({
    required BuildContext context,
    required int index,
    required bool isSelected,
  }) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      buildWhen: (prev, curr) =>
          prev.count != curr.count ||
          prev.wishlistProductIds.length != curr.wishlistProductIds.length,
      builder: (context, wishlistState) {
        final count = wishlistState.count > 0
            ? wishlistState.count
            : wishlistState.wishlistProductIds.length;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.read<BottomNavCubit>().changeTab(index);
            onTabSelected?.call(index);
          },
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 14.w : 10.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: isSelected ? _activePillBg : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        isSelected ? Iconsax.heart5 : Iconsax.heart,
                        key: ValueKey(isSelected),
                        color: isSelected
                            ? _activeItemColor
                            : _inactiveItemColor,
                        size: 20.sp,
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        top: -5.h,
                        right: -7.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: _badgeBg,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: _badgeBg,
                                blurRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.w,
                            minHeight: 16.h,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'المفضلة',
                  style: TextStyle(
                    color: isSelected ? _activeItemColor : _inactiveItemColor,
                    fontSize: 10.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
