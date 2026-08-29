import 'package:flutter/material.dart';

import '../../data/models/onboarding_item_model.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageHeight = (size.height * 0.42).clamp(240.0, 380.0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Hero Image Container
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft background radial glow behind image
                Positioned(
                  bottom: 20,
                  child: Container(
                    width: 220,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF78DC3D)
                              .withValues(alpha: 0.12),
                          blurRadius: 70,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                // Asset image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.contain,
                    // filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Main Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.25,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // 3. Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFFC2F38A),
                height: 1.3,
              ),
            ),
          ),

          // 4. Badges (for page 2 or any page with badges)
          if (item.badges != null && item.badges!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: item.badges!.map((badge) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B381C).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF78DC3D).withValues(alpha: 0.4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE2FBD2),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // 5. Description Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.72),
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
