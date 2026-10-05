import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_state.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'product_details_bottom_sheet.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isCompact;

  const ProductCard({super.key, required this.product, this.isCompact = false});

  String _getEffectiveDescription() {
    if (product.description.trim().isNotEmpty) {
      return product.description.trim();
    }
    final parts = <String>[];
    if (product.proteinPercentage > 0) {
      parts.add('بروتين ${product.proteinPercentage.toStringAsFixed(0)}%');
    }
    if (product.weightPerSackKg > 0) {
      parts.add('شيكارة ${product.weightPerSackKg.toStringAsFixed(0)} كجم');
    }
    if (parts.isNotEmpty) {
      return parts.join(' • ');
    }
    if (product.ingredients.trim().isNotEmpty) {
      return product.ingredients.trim();
    }
    return 'علف متوازن عالي الجودة';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return GestureDetector(
      onTap: () {
        final cubit = context.read<HomeCuibtCubit>();
        final cartCubit = context.read<CartCubit>();
        cubit.resetQuantity();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider.value(value: cartCubit),
            ],
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ProductDetailsBottomSheet(product: product),
            ),
          ),
        );
      },
      child: isCompact
          ? _buildCompactCard(context)
          : _buildFullCard(context, responsive),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEFF0F3), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(13.r),
                    ),
                  ),
                  padding: EdgeInsets.all(6.w),
                  child: CachedNetworkImage(
                    imageUrl: "${ApiConstants.baseUrl}${product.imageUrl}",
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
                if (product.isFeatured)
                  PositionedDirectional(
                    top: 6.h,
                    start: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManger.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.star1,
                            color: ColorManger.gold,
                            size: 8.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'مميز',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                PositionedDirectional(
                  top: 8.h,
                  end: 5.w,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    buildWhen: (previous, current) =>
                        previous.isProductWishlisted(product.id) !=
                        current.isProductWishlisted(product.id),
                    builder: (context, wishlistState) {
                      final isWishlisted = wishlistState.isProductWishlisted(
                        product.id,
                      );
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.read<WishlistCubit>().toggleWishlist(
                            product.id,
                            itemToAdd: product.toWishlistItemEntity(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black.withValues(alpha: 0.0),
                              //   blurRadius: 0,
                              //   offset: const Offset(0, 1),
                              // ),
                            ],
                          ),
                          child: Icon(
                            isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                            color: isWishlisted
                                ? const Color(0xFFE11D48)
                                : Colors.grey.shade400,
                            size: 18.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          fontSize: 11.5.sp,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _getEffectiveDescription(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 9.5.sp,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${product.price}',
                              style: TextStyle(
                                color: ColorManger.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.sp,
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ج.م',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: 9.sp,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 26.w,
                        height: 26.w,
                        decoration: BoxDecoration(
                          color: ColorManger.primaryLight,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Iconsax.bag_happy,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCard(BuildContext context, ResponsiveUtils responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100, width: 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorManger.primaryLight.withValues(alpha: 0.16),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "${ApiConstants.baseUrl}${product.imageUrl}",
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                if (product.isFeatured)
                  PositionedDirectional(
                    top: 8.h,
                    start: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManger.primary,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.star1,
                            color: ColorManger.gold,
                            size: 10.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'مميز',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                PositionedDirectional(
                  top: 8.h,
                  end: 8.w,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    buildWhen: (previous, current) =>
                        previous.isProductWishlisted(product.id) !=
                        current.isProductWishlisted(product.id),
                    builder: (context, wishlistState) {
                      final isWishlisted = wishlistState.isProductWishlisted(
                        product.id,
                      );
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.read<WishlistCubit>().toggleWishlist(
                            product.id,
                            itemToAdd: product.toWishlistItemEntity(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black.withValues(alpha: 0.08),
                              //   blurRadius: 4,
                              //   offset: const Offset(0, 1),
                              // ),
                            ],
                          ),
                          child: Icon(
                            isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                            color: isWishlisted
                                ? const Color(0xFFE11D48)
                                : Colors.grey.shade400,
                            size: 16.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorManger.primary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Expanded(
                    child: Text(
                      _getEffectiveDescription(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 9.5.sp,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${product.price} ج.م',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ColorManger.goldDark,
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.setTextSize(3.6),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: ColorManger.primaryLight.withValues(
                            alpha: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Iconsax.bag_happy,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
