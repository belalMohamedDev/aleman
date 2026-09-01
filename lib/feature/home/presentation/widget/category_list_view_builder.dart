import 'package:flutter/material.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/utils/responsive_utils.dart';

class CategoryListViewBuilder extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryListViewBuilder({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    final List<Map<String, String>> demoCategories = [
      {'title': 'علف ارانب', 'image': 'assets/image/rabbit.png'},
      {'title': 'علف بط', 'image': 'assets/image/duck.png'},
      {'title': 'علف دواجن', 'image': 'assets/image/hen.png'},
      {'title': 'علف ماشية', 'image': 'assets/image/cow.png'},
    ];

    return Column(
      children: [
        Row(children: []),
        SizedBox(
          height: responsive.setHeight(12),
          child: ListView.builder(
            itemCount: demoCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = demoCategories[index];
              final isSelected = selectedCategory == category['title'];

              return Padding(
                padding: responsive.setPadding(left: 4.2),
                child: InkWell(
                  onTap: () {
                    onCategorySelected(category['title']!);
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
                          child: Image.asset(
                            category['image']!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
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
                        category['title']!,
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
  }
}
