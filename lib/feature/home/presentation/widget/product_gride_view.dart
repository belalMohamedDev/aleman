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
        if (state.productsStatus == RequestStatus.loading ||
            state.categoriesStatus == RequestStatus.loading) {
          return GridView.builder(
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
          return const SizedBox.shrink();
        }

        final filteredProducts = state.products
            .where((p) => p.categoryId == state.selectedCategoryId)
            .toList();

        if (filteredProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'لا توجد منتجات في هذا القسم حالياً',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        return Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            ),
          ],
        );
      },
    );
  }
}
