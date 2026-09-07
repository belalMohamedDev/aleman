import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CartLoadingScreen extends StatelessWidget {
  const CartLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // Content
            // =========================
            Expanded(
              child: Shimmer.fromColors(
                baseColor: const Color(0xFFE4E4E4),
                highlightColor: const Color(0xFFF8F8F8),
                period: const Duration(milliseconds: 1200),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  children: const [
                    _CartLoadingCard(),
                    SizedBox(height: 14),

                    _CartLoadingCard(),
                    SizedBox(height: 14),

                    _CartLoadingCard(),
                    SizedBox(height: 14),

                    _CartLoadingCard(),

                    SizedBox(height: 18),

                    _CartSummaryLoading(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartLoadingCard extends StatelessWidget {
  const _CartLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =========================
          // Image
          // =========================
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          const SizedBox(width: 14),

          // =========================
          // Details
          // =========================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name
                const _SkeletonLine(width: double.infinity, height: 14),

                const SizedBox(height: 8),

                // Weight
                const _SkeletonLine(width: 100, height: 10),

                const SizedBox(height: 7),

                // // Price
                // const _SkeletonLine(width: 70, height: 13),
                const SizedBox(height: 10),

                // Quantity
                Container(
                  width: 90,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // =========================
          // Delete
          // =========================
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonLine({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _CartSummaryLoading extends StatelessWidget {
  const _CartSummaryLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _SkeletonLine(width: 90, height: 13),
              _SkeletonLine(width: 55, height: 13),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _SkeletonLine(width: 70, height: 12),
              _SkeletonLine(width: 80, height: 12),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      ),
    );
  }
}
