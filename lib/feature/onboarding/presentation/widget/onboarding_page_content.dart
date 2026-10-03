import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/color/color_manger.dart';
import '../../../../core/style/fonts/font_manger.dart';
import '../../data/models/onboarding_item_model.dart';
import 'curved_card_clipper.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItemModel item;
  final double cardHeight;

  const OnboardingPageContent({
    super.key,
    required this.item,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: cardHeight,
          child: CustomPaint(
            painter: const CurvedCardShadowPainter(curveHeight: 28.0),
            child: ClipPath(
              clipper: const CurvedCardClipper(curveHeight: 28.0),
              child: Container(
                color: ColorManger.white,
                padding: const EdgeInsets.fromLTRB(28.0, 42.0, 28.0, 0.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 23.sp,
                              fontWeight: FontWeightManger.extraBold,
                              color: ColorManger.onboardingTitle,
                              height: 1.25,
                              letterSpacing: -0.3,
                            ),
                      ),

                      // Subtitle
                      if (item.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeightManger.bold,
                                color: ColorManger.onboardingSubtitle,
                                height: 1.3,
                              ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Description
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeightManger.regular,
                              color: ColorManger.onboardingDescription,
                              height: 1.55,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: cardHeight - 0.0,
          child: Image.asset(
            item.image,
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            filterQuality: FilterQuality.high,
          ),
        ),
      ],
    );
  }
}
