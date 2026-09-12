import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'product_card.dart';

class NewProductGrideView extends StatelessWidget {
  const NewProductGrideView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      buildWhen: (previous, current) =>
          previous.productsStatus != current.productsStatus ||
          previous.categoriesStatus != current.categoriesStatus ||
          previous.selectedCategoryId != current.selectedCategoryId,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          layoutBuilder: (currentChild, previousChildren) =>
              currentChild ?? const SizedBox.shrink(),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.03),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: child,
              ),
            );
          },
          child: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeCuibtState state) {
    if (state.productsStatus == RequestStatus.loading ||
        state.categoriesStatus == RequestStatus.loading) {
      return GridView.builder(
        key: const ValueKey('loading_shimmer_grid'),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
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
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      );
    }

    if (state.productsStatus == RequestStatus.error) {
      return const SizedBox.shrink(key: ValueKey('error_state'));
    }

    final filteredProducts = state.products
        .where((p) => p.categoryId == state.selectedCategoryId)
        .toList();

    if (filteredProducts.isEmpty) {
      return Container(
        key: ValueKey('empty_category_${state.selectedCategoryId}'),
        padding: const EdgeInsets.symmetric(vertical: 44.0, horizontal: 20.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ColorManger.iconsBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 30,
                color: ColorManger.primaryLight,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'لا توجد منتجات في هذا القسم حالياً',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManger.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return KeyedSubtree(
      key: ValueKey('cat_products_grid_${state.selectedCategoryId}'),
      child: Column(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(
                  'cat_${state.selectedCategoryId}_product_${product.id}',
                ),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(
                  milliseconds: 320 + (index.clamp(0, 6) * 45),
                ),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  final clampedVal = value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: clampedVal,
                    child: Transform.translate(
                      offset: Offset(0, (1.0 - clampedVal) * 22),
                      child: Transform.scale(
                        scale: 0.88 + (0.12 * value),
                        child: child,
                      ),
                    ),
                  );
                },
                child: ProductCard(product: product),
              );
            },
          ),
        ],
      ),
    );
  }
}
