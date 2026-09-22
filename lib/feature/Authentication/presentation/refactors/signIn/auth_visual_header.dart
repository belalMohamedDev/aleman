import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthVisualHeader extends StatelessWidget {
  const AuthVisualHeader({super.key, this.onClose});

  final VoidCallback? onClose;

  // Vibrant Noon signature yellow
  static const Color noonYellow = Color(0xFFFCE000);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 250.h,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ================= Scattered Yellow Circles Collage ================= //

          // 1. Top Center-Left: Cow Circle
          Positioned(
            top: topPadding + 0.h,
            left: 20.w,
            child: _CollageItem(
              circleSize: 85.r,
              imageSize: 75.r,
              assetPath: ImageAsset.cow,
              imageOffset: const Offset(0, 0),
            ),
          ),

          // 2. Top Center: Big Feed Bag (Main Hero)
          Positioned(
            top: topPadding + 5.h,
            left: 130.w,
            child: _CollageItem(
              circleSize: 110.r,
              imageSize: 120.r,
              assetPath: ImageAsset.cart,

              imageOffset: const Offset(0, -10),
              rotation: -0.08,
            ),
          ),

          // 3. Top Right: Hen Circle
          Positioned(
            top: topPadding + 15.h,
            right: 15.w,
            child: _CollageItem(
              circleSize: 90.r,
              imageSize: 80.r,
              assetPath: ImageAsset.hen,
              imageOffset: const Offset(0, 0),
            ),
          ),

          // 4. Middle Left: Duck Circle
          Positioned(
            top: topPadding + 115.h,
            left: 10.w,
            child: _CollageItem(
              circleSize: 78.r,
              imageSize: 70.r,
              assetPath: ImageAsset.duck,
              imageOffset: const Offset(2, -2),
            ),
          ),

          // 5. Middle Center: Rabbit Bag / Cow Bag (Angled item like the iPhone in Noon)
          Positioned(
            top: topPadding + 130.h,
            left: 120.w,
            child: _CollageItem(
              circleSize: 105.r,
              imageSize: 115.r,
              assetPath: 'assets/image/cawbag.png',
              imageOffset: const Offset(0, -6),
              rotation: 0.12,
            ),
          ),

          // 6. Middle Right: Rabbit Circle
          Positioned(
            top: topPadding + 115.h,
            right: 12.w,
            child: _CollageItem(
              circleSize: 82.r,
              imageSize: 72.r,
              assetPath: ImageAsset.rabbit,
              imageOffset: const Offset(-2, 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollageItem extends StatelessWidget {
  const _CollageItem({
    required this.circleSize,
    required this.imageSize,
    required this.assetPath,
    this.imageOffset = Offset.zero,
    this.rotation = 0.0,
  });

  final double circleSize;
  final double imageSize;
  final String assetPath;
  final Offset imageOffset;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // The bright yellow circular disk
          Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AuthVisualHeader.noonYellow,
            ),
          ),

          // The product / animal popping out of the circle
          Transform.translate(
            offset: imageOffset,
            child: Transform.rotate(
              angle: rotation,
              child: Image.asset(
                assetPath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
