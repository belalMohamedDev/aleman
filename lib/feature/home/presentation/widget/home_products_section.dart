import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/presentation/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeProductsSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final List<ProductEntity> products;
  final bool isLoading;
  final VoidCallback? onSeeAllTap;

  const HomeProductsSection({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    required this.products,
    this.isLoading = false,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return _buildShimmerSection(context);
    }

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
            ),
            // const Spacer(),
            // TextButton(
            //   onPressed: () {
            //     HapticFeedback.lightImpact();
            //     if (onSeeAllTap != null) {
            //       onSeeAllTap!();
            //     } else {
            //       context.read<BottomNavCubit>().changeTab(1);
            //     }
            //   },
            //   style: TextButton.styleFrom(
            //     padding: EdgeInsets.zero,
            //     minimumSize: Size.zero,
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   child: Text(
            //     'عرض الكل',
            //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //       fontSize: 12.sp,
            //       fontWeight: FontWeight.w600,
            //       color: ColorManger.primaryLight,
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 18.h),
        SizedBox(
          height: 228.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            padding: EdgeInsets.only(bottom: 6.h, top: 2.h),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: 150.w,
                child: ProductCard(product: product, isCompact: true),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 228.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 130.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
