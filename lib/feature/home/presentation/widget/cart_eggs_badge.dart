import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartEggsBadge extends StatelessWidget {
  const CartEggsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CartAnimationHelper.cartEggsCountNotifier,
      builder: (context, eggCount, _) {
        if (eggCount <= 0) return const SizedBox.shrink();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Layer 1 - Bottom of the basket
            if (eggCount >= 1)
              PositionedDirectional(
                top: 14.h,
                start: 8.w,
                child: const _SingleCartEgg(size: 16, angle: -0.20),
              ),

            if (eggCount >= 2)
              PositionedDirectional(
                top: 12.h,
                start: 22.w,
                child: const _SingleCartEgg(size: 16, angle: 0.16),
              ),

            // Layer 2 - Middle heap
            if (eggCount >= 3)
              PositionedDirectional(
                top: 6.h,
                start: 14.w,
                child: const _SingleCartEgg(size: 17, angle: 0.22),
              ),

            if (eggCount >= 4)
              PositionedDirectional(
                top: 4.h,
                start: 26.w,
                child: const _SingleCartEgg(size: 17, angle: -0.15),
              ),

            // Layer 3 - Top overflow
            if (eggCount >= 5)
              PositionedDirectional(
                top: -2.h,
                start: 18.w,
                child: const _SingleCartEgg(size: 18, angle: 0.05),
              ),

            if (eggCount >= 6)
              PositionedDirectional(
                top: -8.h,
                start: 25.w,
                child: const _SingleCartEgg(size: 18, angle: -0.10),
              ),

            // Golden Egg Badge Counter (Top End to avoid regular cart badge)
            // PositionedDirectional(
            //   top: -8.h,
            //   end: -6.w,
            //   child: TweenAnimationBuilder<double>(
            //     key: ValueKey(eggCount),
            //     duration: const Duration(milliseconds: 250),
            //     curve: Curves.elasticOut,
            //     tween: Tween<double>(begin: 0.5, end: 1.0),
            //     builder: (context, scale, child) {
            //       return Transform.scale(
            //         scale: scale,
            //         child: Container(
            //           padding: EdgeInsets.symmetric(
            //             horizontal: 6.w,
            //             vertical: 2.h,
            //           ),
            //           decoration: BoxDecoration(
            //             gradient: const LinearGradient(
            //               colors: [Color(0xFFFFD500), Color(0xFFF59E0B)],
            //               begin: Alignment.topLeft,
            //               end: Alignment.bottomRight,
            //             ),
            //             borderRadius: BorderRadius.circular(12.r),
            //             border: Border.all(color: Colors.white, width: 1.5),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withValues(alpha: 0.25),
            //                 blurRadius: 6,
            //                 offset: const Offset(0, 2),
            //               ),
            //             ],
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Image.asset(
            //                 ImageAsset.eggIcon,
            //                 width: 12.w,
            //                 height: 12.h,
            //               ),
            //               SizedBox(width: 2.w),
            //               Text(
            //                 'x$eggCount',
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 10.5.sp,
            //                   fontWeight: FontWeight.w900,
            //                   shadows: const [
            //                     Shadow(
            //                       color: Colors.black26,
            //                       blurRadius: 2,
            //                       offset: Offset(0, 1),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class _SingleCartEgg extends StatelessWidget {
  const _SingleCartEgg({required this.size, required this.angle});

  final double size;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: angle,
            child: Image.asset(
              ImageAsset.eggIcon,
              width: size.w,
              height: size.h,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
