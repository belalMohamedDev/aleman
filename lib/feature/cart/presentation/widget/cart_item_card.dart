import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/data/model/cart_response_model.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(16.r),
            ),
            clipBehavior: Clip.antiAlias,
            child:
                item.productImageUrl != null && item.productImageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: "${ApiConstants.baseUrl}${item.productImageUrl}",
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      child: Container(
                        width: 70.w,
                        height: 70.w,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: const Color(0xFFE5E5E5),
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => _buildErrorImage(),
                  )
                : _buildErrorImage(),
          ),
          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorManger.chipForm,
                    fontSize: 13.5.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),

                Text(
                  item.packageSize != null && item.packageSize!.isNotEmpty
                      ? 'الشكارة: ${item.packageSize}'
                      : 'الوزن: ${item.packageWeightKg} كجم للشكارة',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 7.h),

                Row(
                  children: [
                    Text(
                      '${item.subtotal} ج.م',
                      style: TextStyle(
                        color: ColorManger.goldDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManger.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.weight,
                            size: 11.sp,
                            color: ColorManger.primary,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _formatItemTotalWeight(item),
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManger.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    context.read<CartCubit>().updateCartItem(
                      item.id,
                      item.quantity + 1,
                    );
                  },
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, size: 16.w, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Text(
                    '${item.quantity}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (item.quantity > 1) {
                      context.read<CartCubit>().updateCartItem(
                        item.id,
                        item.quantity - 1,
                      );
                    } else {
                      context.read<CartCubit>().deleteCartItem(item.id);
                    }
                  },
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC9C9C9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                      size: 16.w,
                      color: item.quantity == 1
                          ? Colors.black54
                          : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatItemTotalWeight(CartItemModel item) {
    final totalKg = item.totalWeightKg > 0
        ? item.totalWeightKg
        : (item.packageWeightKg * item.quantity);

    if (totalKg >= 1000) {
      final tons = totalKg / 1000.0;
      final formattedTons = (tons % 1 == 0)
          ? tons.toInt().toString()
          : tons
                .toStringAsFixed(2)
                .replaceAll(RegExp(r'0*$'), '')
                .replaceAll(RegExp(r'\.$'), '');
      return '$formattedTons طن';
    } else {
      final formattedKg = (totalKg % 1 == 0)
          ? totalKg.toInt().toString()
          : totalKg
                .toStringAsFixed(1)
                .replaceAll(RegExp(r'0*$'), '')
                .replaceAll(RegExp(r'\.$'), '');
      return '$formattedKg كجم';
    }
  }

  Widget _buildErrorImage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.priority_high, color: Colors.white, size: 20),
      ),
    );
  }
}
