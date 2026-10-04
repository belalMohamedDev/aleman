import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../logic/cubit/home_cuibt_cubit.dart';

class BannerCarouselSlider extends StatelessWidget {
  const BannerCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      buildWhen: (previous, current) =>
          previous.bannersStatus != current.bannersStatus ||
          previous.bannerIndex != current.bannerIndex,
      builder: (context, state) {
        if (state.bannersStatus == RequestStatus.loading) {
          return Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: responsive.setHeight(18),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      responsive.setBorderRadius(2),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: responsive.setHeight(3),
              ), // Spacing after the banner
            ],
          );
        }

        if (state.bannersStatus == RequestStatus.error ||
            state.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        final banners = state.banners;
        final bannerIndex = state.bannerIndex;

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: responsive.setHeight(16),
                    enableInfiniteScroll: banners.length > 1,
                    autoPlay: banners.length > 1,
                    viewportFraction: 0.98,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.easeInOutCubic,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      context.read<HomeCuibtCubit>().changeBannerIndex(index);
                    },
                  ),
                  items: banners.map((banner) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                        responsive.setBorderRadius(2),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: "${ApiConstants.baseUrl}${banner.imageUrl}",
                        width: responsive.setWidth(120),
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Page Indicators (Dots) with white background & rounded border
                if (banners.length > 1)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            responsive.setBorderRadius(5),
                          ),
                          topRight: Radius.circular(
                            responsive.setBorderRadius(5),
                          ),
                        ),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banners.asMap().entries.map((entry) {
                          final isActive = bannerIndex == entry.key;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: isActive ? 18 : 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? ColorManger.primary
                                  : ColorManger.primaryLight.withValues(
                                      alpha: 0.25,
                                    ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: responsive.setHeight(2.5),
            ), // Spacing after the banner
          ],
        );
      },
    );
  }
}
