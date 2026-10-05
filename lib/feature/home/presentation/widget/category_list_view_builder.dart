import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/screen/category_products_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryListViewBuilder extends StatelessWidget {
  const CategoryListViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      buildWhen: (previous, current) =>
          previous.categoriesStatus != current.categoriesStatus ||
          previous.categories != current.categories ||
          previous.selectedCategoryId != current.selectedCategoryId,
      builder: (context, state) {
        if (state.categoriesStatus == RequestStatus.loading &&
            state.categories.isEmpty) {
          return _buildShimmerList();
        }

        if (state.categoriesStatus == RequestStatus.error ||
            state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        final categories = state.categories;
        final columnCount = (categories.length / 2).ceil();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(columnCount, (colIndex) {
                  final topIndex = colIndex * 2;
                  final bottomIndex = topIndex + 1;
                  final isLast = colIndex == columnCount - 1;

                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 10.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCategoryItem(context, categories[topIndex]),
                        SizedBox(height: 12.h),
                        if (bottomIndex < categories.length)
                          _buildCategoryItem(context, categories[bottomIndex])
                        else
                          SizedBox(width: 76.w),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryEntity category) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<HomeCuibtCubit>().changeSelectedCategory(category.id);
        Navigator.of(context).pushNamed(
          Routes.categoryProductsRoute,
          arguments: CategoryProductsArgs(
            category: category,
            cubit: context.read<HomeCuibtCubit>(),
          ),
        );
      },
      child: SizedBox(
        width: 76.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 74.h,
              width: 74.w,
              decoration: BoxDecoration(
                color: ColorManger.primary.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorManger.primary.withValues(alpha: 0.02),
                  width: 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: "${ApiConstants.baseUrl}${category.imageUrl}",
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey.shade400,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: List.generate(4, (colIndex) {
              final isLast = colIndex == 3;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildShimmerItem(),
                    SizedBox(height: 12.h),
                    _buildShimmerItem(),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 74.h,
            width: 74.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 10.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      ],
    );
  }
}
