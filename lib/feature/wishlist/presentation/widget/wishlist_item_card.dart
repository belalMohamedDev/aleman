import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/product_details_bottom_sheet.dart';
import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItemEntity item;

  const WishlistItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEFF0F3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
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
                  child: ProductDetailsBottomSheet(
                    product: item.toProductEntity(),
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConstants.baseUrl}${item.productImageUrl}',
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.productName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.productDescription != null &&
                          item.productDescription!.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          item.productDescription!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Text(
                            '${item.price}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: ColorManger.primary,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'ج.م',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (item.proteinPercentage != null &&
                              item.proteinPercentage! > 0) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    ColorManger.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'بروتين ${item.proteinPercentage!.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: ColorManger.primary,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions: Remove from Wishlist & Add to Cart
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Iconsax.heart5,
                        color: const Color(0xFFE11D48),
                        size: 22.sp,
                      ),
                      tooltip: 'حذف من المفضلة',
                      onPressed: () {
                        context
                            .read<WishlistCubit>()
                            .removeFromWishlist(item.productId);
                      },
                    ),
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: ColorManger.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Iconsax.bag_happy,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        tooltip: 'إضافة للسلة',
                        onPressed: () {
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: ProductDetailsBottomSheet(
                                  product: item.toProductEntity(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
