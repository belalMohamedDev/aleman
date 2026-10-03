import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/screen/empty_product.dart';
import 'package:aleman/feature/home/presentation/widget/product_card.dart';
import 'package:aleman/feature/home/presentation/widget/product_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductsArgs {
  final CategoryEntity category;
  final HomeCuibtCubit? cubit;

  const CategoryProductsArgs({required this.category, this.cubit});
}

class CategoryProductsScreen extends StatelessWidget {
  final CategoryEntity category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      buildWhen: (previous, current) =>
          previous.productsStatus != current.productsStatus ||
          previous.selectedCategoryId != current.selectedCategoryId ||
          previous.categories != current.categories,
      builder: (context, state) {
        final currentCategoryId = state.selectedCategoryId;
        final selectedCat = state.categories.firstWhere(
          (c) => c.id == currentCategoryId,
          orElse: () => category,
        );

        final filteredProducts = state.products
            .where((p) => p.categoryId == currentCategoryId)
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAF8),
          appBar: AppBar(
            backgroundColor: ColorManger.white,
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Iconsax.arrow_right_3, color: ColorManger.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              selectedCat.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
                fontFamily: 'Cairo',
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Iconsax.search_normal_1, color: ColorManger.primary),
                tooltip: 'بحث',
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(
                      products: state.products,
                      cartCubit: context.read<CartCubit>(),
                      homeCubit: context.read<HomeCuibtCubit>(),
                    ),
                  );
                },
              ),
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (prev, curr) =>
                    prev.totalItemsCount != curr.totalItemsCount,
                builder: (context, cartState) {
                  final count = cartState.totalItemsCount;
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 8.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Iconsax.bag_happy,
                            color: ColorManger.primary,
                          ),
                          tooltip: 'السلة',
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.cartRoute);
                          },
                        ),
                        if (count > 0)
                          PositionedDirectional(
                            top: 6.h,
                            start: 6.w,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: ColorManger.chipProtein,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16.w,
                                minHeight: 16.w,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: _buildProductsBody(
            context,
            state,
            filteredProducts,
            selectedCat,
          ),
        );
      },
    );
  }

  Widget _buildProductsBody(
    BuildContext context,
    HomeCuibtState state,
    List<dynamic> products,
    CategoryEntity currentCat,
  ) {
    if (state.productsStatus == RequestStatus.loading) {
      return _buildShimmerGrid();
    }

    if (state.productsStatus == RequestStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.w, color: Colors.grey),
            SizedBox(height: 12.h),
            Text(
              state.productsError ?? 'حدث خطأ أثناء تحميل المنتجات',
              style: TextStyle(fontSize: 14.sp, color: ColorManger.grey),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {
                context.read<HomeCuibtCubit>().fetchProducts();
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return EmptyCategoryProduct();

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       // Container(
      //       //   width: 72.w,
      //       //   height: 72.w,
      //       //   decoration: BoxDecoration(
      //       //     color: ColorManger.iconsBackgroundColor,
      //       //     shape: BoxShape.circle,
      //       //   ),
      //       //   child: Icon(
      //       //     Icons.inventory_2_outlined,
      //       //     size: 34.w,
      //       //     color: ColorManger.primaryLight,
      //       //   ),
      //       // ),
      //       Image.asset(ImageAsset.noProduct),
      //       SizedBox(height: 16.h),
      //       Text(
      //         'لا توجد منتجات في قسم "${currentCat.name}" حالياً',
      //         style: TextStyle(
      //           fontSize: 15.sp,
      //           fontWeight: FontWeight.bold,
      //           color: ColorManger.primary,
      //           fontFamily: 'Cairo',
      //         ),
      //       ),
      //       SizedBox(height: 6.h),
      //       Text(
      //         'سيتم إضافة منتجات جديدة لهذا القسم قريباً',
      //         style: TextStyle(
      //           fontSize: 12.sp,
      //           color: ColorManger.grey,
      //           fontFamily: 'Cairo',
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return TweenAnimationBuilder<double>(
          key: ValueKey('cat_screen_prod_${product.id}'),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 280 + (index.clamp(0, 6) * 40)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            final clampedVal = value.clamp(0.0, 1.0);
            return Opacity(
              opacity: clampedVal,
              child: Transform.translate(
                offset: Offset(0, (1.0 - clampedVal) * 18),
                child: child,
              ),
            );
          },
          child: ProductCard(product: product),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }
}
