import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/home/presentation/widget/banner_carousel_slider.dart';
import 'package:aleman/feature/home/presentation/widget/category_list_view_builder.dart';
import 'package:aleman/feature/home/presentation/widget/product_gride_view.dart';
import 'package:aleman/feature/home/presentation/widget/search_row.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/notification/presentation/widget/notification_badge_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: responsive.setPadding(left: 5.5, right: 5.5, top: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleAndNotificationRow(context),

            responsive.setSizeBox(height: 2),
            const SearchRow(),
            responsive.setSizeBox(height: 3),
            const BannerCarouselSlider(),
            const CategoryListViewBuilder(),
            responsive.setSizeBox(height: 2),
            const NewProductGrideView(),
            responsive.setSizeBox(
              height: 10,
            ), // Extra space for floating bottom nav
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
              'شركائك فى النجاح',
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
            if (!state.isLoggedIn) {
              return const SizedBox.shrink();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: responsive.setHeight(6),
                  width: responsive.setWidth(12),
                  decoration: BoxDecoration(
                    color: ColorManger.backgroundItem,
                    borderRadius: BorderRadius.circular(
                      responsive.setBorderRadius(5),
                    ),
                  ),
                  child: NotificationBadgeIcon(
                    iconColor: ColorManger.primaryLight,
                    onTap: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.notificationsRoute);
                    },
                  ),
                ),
                responsive.setSizeBox(width: 3),
              ],
            );
          },
        ),
        GestureDetector(
          onTap: () async {
            final token = await SharedPrefHelper.getSecuredString(
              PrefKeys.userAccessToken,
            );
            if (context.mounted) {
              if (token.isNotEmpty) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(Routes.profileRoute);
              } else {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(Routes.loginRoute);
              }
            }
          },
          child: Container(
            height: responsive.setHeight(6),
            width: responsive.setWidth(12),
            decoration: BoxDecoration(
              color: ColorManger.backgroundItem,
              borderRadius: BorderRadius.circular(
                responsive.setBorderRadius(5),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -2,
                  top: 3,
                  child: Icon(
                    Icons.settings,
                    size: 16.sp,
                    color: ColorManger.primaryLight,
                  ),
                ),
                Image.asset(
                  ImageAsset.farmer,
                  height: responsive.setHeight(6),
                  width: responsive.setWidth(15),

                  // color: ColorManger.primaryLight,
                ),
              ],
            ),
            //    Icon(Iconsax.user, color: ColorManger.primaryLight),
          ),
        ),
      ],
    );
  }
}
