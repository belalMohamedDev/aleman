import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/utils/responsive_utils.dart';

class CategoryListViewBuilder extends StatelessWidget {
  const CategoryListViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      buildWhen: (previous, current) => previous.categoriesStatus != current.categoriesStatus || previous.selectedCategory != current.selectedCategory,
      builder: (context, state) {
        if (state.categoriesStatus == RequestStatus.loading) {
          return Column(
            children: [
              const Row(children: []),
              SizedBox(
                height: responsive.setHeight(12),
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: responsive.setPadding(left: 4.2),
                      child: Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: responsive.setHeight(8),
                              width: responsive.setHeight(8.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  responsive.setBorderRadius(2),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          responsive.setSizeBox(height: 1.5),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: responsive.setHeight(1.5),
                              width: responsive.setHeight(6),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (state.categoriesStatus == RequestStatus.error || state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        final categories = state.categories;

        return Column(
          children: [
            const Row(children: []),
            SizedBox(
              height: responsive.setHeight(12),
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = state.selectedCategory == category.name;

                  return Padding(
                    padding: responsive.setPadding(left: 4.2),
                    child: InkWell(
                      onTap: () {
                        context.read<HomeCuibtCubit>().changeSelectedCategory(category.name);
                      },
                      borderRadius: BorderRadius.circular(
                        responsive.setBorderRadius(2),
                      ),
                      child: Column(
                        children: [
                          // Category image container
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: responsive.setHeight(8),
                            width: responsive.setHeight(8.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                responsive.setBorderRadius(2),
                              ),
                              color: isSelected
                                  ? ColorManger.primary.withValues(alpha: 0.05)
                                  : ColorManger.primaryLight.withValues(
                                      alpha: 0.04,
                                    ),
                              border: isSelected
                                  ? Border.all(
                                      color: ColorManger.primaryLight.withValues(
                                        alpha: 0.02,
                                      ),
                                      width: 2,
                                    )
                                  : Border.all(color: Colors.transparent, width: 2),
                            ),
                            child: Padding(
                              padding: responsive.setPadding(
                                top: 1.5,
                                bottom: 1.5,
                                left: 1.5,
                                right: 1.5,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: "${ApiConstants.baseUrl}${category.imageUrl}",
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          responsive.setSizeBox(
                            height: 1.5,
                          ), // Space between image and title
                          // Category title
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: responsive.setTextSize(3.2),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected ? ColorManger.primary : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
