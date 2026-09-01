import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/utils/responsive_utils.dart';

class BannerCarouselSlider extends StatefulWidget {
  const BannerCarouselSlider({super.key});

  @override
  State<BannerCarouselSlider> createState() => _BannerCarouselSliderState();
}

class _BannerCarouselSliderState extends State<BannerCarouselSlider> {
  int _currentIndex = 0;

  final List<String> demoBanners = [
    'assets/image/banner_1.png',
    'assets/image/banner_2.png',
    'assets/image/banner_3.png',
    'assets/image/banner_4.png',
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: responsive.setHeight(
              18,
            ), // Increased slightly for better visibility
            enableInfiniteScroll: true,
            autoPlay: true,
            viewportFraction:
                0.98, // Changed from 1.1 to 0.98 for better padding
            enlargeCenterPage: true, // Added for a nice visual effect
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.easeInOutCubic,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: demoBanners
              .map(
                (imagePath) => ClipRRect(
                  borderRadius: BorderRadius.circular(
                    responsive.setBorderRadius(2),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: responsive.setWidth(120),
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        // Page Indicators (Dots)
        SizedBox(height: responsive.setHeight(2.5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(demoBanners.length, (index) {
            bool isActive = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 24 : 8, // Active dot is wider (pill shape)
              decoration: BoxDecoration(
                color: isActive
                    ? ColorManger.primary
                    : ColorManger.primaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
