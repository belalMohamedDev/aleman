import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/banner_carousel_slider.dart';
import 'package:aleman/feature/home/presentation/widget/category_list_view_builder.dart';
import 'package:aleman/feature/home/presentation/widget/search_row.dart';
import 'package:aleman/feature/notification/presentation/widget/notification_badge_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

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
                  responsive.setSizeBox(height: 3),
                  const BannerCarouselSlider(),

                  const CategoryListViewBuilder(),
                  // responsive.setSizeBox(height: 2),
                  // const BannerCarouselSlider(),

                  // const NewProductGrideView(),
                  // responsive.setSizeBox(height: 10),
                ],
              ),
            ),
            // Image.asset(
            //   ImageAsset.categoryPlante,
            //   width: double.infinity,
            //   fit: BoxFit.fitWidth,
            //   alignment: Alignment.bottomCenter,
            // ),
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
                  onTap: () async {
                    if (state.isLoggedIn) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.profileRoute);
                    } else {
                      final result = await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.loginRoute);
                      if (result == true && context.mounted) {
                        context.read<HomeCuibtCubit>().fetchHomeData();
                        context.read<CartCubit>().getCartCount();
                      }
                    }
                  },
                  child: Icon(
                    state.isLoggedIn ? Icons.settings : Iconsax.login,
                    size: 22.sp,
                    color: ColorManger.primaryLight,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeaderButton({required Widget child, VoidCallback? onTap}) {
    return Material(
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
