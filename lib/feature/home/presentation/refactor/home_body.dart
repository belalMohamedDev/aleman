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
import 'package:flutter/material.dart';
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

        Container(
          height: responsive.setHeight(4.5),
          width: responsive.setWidth(9.8),
          decoration: BoxDecoration(
            color: ColorManger.backgroundItem,
            borderRadius: BorderRadius.circular(responsive.setBorderRadius(5)),
          ),
          child: Icon(Iconsax.notification, color: ColorManger.primaryLight),
        ),
        responsive.setSizeBox(width: 3),
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
            height: responsive.setHeight(4.5),
            width: responsive.setWidth(9.8),
            decoration: BoxDecoration(
              color: ColorManger.backgroundItem,
              borderRadius: BorderRadius.circular(
                responsive.setBorderRadius(5),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -1,
                  top: -1.2,
                  child: Icon(
                    Icons.settings,
                    size: 10.sp,
                    color: ColorManger.primaryLight,
                  ),
                ),
                Image.asset(
                  ImageAsset.farmer,
                  fit: BoxFit.contain,
                  color: ColorManger.primaryLight,
                ),
              ],
            ),
            //    Icon(Iconsax.user, color: ColorManger.primaryLight),
          ),
        ),

        // GestureDetector(
        //   onTap: () {
        //     if (AppInitialRoute.isAnonymousUser) {
        //       context.pushNamed(Routes.noRoute);
        //     } else {
        //       context.pushNamed(Routes.cart);
        //     }
        //   },
        //   child: badges.Badge(
        //     showBadge: false,
        //     badgeAnimation: const badges.BadgeAnimation.scale(
        //       loopAnimation: true,
        //       curve: Curves.slowMiddle,
        //       animationDuration: Duration(milliseconds: 2000),
        //     ),
        //     position: badges.BadgePosition.topEnd(end: 26.w, top: -2.h),
        //     badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(3.h)),
        //     badgeContent: Text(
        //       '+9',
        //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //         fontFamily: FontConsistent.fontFamilyAcme,
        //         color: ColorManger.white,
        //         fontSize: 10.sp,
        //       ),
        //     ),
        //     child: Container(
        //       height: responsive.setHeight(4.5),
        //       width: responsive.setWidth(9.8),
        //       decoration: BoxDecoration(
        //         color: ColorManger.brownLight,
        //         borderRadius: BorderRadius.circular(
        //           responsive.setBorderRadius(5),
        //         ),
        //       ),
        //       child: Icon(IconlyBold.bag, color: ColorManger.brun),
        //     ),
        //   ),
        // ),
        // responsive.setSizeBox(width: 1),
        // StreamBuilder<UserNotificationResponse>(
        //   stream: notificationService.notificationStream,
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData || snapshot.data == null) {
        //       return IconButton(
        //         onPressed: () {
        //           if (AppInitialRoute.isAnonymousUser) {
        //             Navigator.of(
        //               context,
        //               rootNavigator: !false,
        //             ).pushNamed(Routes.noRoute);
        //           } else {
        //             Navigator.of(
        //               context,
        //               rootNavigator: !false,
        //             ).pushNamed(Routes.notification);
        //           }
        //         },
        //         icon: Container(
        //           height: responsive.setHeight(4.5),
        //           width: responsive.setWidth(9.8),
        //           decoration: BoxDecoration(
        //             color: ColorManger.brownLight,
        //             borderRadius: BorderRadius.circular(
        //               responsive.setBorderRadius(5),
        //             ),
        //           ),
        //           child: Icon(IconlyBold.notification, color: ColorManger.brun),
        //         ),
        //       );
        //     }

        //     final numberOfNotification = snapshot.data!.data!
        //         .where((element) => element.isSeen == false)
        //         .length;

        //     return badges.Badge(
        //       showBadge: numberOfNotification != 0,
        //       badgeAnimation: const badges.BadgeAnimation.scale(),
        //       position: badges.BadgePosition.topEnd(
        //         end: numberOfNotification >= 9 ? 8.w : 10.w,
        //         top: numberOfNotification >= 9 ? 4.h : 5.h,
        //       ),
        //       badgeStyle: badges.BadgeStyle(
        //         padding: EdgeInsets.all(
        //           numberOfNotification >= 9 ? 4.h : 5.5.h,
        //         ),
        //       ),
        //       badgeContent: Text(
        //         numberOfNotification >= 9 ? '+9' : '$numberOfNotification',
        //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //           fontFamily: FontConsistent.fontFamilyAcme,
        //           color: ColorManger.white,
        //           fontSize: numberOfNotification >= 9 ? 8.sp : 10.sp,
        //         ),
        //       ),
        //       child: IconButton(
        //         onPressed: () {
        //           context.pushNamed(Routes.notification);
        //         },
        //         icon: Container(
        //           height: responsive.setHeight(4.5),
        //           width: responsive.setWidth(9.8),
        //           decoration: BoxDecoration(
        //             color: ColorManger.brownLight,
        //             borderRadius: BorderRadius.circular(
        //               responsive.setBorderRadius(5),
        //             ),
        //           ),
        //           child: Icon(IconlyBold.notification, color: ColorManger.brun),
        //         ),
        //       ),
        //     );
        //   },
        // ),

        // GestureDetector(
        //   onTap: () {
        //     if (AppInitialRoute.isAnonymousUser) {
        //       context.pushNamed(Routes.noRoute);
        //     } else {
        //       context.pushNamed(Routes.cart);
        //     }
        //   },
        //   child: badges.Badge(
        //     showBadge: false,
        //     badgeAnimation: const badges.BadgeAnimation.scale(
        //       loopAnimation: true,
        //       curve: Curves.slowMiddle,
        //       animationDuration: Duration(milliseconds: 2000),
        //     ),
        //     position: badges.BadgePosition.topEnd(end: 26.w, top: -2.h),
        //     badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(3.h)),
        //     badgeContent: Text(
        //       '+9',
        //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //         fontFamily: FontConsistent.fontFamilyAcme,
        //         color: ColorManger.white,
        //         fontSize: 10.sp,
        //       ),
        //     ),
        //     child: Container(
        //       height: responsive.setHeight(4.5),
        //       width: responsive.setWidth(9.8),
        //       decoration: BoxDecoration(
        //         color: ColorManger.brownLight,
        //         borderRadius: BorderRadius.circular(
        //           responsive.setBorderRadius(5),
        //         ),
        //       ),
        //       child: Icon(IconlyBold.bag, color: ColorManger.brun),
        //     ),
        //   ),
        // ),
        // responsive.setSizeBox(width: 1),
        // StreamBuilder<UserNotificationResponse>(
        //   stream: notificationService.notificationStream,
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData || snapshot.data == null) {
        //       return IconButton(
        //         onPressed: () {
        //           if (AppInitialRoute.isAnonymousUser) {
        //             Navigator.of(
        //               context,
        //               rootNavigator: !false,
        //             ).pushNamed(Routes.noRoute);
        //           } else {
        //             Navigator.of(
        //               context,
        //               rootNavigator: !false,
        //             ).pushNamed(Routes.notification);
        //           }
        //         },
        //         icon: Container(
        //           height: responsive.setHeight(4.5),
        //           width: responsive.setWidth(9.8),
        //           decoration: BoxDecoration(
        //             color: ColorManger.brownLight,
        //             borderRadius: BorderRadius.circular(
        //               responsive.setBorderRadius(5),
        //             ),
        //           ),
        //           child: Icon(IconlyBold.notification, color: ColorManger.brun),
        //         ),
        //       );
        //     }

        //     final numberOfNotification = snapshot.data!.data!
        //         .where((element) => element.isSeen == false)
        //         .length;

        //     return badges.Badge(
        //       showBadge: numberOfNotification != 0,
        //       badgeAnimation: const badges.BadgeAnimation.scale(),
        //       position: badges.BadgePosition.topEnd(
        //         end: numberOfNotification >= 9 ? 8.w : 10.w,
        //         top: numberOfNotification >= 9 ? 4.h : 5.h,
        //       ),
        //       badgeStyle: badges.BadgeStyle(
        //         padding: EdgeInsets.all(
        //           numberOfNotification >= 9 ? 4.h : 5.5.h,
        //         ),
        //       ),
        //       badgeContent: Text(
        //         numberOfNotification >= 9 ? '+9' : '$numberOfNotification',
        //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //           fontFamily: FontConsistent.fontFamilyAcme,
        //           color: ColorManger.white,
        //           fontSize: numberOfNotification >= 9 ? 8.sp : 10.sp,
        //         ),
        //       ),
        //       child: IconButton(
        //         onPressed: () {
        //           context.pushNamed(Routes.notification);
        //         },
        //         icon: Container(
        //           height: responsive.setHeight(4.5),
        //           width: responsive.setWidth(9.8),
        //           decoration: BoxDecoration(
        //             color: ColorManger.brownLight,
        //             borderRadius: BorderRadius.circular(
        //               responsive.setBorderRadius(5),
        //             ),
        //           ),
        //           child: Icon(IconlyBold.notification, color: ColorManger.brun),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
