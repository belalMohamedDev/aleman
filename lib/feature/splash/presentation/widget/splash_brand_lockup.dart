import 'dart:math' as math;

import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Animated brand lockup matching the reference video:
/// 1. A white circle appears in the EXACT CENTER of the screen.
/// 2. Inside the circle, the emblem logo is drawn / revealed (Sweep + Scale + Fade).
/// 3. The circular emblem glides smoothly to the RIGHT (+X).
/// 4. Separated Arabic text ("الإيمان للأعلاف") drops down from the TOP (-Y -> 0).
/// 5. Separated English text ("AI EMAN FOUNDATIONS GROUP") rises up from the BOTTOM (+Y -> 0).
/// 6. The complete lockup rests symmetrically centered on screen.
class SplashBrandLockup extends StatelessWidget {
  /// White circle scale: 0.0 -> 1.0 (with easeOutBack)
  final double circleScale;

  /// White circle opacity: 0.0 -> 1.0
  final double circleOpacity;

  /// Drawing/reveal progress of the emblem inside the circle: 0.0 -> 1.0
  final double emblemDrawProgress;

  /// Shift from center to right: 0.0 (emblem centered on screen) -> 1.0 (emblem at right)
  final double shiftProgress;

  /// Arabic text drop & fade progress: 0.0 (above/hidden) -> 1.0 (settled/visible)
  final double arabicTextProgress;

  /// English text rise & fade progress: 0.0 (below/hidden) -> 1.0 (settled/visible)
  final double englishTextProgress;

  const SplashBrandLockup({
    super.key,
    required this.circleScale,
    required this.circleOpacity,
    required this.emblemDrawProgress,
    required this.shiftProgress,
    required this.arabicTextProgress,
    required this.englishTextProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Docked emblem dimensions when fully locked with text:
    // Image aspect ratio: 995 / 1265 ≈ 0.786
    final double dockedEmblemHeight = 138.h.clamp(120.0, 155.0);
    final double dockedEmblemWidth = dockedEmblemHeight * 0.786;

    // Initial hero scale at center:
    // When centered initially (shiftProgress = 0.0), scale is ~1.30 (height ≈ 180.h).
    // As shiftProgress moves to 1.0, it smoothly scales down to 1.00 (height ≈ 138.h)
    // to match the text in perfect visual proportion.
    const double heroScaleMultiplier = 1.30;
    final double currentScaleMultiplier =
        heroScaleMultiplier -
        ((heroScaleMultiplier - 1.0) * shiftProgress.clamp(0.0, 1.0));

    // Arabic text dimensions (crop ratio: 989 / 202 ≈ 4.896)
    final double arabicHeight = 36.h.clamp(30.0, 44.0);
    final double arabicWidth = arabicHeight * 4.896;

    // English text dimensions (crop ratio: 693 / 36 ≈ 19.25)
    final double englishHeight = (arabicHeight * 0.26).clamp(8.5, 12.5);
    final double englishWidth = englishHeight * 19.25;

    // Text column layout
    final double textColumnWidth = math.max(arabicWidth, englishWidth);
    final double gap = 14.w.clamp(10.0, 20.0);

    // Total horizontal width when fully assembled in docked state
    final double totalWidth = textColumnWidth + gap + dockedEmblemWidth;

    // Center coordinates relative to screen center (0, 0):
    // Final center of emblem on the RIGHT:
    final double finalEmblemX = (textColumnWidth + gap) / 2;
    // Current emblem center (starts at 0.0 = DEAD CENTER):
    final double currentEmblemX = finalEmblemX * shiftProgress.clamp(0.0, 1.0);

    // Final center of the text column on the LEFT:
    final double finalTextX = -(dockedEmblemWidth + gap) / 2;

    return Center(
      child: SizedBox(
        width: totalWidth,
        height: math.max(
          dockedEmblemHeight,
          arabicHeight + englishHeight + 40.h,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Text Column (Arabic dropping from top, English rising from bottom)
            if (shiftProgress > 0.05)
              Padding(
                padding: EdgeInsets.only(top: 45.h),
                child: Transform.translate(
                  offset: Offset(finalTextX, 0),
                  child: SizedBox(
                    width: textColumnWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Arabic Text: "الإيمان للأعلاف" — drops down from above (-Y -> 0)
                        Transform.translate(
                          offset: Offset(
                            0,
                            -26.h * (1.0 - arabicTextProgress.clamp(0.0, 1.0)),
                          ),
                          child: Opacity(
                            opacity: arabicTextProgress.clamp(0.0, 1.0),
                            child: SizedBox(
                              width: arabicWidth,
                              height: arabicHeight,
                              child: Image.asset(
                                ImageAsset.alemanArabicText,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 7.h),

                        // English Text: "AI EMAN FOUNDATIONS GROUP" — rises up from below (+Y -> 0)
                        Transform.translate(
                          offset: Offset(
                            0,
                            22.h * (1.0 - englishTextProgress.clamp(0.0, 1.0)),
                          ),
                          child: Opacity(
                            opacity: englishTextProgress.clamp(0.0, 1.0),
                            child: SizedBox(
                              width: englishWidth,
                              height: englishHeight,
                              child: Image.asset(
                                ImageAsset.alemanEnglishText,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 2. Emblem:
            // Starts at X = 0.0 (EXACT CENTER OF SCREEN) at hero size (~180.h),
            // then glides to the RIGHT (+X) while smoothly scaling down to docked size (~138.h)
            Transform.translate(
              offset: Offset(currentEmblemX, 0),
              child: Opacity(
                opacity: circleOpacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: (circleScale * currentScaleMultiplier).clamp(0.0, 1.6),
                  child: Center(
                    child: SizedBox(
                      width: dockedEmblemWidth,
                      height: dockedEmblemHeight,
                      child: emblemDrawProgress <= 0.0
                          ? const SizedBox.shrink()
                          : ShaderMask(
                              shaderCallback: (bounds) {
                                // Sweep gradient reveal simulating drawing stroke / circular appearance
                                final double progress = emblemDrawProgress
                                    .clamp(0.0, 1.0);
                                return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: math.pi * 2,
                                  colors: const [
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  stops: [
                                    0.0,
                                    progress,
                                    (progress + 0.04).clamp(0.0, 1.0),
                                    1.0,
                                  ],
                                  transform: const GradientRotation(
                                    -math.pi / 2,
                                  ),
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Opacity(
                                opacity: emblemDrawProgress.clamp(0.0, 1.0),
                                child: Transform.scale(
                                  scale: (0.84 + (0.16 * emblemDrawProgress))
                                      .clamp(0.0, 1.0),
                                  child: Image.asset(
                                    ImageAsset.alemanEmblem,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
