import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/utils/responsive_utils.dart';

class NewProductGrideView extends StatelessWidget {
  final String selectedCategory;

  const NewProductGrideView({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    final List<Map<String, dynamic>> allDemoProducts = [
      // دواجن
      {
        'name': 'علف دواجن بادي 23%',
        'price': '850 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف دواجن نامي 21%',
        'price': '830 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف دواجن ناهي 19%',
        'price': '810 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف كتاكيت بادي 24%',
        'price': '870 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف بياض إنتاجي 16%',
        'price': '750 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف بياض بادي 18%',
        'price': '780 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف بياض نامي 14%',
        'price': '730 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      {
        'name': 'علف دواجن تسمين 22%',
        'price': '840 ج.م',
        'image': 'assets/image/henbag.png',
        'category': 'علف دواجن',
      },
      // ماشية
      {
        'name': 'علف ماشية حلاب 18%',
        'price': '720 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف ماشية تسمين 14%',
        'price': '700 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف عجول بادي 20%',
        'price': '750 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف ماشية حلاب 21%',
        'price': '760 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف ماشية حلاب 16%',
        'price': '680 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف عجول نامي 18%',
        'price': '720 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف ماشية صيانة 12%',
        'price': '650 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      {
        'name': 'علف ماشية جاف 14%',
        'price': '670 ج.م',
        'image': 'assets/image/cawbag.png',
        'category': 'علف ماشية',
      },
      // بط
      {
        'name': 'علف بط بادي 22%',
        'price': '710 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط تسمين',
        'price': '680 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط بياض',
        'price': '700 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط نامي 20%',
        'price': '690 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط ناهي 18%',
        'price': '670 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط تسمين سوبر',
        'price': '720 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط إنتاجي 16%',
        'price': '650 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      {
        'name': 'علف بط تسمين مبكر',
        'price': '700 ج.م',
        'image': 'assets/image/dugbag.png',
        'category': 'علف بط',
      },
      // أرانب
      {
        'name': 'علف أرانب مرضع',
        'price': '900 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب تسمين',
        'price': '870 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب صيانة',
        'price': '850 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب فطام 18%',
        'price': '880 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب حوامل',
        'price': '890 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب إحلال',
        'price': '860 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب تسمين سوبر',
        'price': '920 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
      {
        'name': 'علف أرانب ذكور',
        'price': '840 ج.م',
        'image': 'assets/image/rabbitbag.png',
        'category': 'علف ارانب',
      },
    ];

    final List<Map<String, dynamic>> demoProducts = allDemoProducts
        .where((p) => p['category'] == selectedCategory)
        .toList();

    if (demoProducts.isEmpty) {
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
        // Grid View
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // Scroll handled by SingleChildScrollView
          shrinkWrap: true,
          itemCount: demoProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72, // Adjusts height vs width of cards
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final product = demoProducts[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorManger.primaryLight.withValues(alpha: 0.06),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          product['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),

                  // Details Section
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.setTextSize(3.2),
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['price'],
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    color: ColorManger.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ColorManger.primaryLight.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(8),
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
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
