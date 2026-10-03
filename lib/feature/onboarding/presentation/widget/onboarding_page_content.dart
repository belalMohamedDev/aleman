import 'package:flutter/material.dart';

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
                color: Colors.white,
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
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF142416),
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
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
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
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
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
