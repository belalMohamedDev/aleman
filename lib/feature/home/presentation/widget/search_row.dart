import 'package:aleman/core/language/app_localizations.dart';
import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'falling_eggs_animation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';

import 'product_search_delegate.dart';

/// A widget that provides a search input field and a filter button.
/// When tapped, it navigates to the search screen.
class SearchRow extends StatefulWidget {
  const SearchRow({super.key});

  @override
  State<SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<SearchRow> {
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    CartAnimationHelper.cartKey = _cartKey;
  }

  @override
  void dispose() {
    if (CartAnimationHelper.cartKey == _cartKey) {
      CartAnimationHelper.cartKey = GlobalKey();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);
    final bool isEnLocale = AppLocalizations.of(context)?.isEnLocale ?? true;

    return InkWell(
      onTap: () {
        final cubit = context.read<HomeCuibtCubit>();
        final cartCubit = context.read<CartCubit>();
        showSearch(
          context: context,
          delegate: ProductSearchDelegate(
            products: cubit.state.products,
            cartCubit: cartCubit,
            homeCubit: cubit,
          ),
        );
      },
      child: Row(
        children: [
          // The search input field which is disabled but acts as a visual element
          Expanded(
            child: SizedBox(
              height: responsive.setHeight(5.5),
              child: TextFormField(
                enabled: false, // Disable the field since it's just for display
                decoration: InputDecoration(
                  hintText: context.translate(
                    AppStrings.findYourProducts,
                  ), // Placeholder text
                  prefixIcon: Icon(
                    Iconsax.search_favorite,
                    size: responsive.setIconSize(5),
                    color:
                        ColorManger.primaryLight, // Icon color for the search
                  ),

                  hintStyle: Theme.of(context).textTheme.titleMedium!
                      .copyWith(fontSize: responsive.setTextSize(3.5)),
                  fillColor: ColorManger
                      .backgroundItem, // Background color for the input field
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManger.backgroundItem),
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(
                        responsive.setBorderRadius(2),
                        responsive.setBorderRadius(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // A container holding the cart/chicken button
          BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
            buildWhen: (previous, current) =>
                previous.isLoggedIn != current.isLoggedIn,
            builder: (context, homeState) {
              final isLoggedIn = homeState.isLoggedIn;

              return isLoggedIn
                  ? Builder(
                      key: _cartKey,
                      builder: (btnContext) {
                        return BlocBuilder<CartCubit, CartState>(
                          buildWhen: (previous, current) =>
                              previous.totalItemsCount !=
                              current.totalItemsCount,
                          builder: (context, cartState) {
                            final count = cartState.totalItemsCount;
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    ImageAsset.cart,
                                    height: responsive.setHeight(6),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.cartRoute,
                                    );
                                  },
                                ),
                                if (count > 0)
                                  Positioned(
                                    top: 5,
                                    right: 3,
                                    child: TweenAnimationBuilder<double>(
                                      key: ValueKey(count),
                                      tween: Tween(begin: 0.4, end: 1.0),
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      curve: Curves.elasticOut,
                                      builder: (context, scale, child) =>
                                          Transform.scale(
                                            scale: scale,
                                            child: child,
                                          ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorManger.chipProtein,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        child: Text(
                                          count > 99 ? '99+' : '$count',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      height: responsive.setHeight(5.5),
                      margin: responsive.setMargin(
                        right: isEnLocale ? null : 2,
                        left: isEnLocale ? 2 : null,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManger.primaryLight.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(
                          responsive.setBorderRadius(2),
                        ),
                      ),
                      child: Builder(
                        builder: (btnContext) {
                          return IconButton(
                            icon: Image.asset(
                              ImageAsset.chickenIcon,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Show fun Easter egg animation!
                              showFallingEggs(btnContext);
                            },
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
