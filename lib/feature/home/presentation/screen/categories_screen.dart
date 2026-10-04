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

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Soft, harmonious pastel tints for category image backgrounds
  static const List<Color> _containerBackgroundColors = [
    Color(0xFFEFF7F2), // Soft mint / sage
    Color(0xFFFDF8EE), // Warm wheat / cream
    Color(0xFFF2F6EE), // Soft olive / natural
    Color(0xFFFEF9F0), // Pale amber / corn
    Color(0xFFEDF5F0), // Fresh leaf green
    Color(0xFFF9F5EE), // Warm oatmeal
  ];

  static const List<Color> _borderColors = [
    Color(0xFFD6EADA),
    Color(0xFFEFE2C7),
    Color(0xFFDDE8D7),
    Color(0xFFF3E5CE),
    Color(0xFFD0E8D7),
    Color(0xFFE8DECD),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
        buildWhen: (previous, current) =>
            previous.categoriesStatus != current.categoriesStatus ||
            previous.categories != current.categories,
        builder: (context, state) {
          if (state.categoriesStatus == RequestStatus.loading &&
              state.categories.isEmpty) {
            return _buildShimmerGrid();
          }

          if (state.categoriesStatus == RequestStatus.error &&
              state.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: ColorManger.redError,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'تعذر تحميل الأقسام',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextButton.icon(
                    onPressed: () {
                      context.read<HomeCuibtCubit>().fetchHomeData();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: TextButton.styleFrom(
                      foregroundColor: ColorManger.primaryLight,
                    ),
                  ),
                ],
              ),
            );
          }

          final categories = state.categories;

          if (categories.isEmpty) {
            return Center(
              child: Text(
                'لا توجد أقسام حالياً',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
            );
          }

          return RefreshIndicator(
            color: ColorManger.primary,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await context.read<HomeCuibtCubit>().fetchHomeData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 65.h,
                bottom: 20.h,
              ),
              child: _build3ColumnStaggeredGrid(context, categories),
            ),
          );
        },
      ),
    );
  }

  Widget _build3ColumnStaggeredGrid(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    final col0 = <MapEntry<int, CategoryEntity>>[];
    final col1 = <MapEntry<int, CategoryEntity>>[];
    final col2 = <MapEntry<int, CategoryEntity>>[];

    for (int i = 0; i < categories.length; i++) {
      if (i % 3 == 0) {
        col0.add(MapEntry(i, categories[i]));
      } else if (i % 3 == 1) {
        col1.add(MapEntry(i, categories[i]));
      } else {
        col2.add(MapEntry(i, categories[i]));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 0
        Expanded(
          child: Column(
            children: col0.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildCategoryItem(
                  context: context,
                  category: entry.value,
                  index: entry.key,
                  containerHeight: _getItemHeight(entry.key),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: 10.w),
        // Column 1
        Expanded(
          child: Column(
            children: col1.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildCategoryItem(
                  context: context,
                  category: entry.value,
                  index: entry.key,
                  containerHeight: _getItemHeight(entry.key),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: 10.w),
        // Column 2
        Expanded(
          child: Column(
            children: col2.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildCategoryItem(
                  context: context,
                  category: entry.value,
                  index: entry.key,
                  containerHeight: _getItemHeight(entry.key),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Staggered heights to give varied, dynamic character across the 3 columns
  double _getItemHeight(int index) {
    switch (index % 6) {
      case 0:
        return 155.h;
      case 1:
        return 124.h;
      case 2:
        return 144.h;
      case 3:
        return 128.h;
      case 4:
        return 150.h;
      case 5:
        return 134.h;
      default:
        return 135.h;
    }
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required CategoryEntity category,
    required int index,
    required double containerHeight,
  }) {
    final bgColor =
        _containerBackgroundColors[index % _containerBackgroundColors.length];
    final borderColor = _borderColors[index % _borderColors.length];

    return InkWell(
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
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category image container with custom height and refined background color
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: containerHeight,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.7),
                width: 0.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 3.h),
              child: CachedNetworkImage(
                imageUrl: "${ApiConstants.baseUrl}${category.imageUrl}",
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.white.withValues(alpha: 0.6),
                  highlightColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Category title
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.bold,
              color: ColorManger.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 65.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildShimmerItem(155.h),
                SizedBox(height: 12.h),
                _buildShimmerItem(128.h),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              children: [
                _buildShimmerItem(124.h),
                SizedBox(height: 12.h),
                _buildShimmerItem(150.h),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              children: [
                _buildShimmerItem(144.h),
                SizedBox(height: 12.h),
                _buildShimmerItem(134.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem(double height) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 10.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
