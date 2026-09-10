import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/fonts/styles_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import 'product_card.dart';

import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';

class ProductSearchDelegate extends SearchDelegate<ProductEntity?> {
  final List<ProductEntity> products;
  final CartCubit cartCubit;
  final HomeCuibtCubit homeCubit;

  ProductSearchDelegate({
    required this.products,
    required this.cartCubit,
    required this.homeCubit,
  });

  @override
  String get searchFieldLabel => 'ابحث عن منتج...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        border: InputBorder.none,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: ColorManger.primary),
        elevation: 0,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: ColorManger.primary),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      BlocProvider.value(
        value: cartCubit,
        child: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) =>
              previous.totalItemsCount != current.totalItemsCount,
          builder: (context, cartState) {
            if (!homeCubit.state.isLoggedIn) {
              return const SizedBox.shrink();
            }
            final count = cartState.totalItemsCount;
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                IconButton(
                  key: CartAnimationHelper.cartSearchKey,
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.cartRoute);
                  },
                  icon: SizedBox(
                    height: 50.h,
                    child: Image.asset(ImageAsset.cart),
                  ),
                ),
                // IconButton(
                //   key: CartAnimationHelper.cartSearchKey,
                //   icon: const Icon(Iconsax.bag_happy4, size: 24),
                //   onPressed: () {
                //     Navigator.of(context).pushNamed(Routes.cartRoute);
                //   },
                // ),
                if (count > 0)
                  Positioned(
                    top: 3,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManger.chipProtein,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      const SizedBox(width: 8),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Iconsax.arrow_right_3, color: ColorManger.primary),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: cartCubit),
      ],
      child: _buildProductList(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: cartCubit),
      ],
      child: _buildProductList(context),
    );
  }

  Widget _buildProductList(BuildContext context) {
    final List<ProductEntity> filteredProducts = products.where((product) {
      final nameLower = product.name.toLowerCase();
      final descLower = product.description.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) || descLower.contains(queryLower);
    }).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImageAsset.search, width: 280.w, height: 280.w),

                SizedBox(height: 8.h),
                Text(
                  'لم نجد ما يطابق بحثك حالياً.',
                  style: getBoldStyle(
                    fontSize: 18.sp,
                    color: ColorManger.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.h),
                Text(
                  'جرّب البحث بكلمات مختلفة\n أو تأكد من اسم المنتج.',
                  style: getRegularStyle(
                    fontSize: 14.sp,
                    color: ColorManger.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 150.h),
              ],
            ),
          ),
        ),
      );

      //  Padding(
      //   padding: EdgeInsets.only(top: 30.h, left: 35.w, right: 20.w),
      //   child: Image.asset(ImageAsset.search, height: 480.h),
      // );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: filteredProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.80,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: filteredProducts[index]);
        },
      ),
    );
  }
}
