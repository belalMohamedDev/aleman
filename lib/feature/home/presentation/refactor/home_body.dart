import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/banner_carousel_slider.dart';
import 'package:aleman/feature/home/presentation/widget/category_list_view_builder.dart';
import 'package:aleman/feature/home/presentation/widget/home_products_section.dart';
import 'package:aleman/feature/home/presentation/widget/search_row.dart';
import 'package:aleman/feature/notification/presentation/widget/notification_badge_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class HomeBody extends StatelessWidget {
  final GlobalKey? cartKey;

  const HomeBody({super.key, this.cartKey});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: responsive.setPadding(top: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: responsive.setPadding(left: 5.5, right: 5.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleAndNotificationRow(context),

                  responsive.setSizeBox(height: 2),
                  const SearchRow(),
                  responsive.setSizeBox(height: 2),
                  const BannerCarouselSlider(),

                  const CategoryListViewBuilder(),
                  BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
                    buildWhen: (prev, curr) =>
                        prev.bestSellers != curr.bestSellers ||
                        prev.productsStatus != curr.productsStatus,
                    builder: (context, state) {
                      return HomeProductsSection(
                        title: 'الأكثر طلباً',

                        products: state.bestSellers,
                        isLoading:
                            state.productsStatus == RequestStatus.loading,
                      );
                    },
                  ),
                  BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
                    buildWhen: (prev, curr) =>
                        prev.featuredProducts != curr.featuredProducts ||
                        prev.productsStatus != curr.productsStatus,
                    builder: (context, state) {
                      return HomeProductsSection(
                        title: 'منتجات مميزة',

                        products: state.featuredProducts,
                        isLoading:
                            state.productsStatus == RequestStatus.loading,
                      );
                    },
                  ),
                  SizedBox(height: 90.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _titleAndNotificationRow(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Row(
      children: [
        Image.asset(
          ImageAsset.alemanLogo,
          height: responsive.setHeight(5),
          width: responsive.setWidth(14),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            responsive.setSizeBox(height: 1),
            Text(
              'أعلاف الإيمان',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: responsive.setTextSize(3.2),
                fontWeight: FontWeight.bold,
              ),
            ),
            responsive.setSizeBox(height: 0.3),
            Text(
              'رائدة الأعلاف فى مصر',
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(fontSize: responsive.setTextSize(2.5)),
            ),
          ],
        ),
        const Spacer(),

        BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
          buildWhen: (previous, current) =>
              previous.isLoggedIn != current.isLoggedIn,
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.isLoggedIn) ...[
                  _buildHeaderButton(
                    onTap: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.notificationsRoute);
                    },
                    child: NotificationBadgeIcon(
                      iconColor: ColorManger.primaryLight,
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],

                _buildHeaderButton(
                  key: cartKey,
                  onTap: () {
                    final isLoggedIn = context
                        .read<HomeCuibtCubit>()
                        .state
                        .isLoggedIn;
                    if (isLoggedIn) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.cartRoute);
                    } else {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.loginRoute);
                    }
                  },
                  child: ValueListenableBuilder<double>(
                    valueListenable: CartAnimationHelper.cartBounceNotifier,
                    builder: (context, scale, childWidget) {
                      return Transform.scale(scale: scale, child: childWidget);
                    },
                    child: BlocBuilder<CartCubit, CartState>(
                      buildWhen: (previous, current) =>
                          previous.totalItemsCount != current.totalItemsCount,
                      builder: (context, cartState) {
                        final count = cartState.totalItemsCount;
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Iconsax.bag_happy,
                              color: ColorManger.primaryLight,
                              size: 20.sp,
                            ),
                            if (count > 0)
                              PositionedDirectional(
                                top: -11,
                                end: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: ColorManger.chipProtein,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    count > 99 ? '99+' : '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeaderButton({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Material(
      key: key,
      color: ColorManger.backgroundItem,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 42.w,
          height: 42.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.02),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
